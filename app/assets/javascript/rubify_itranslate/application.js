// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ./jquery.tipTip.minified

function formatOddEvenEntries() {
  var counter = 0
  $("table.itranslated-table tr").each(function() {
    if($(this).hasClass("hidden") == false) {
      $(this).removeClass("odd").removeClass("even");
      if(counter % 2 == 0) {
        $(this).addClass("even");
      }//end if
      if(counter % 2 == 1) {
        $(this).addClass("odd");
      }//end if
      counter += 1;
    }//end if
  });
}

function loadTranslation(lang) {
  $("table.itranslated-table tr.hidden").removeClass("hidden");
  var url= '/itranslate/load_language?lang=' + lang;
  $("table.itranslated-table").find("th:last").html(lang);
  $("table.itranslated-table").find("td.translated-needed").html("");
  $(".stage").find("div.filters:first").find("a").removeClass("active");
  $(".stage").find("div.filters:first").find("a:first").addClass("active");
  $("table.itranslated-table").css({opacity: 0.5});
  $("#itranslated_loading_icon").removeClass("hidden");
  $.getJSON(url, function(jsonObj) {
    for(var attr in jsonObj) {
      if( jsonObj[attr] instanceof Array ) {
        for(var i = 0; i < jsonObj[attr].length; i++) {
          $("td[key='" + attr + "[" + i + "]']").last().html("<span>" + jsonObj[attr][i] + "</span>");
        }//end for
      } else  {
        $("td[key='" + attr + "']").last().html("<span>" + jsonObj[attr] + "</span>");
      }//end else
    }//end for
    $("table.itranslated-table").css({opacity: 1})
    $("#itranslated_loading_icon").addClass("hidden");
  }); 
}//end loadTranslation

$(document).ready(function(){
  
  $("div.counter").tipTip({maxWidth: "auto"});
  var firstAvailableLanguage = $('.language-list').find("input:first").val();
  $('.language-list').find("input:first").attr("checked", "checked");
  loadTranslation(firstAvailableLanguage);
  
  $(document.body).delegate("a.untranslated-link", "click", function(event) {
    var untranslatedEntriesCounter = 0
    $("table.itranslated-table td.translated-needed").each(function() {
      if($(this).find("span:first").length > 0 && $(this).find("span:first").html() != "") {
        $(this).parents("tr:first").addClass("hidden");
      }//end if
      else {
        untranslatedEntriesCounter++;
      }//end else
    });
    
    if(untranslatedEntriesCounter == 0) {
      $("table.itranslated-table tbody").append("<tr class='horray'><td colspan='4'><span>Horray... No more text need to be translated</span></td></tr>")
    }//end if
    else {
      $("table.itranslated-table tbody").find("tr.horray").remove();
    }//end else
    
    $(this).parents("div.filters:first").find("a").removeClass("active");
    $(this).addClass("active");
    formatOddEvenEntries();
    return false;
  });
  
  $(document.body).delegate("a.alltranslated-link", "click", function(event) {
    $("table.itranslated-table tbody").find("tr.horray").remove();
    $("table.itranslated-table tr.hidden").removeClass("hidden");
    $(this).parents("div.filters:first").find("a").removeClass("active");
    $(this).addClass("active");    
    formatOddEvenEntries();
    return false;
  });
  
  $(document.body).delegate('input.language-select','click',function(event){
    loadTranslation($(this).val());
  });
  
  $(document.body).delegate('td.translated-needed','dblclick',function(event){
    $(this).parents("table:first").find("textarea").remove();
    $(this).parents("table:first").find("span.hidden").removeClass("hidden");
    
    if($(this).find("span:first").length == 0) {
      $(this).append("<span></span>");
    }//end if
    
    var value = $(this).find("span:first").text();
    $(this).find("span:first").addClass("hidden");
    $("<textarea class='translated-textarea'></textarea>").html(value).appendTo($(this));
    $(this).find("textarea:first").focus();
    $(this).parents("table:first").find("tr").removeClass("highlighted");
    $(this).parents("tr:first").addClass("highlighted");
  });
  
  $(document.body).delegate('.translated-textarea','keydown',function(event){
    var value = $(this).val();
    var key = $(this).parent().attr('key');
    var self = $(this)
    var word = { 'key' : key , 'value' : value}
    
    if(event.keyCode == 27  ){
      $(this).parent().find("span:first").removeClass("hidden");
      $(this).remove();
      return;
    }//end if
    if(event.keyCode == 13  ){
      $(this).attr("disabled", "disabled");
      $(this).parent().append("<div class='saving'><div class='saving-content'>Saving...</div></div>")
      $.ajax({
        type: 'POST',
        url: '/itranslate/translate',
        data: {
          lang: $(".language-select:checked:first").val(),
          data: word
        },
        success: function(data){        
          self.parent().find("div.saving").remove();
          self.parent().find("span").removeClass("hidden").html(self.val());          
          self.remove();
        }
      });  
      return false;
      
    }
  });
  
})
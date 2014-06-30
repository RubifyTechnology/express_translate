function runJSTranslateLayout() {
  showInfo();

  $(".file").click(function(event) {
    event.preventDefault();
    $("#backup_layer").fadeIn();
    $("body").append($("<div/>").addClass("bg-lock"));
    $("#express_translate_body").addClass("blur");
  })

  $(".close_layer").click(function(event) {
    event.preventDefault();
    $("#backup_layer").fadeOut();
    $(".bg-lock").remove();
    $("#express_translate_body").removeClass("blur");
  })

  $(".import").click(function(event) {
    event.preventDefault();
    $("#upload_file").click();
  });

  $("#upload_file").change(function(event) {
    $(".import").html("Processing...");
    $("#upload_file_form").submit();
  })

  $("#upload_file_iframe").load(function(event) {
    $(".import").html("Import");
    setTimeout(function() {
      // window.location = "/express_translate"
    }, 100);
  })

  var obj = $("#backup_layer");

  obj.on('dragenter', function (e){
    e.stopPropagation();
    e.preventDefault();
    $(this).removeClass("add_files");
  });

  obj.on('dragover', function (e){
     e.stopPropagation();
     e.preventDefault();
     $(this).addClass("add_files");
  });

  obj.on('drop', function (e){
     $(this).removeClass("add_files");
     e.preventDefault();
     var files = e.originalEvent.dataTransfer.files;
     handleFileUpload(files, obj);
  }); 
  
  obj.on('dragleave', function (e) {
    $(this).removeClass("add_files");
  });  
  
  function handleFileUpload(files, obj) {
    for (var i = 0; i < files.length; i++) {
      var fd = new FormData();
      fd.append('file_csv', files[i]);
      sendFileToServer(fd);
    }
  }
  
  function sendFileToServer(formData) {
    var uploadURL ="/express_translate/import";
    var extraData ={};
    var jqXHR = $.ajax({
      xhr: function() {
        var xhrobj = $.ajaxSettings.xhr();
        if (xhrobj.upload) {
          xhrobj.upload.addEventListener('progress', function(event) {
            var percent = 0;
            var position = event.loaded || event.position;
            var total = event.total;
            if (event.lengthComputable) {
              percent = Math.ceil(position / total * 100);
            }
          }, false);
        }
        return xhrobj;
      },
      url: uploadURL,
      type: "POST",
      contentType:false,
      processData: false,
      cache: false,
      data: formData,
      success: function(data){
        $(".import").html("Import");
        setTimeout(function(){
          window.location.reload();
        }, 100);
      }
    });
  }
}
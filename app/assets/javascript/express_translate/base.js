function setRlangCookie(cname, cvalue, days) {
  var d = new Date();
  if (typeof(days) == "undefined") {
    days = 1
  }
  d.setTime(d.getTime() + (days*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires + ";path=/";
}

function getRlangCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) {
    var c = ca[i].trim();
    if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
  }
  return "";
}

window.notification = function (text, success) {
  $("#notification").html(text).addClass(success ? 'success' : 'error');
  setTimeout(function() {
    $("#notification").removeClass(success ? 'success' : 'error');
  }, 5000);
}

function showInfo() {
  $(".username_show").html(getRlangCookie("username"));
  $(".logout").click(function(event) {
    event.preventDefault();
    $(".logout_dialog").dialog({
      resizable: false,
      height:140,
      modal: true,
      buttons: {
        Yes: function() {
          $(this).dialog("close");
          setRlangCookie("token", "", -1);
          setRlangCookie("username", "", -1);
          window.location = "/express_translate";
        },
        No: function() {
          $(this).dialog("close");
        }
      }
    })
  });
}

function openInNewTab(url) {
  var win = window.open(url, '_blank');
  win.focus();
}

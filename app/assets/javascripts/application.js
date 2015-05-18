// = require jquery
// = require jquery_ujs
// = require_tree .

$(function(){

  var dropdownToggle = $(".dropdown-toggle");
  var dropdownMenu = $(".dropdown-menu");


  dropdownToggle.hover(function(){
    $(this).addClass("active");
    $(this).find(dropdownMenu).show();
  }, function(){
    $(this).removeClass("active");
    $(this).find(dropdownMenu).hide();
  });


  var mobileTrigger = $("a.trigger");
  var mobileMenu = $("#mobile-menu");

  var showMobileMenu = function(){
    if(mobileMenu.is(":visible")) {
      mobileMenu.hide();
      mobileTrigger.removeClass("close");
    }
    else {
      mobileMenu.show();
      mobileTrigger.addClass("close");
    }
  };

  mobileTrigger.click(function(){
    showMobileMenu();
  });


});

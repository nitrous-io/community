// = require jquery
// = require jquery_ujs
// = require_tree .

$(function(){

  var dropdownToggle = $(".dropdown-toggle");
  var dropdownMenu = $(".dropdown-menu");

  dropdownToggle.hover(function(){
    $(this).next(dropdownMenu).show();
  }, function(){
    $(this).next(dropdownMenu).hide();
  });


});

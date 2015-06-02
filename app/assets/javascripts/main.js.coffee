$dropdownToggle = $(".dropdown-toggle")

$dropdownToggle.hover ->
  $(this).addClass("active")
, ->
  $(this).removeClass("active")

$header = $("header")
$mobileTrigger = $("a.trigger")
$mobileMenu = $("#mobile-menu")

showMobileMenu = ->
  if $mobileMenu.is(":visible")
    $header.removeClass("fixed")
    $mobileMenu.hide()
    $mobileTrigger.removeClass("close")
  else
    $header.addClass("fixed")
    $mobileMenu.show()
    $mobileTrigger.addClass("close")

$mobileTrigger.click ->
  showMobileMenu()

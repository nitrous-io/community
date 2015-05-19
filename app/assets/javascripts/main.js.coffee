$dropdownToggle = $(".dropdown-toggle")
$dropdownMenu = $(".dropdown-menu")

$dropdownToggle.hover ->
  $(this).addClass("active")
  $(this).find($dropdownMenu).show()
, ->
  $(this).removeClass("active")
  $(this).find($dropdownMenu).hide()

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

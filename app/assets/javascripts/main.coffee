window.Community ||= {}

# User dropdown
$dropdownToggle = $(".dropdown-toggle")

$dropdownToggle.hover ->
  $(this).addClass("active")
, ->
  $(this).removeClass("active")

# Mobile Menu
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

# Share popup
$sharer = $("#share")
$sharerTrigger = $("a.share")

$sharerTrigger.hover ->
  $sharer.addClass("active")

$sharer.mouseleave ->
  $(this).removeClass("active")

# Tags input
$("[data-role='tagsinput']").tagsInput()

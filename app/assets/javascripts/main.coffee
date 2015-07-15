window.Community = {}

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


# Docs Sidebar
if $("html").hasClass("docs show")
  $(".docs-col h3").click ->
    col = $(this).parents(".docs-col")
    if col.hasClass("active")
      col.removeClass("active")
    else
      col.addClass("active")

# Tutorials Index
if $("html").hasClass("tutorials index")
  currentTag = window.location.pathname.split('/')[3]
  if currentTag != undefined
    $("html").addClass("tutorial-"+currentTag)
    heroBarEl = $(".hero-bar li.tutorials-"+currentTag)
    if heroBarEl.length
      heroBarEl.addClass("active")
  
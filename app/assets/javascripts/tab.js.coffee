class window.Community.Tab
  constructor: (@$tabs = null, @onChange = null) ->
    @$tabs ||= $("[data-tabbable=true] li a")
    @$contents = []
    for tab in @$tabs
      target = $(tab).attr('href')
      @$contents.push($(target))

    @$tabs.click (e) =>
      e.preventDefault()
      $tab = $(e.target)
      @activateTab($tab) unless $tab.hasClass("active")

    $(@$tabs[0]).click()

  activateTab: ($tab) ->
    @deactivateAll()

    $target = $($tab.attr('href'))
    $tab.addClass('active')
    $target.show()

    @$currentTab = $tab
    @$currentContent = $target

    @onChange?(this)

  deactivateAll: ->
    @$tabs.removeClass("active")
    $(content).hide() for content in @$contents

if $("[data-tabbable=true]").length > 0
  new Community.Tab()
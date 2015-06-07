window.Community.Tab =
  init: ->
    $tabs = $("[data-tabbable=true] li a")
    $contents = []
    for tab in $tabs
      target = $(tab).attr('href')
      $contents.push($(target))

    $tabs.click (e) ->
      e.preventDefault()
      $this = $(this)
      unless $this.hasClass("active")
        # Deactive all tabs and hide all tab contents
        $tabs.removeClass("active")
        for content in $contents
          $(content).hide()

        # Activate the tab and show corresponding content
        $target = $($this.attr('href'))
        $this.addClass('active')
        $target.show()

    $($tabs[0]).click()

window.Community.Tab.init()
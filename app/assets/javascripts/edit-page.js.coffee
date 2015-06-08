Community.EditPage =
  init: ->
    $markdownTextarea = $('.markdown-textarea')
    $tabs = $(".tabs a")
    $tabsContent = $(".tabs-content > div")

    $tabs.click (e) ->
      e.preventDefault()
      if $(this).hasClass("active")
        return false
      else
        target = $(this).attr("href")
        markdownVal = $markdownTextarea.val()

        $tabs.removeClass("active")
        $tabsContent.hide()
        $(this).addClass("active")
        $.post("/preview", { markdown_text: markdownVal }, ->
          ).done((data) ->
            $(".preview-content-js").empty().append(data.html_content)
            window.Community.Highlight.init()
          ).fail ->
            alert("Unable to preview, please try again.")
        $(target).show()

    if $markdownTextarea.length > 0
      CodeMirror.fromTextArea $markdownTextarea[0],
        mode: 'markdown'
        lineWrapping: true
        viewportMargin: Infinity
        
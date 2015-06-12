Community.EditPage =
  init: ->
    $markdownTextarea = $('.markdown-text-js')
    $previewTabLink = $('a.preview-js')
    codemirror = CodeMirror.fromTextArea $markdownTextarea[0],
      mode: 'markdown'
      lineWrapping: true
      viewportMargin: Infinity
      placeholder: 'Content text'

    $previewTabLink.click (e) ->
      e.preventDefault()
      $.post("/preview", { markdown_text: codemirror.getValue() }, ->
        ).done((data) ->
          $(".preview-content-js").empty().html(data.html_content)
          window.Community.Highlight.init()
        ).fail ->
          alert("Unable to preview, please try again.")

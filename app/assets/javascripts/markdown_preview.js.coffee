$(".tab-wrapper").tabs()
$('a[data-preview-tab=true]').click (e) ->
  e.preventDefault()

  markdown_val = $(".markdown-text-js").val()
  $.post("/preview", { markdown_text: markdown_val }, ->
  ).done((data) ->
    $(".preview-content-js").empty().append(data.html_content)
    window.Community.Highlight.init()
  ).fail( ->
    alert("Unable to preview, please try again.")
  )

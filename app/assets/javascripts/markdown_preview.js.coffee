$(document).ready ->
  $('ul[data-preview-tab=true] a').click (e) ->
    console.log($(@))
    e.preventDefault()
    $(@).tab('show')

  $(".preview-btn-js").click  ->
    markdown_val = $(".markdown-text-js").val()
    $.post("/preview", { markdown_text: markdown_val }, ->
    ).done((data) ->
      $(".preview-content-js").empty().append(data.html_content)
    ).fail( ->
      alert("Unable to preview, please try again.")
    )

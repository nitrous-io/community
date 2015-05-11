$(document).ready(function() {
  $(".preview-btn-js").click(function() {
    markdown_val = $(".markdown-text-js").val();
    $.post("/preview", { markdown_text: markdown_val }, function() {
    }).done(function(data) {
      $(".preview-content-js").empty().append(data.html_content);
    }).fail(function() {
      alert("Unable to preview, please try again.");
    });
  });
});

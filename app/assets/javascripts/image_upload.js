$(document).ready(function() {
  $(function() {
    $('textarea').inlineattachment({
      uploadUrl: '/image_contents',
      urlText: "![image]({filename})"
    });
  });
});

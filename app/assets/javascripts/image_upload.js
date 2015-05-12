$(document).ready(function() {
  $(function() {
    $('textarea').inlineattachment({
      uploadUrl: '/image_contents',
      // FIXME: urlText not working. http://git.razko.nl/InlineAttachment/
      urlText: "![file]({filename})"
    });
  });
});

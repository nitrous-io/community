$remote = $("[data-remote=true]")
$remote.on "ajax:success", (e, data, status, xhr) =>
  $remote.html(xhr.responseText)
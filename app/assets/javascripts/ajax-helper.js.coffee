$remote = $("[data-remote=true]")
$remote.on "ajax:success", (e, data, status, xhr) =>
  $remote.html(xhr.responseText)

$('[data-form-id]').on 'click', (e) ->
  e.preventDefault()

  formId = $(this).data('form-id')
  $form = $(formId)

  if $form.length > 0
    formValues = $(this).data('form-values')
    if formValues
      for key, value of formValues
        $form.append($("<input>").attr("type", "hidden").attr("name", key).val(value))

    $form.submit()
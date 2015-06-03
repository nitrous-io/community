$('[data-form-id]').on 'click', (e) ->
  e.preventDefault()

  formId = $(this).data('form-id')
  $form = $(formId)

  if $form.length > 0
    $form.submit()
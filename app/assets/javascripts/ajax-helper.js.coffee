$('[data-form-id]').on 'click', ->
  formId = $(this).data('form-id')
  $form = $(formId)
  if $form.length > 0
    $form.submit()

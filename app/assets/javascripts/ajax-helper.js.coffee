$('[data-form-id]').on('click', ->
  $form = $($(@).data('form-id'))
  console.log($form)
  if $form.length > 0
    $form.submit()
)
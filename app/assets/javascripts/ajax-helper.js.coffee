onAjaxSuccess = (e, data, status, xhr) ->
  $this = $(this)

  if $this.data('replace-form')
    $parent = $this.parent()
    $parent.append(xhr.responseText)
    $parent.find("[data-remote=true]").on "ajax:success", onAjaxSuccess
    $this.remove()
  else
    $this.html(xhr.responseText)

$("[data-remote=true]").on "ajax:success", onAjaxSuccess

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

$('[data-infinite-scroll=true]').infinitescroll
  animate: true
  navSelector: 'a[data-next-link]'
  nextSelector: 'a[data-next-link]'
  contentSelector: '[data-infinite-scroll=true]'
  itemSelector: 'section'
  dataType: 'html'
  debug: true
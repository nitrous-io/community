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

$scrollViews = $('[data-infinite-scroll=true]')

for scrollView in $scrollViews
  $scrollView = $(scrollView)
  $containerSelector = $scrollView.data('infinite-scroll-container')
  $scrollView.infinitescroll
    animate: true
    navSelector: "#{$containerSelector} a[data-next-link]"
    nextSelector: "#{$containerSelector} a[data-next-link]"
    contentSelector: $containerSelector
    itemSelector: 'section'
    dataType: 'html'
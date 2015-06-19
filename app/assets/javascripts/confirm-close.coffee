confirmClose = true

noConfirmClose = ->
  confirmClose = false
  window.setTimeout(->
    confirmClose = true
  , 50)

$.attachConfirmClose = (msg) ->
  $(window).on 'beforeunload', (evt) ->
    return unless confirmClose
    confirmationMessage = msg
    (evt || window.event).returnValue = confirmationMessage # Gecko and Trident
    confirmationMessage # Gecko and WebKit

$('[data-no-confirm-close]').on 'click submit', (e) ->
  noConfirmClose()
  true

if $.rails.handleMethod
  _handleMethod = $.rails.handleMethod
  $.rails.handleMethod = (link) ->
    if link.data('no-confirm-close')
      noConfirmClose()
    _handleMethod.apply(this, arguments)

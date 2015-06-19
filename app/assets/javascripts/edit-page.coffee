Community.EditPage =
  init: ->
    confirmClose = true

    $(window).on 'beforeunload', (evt) ->
      return unless confirmClose
      confirmationMessage = "You will lose unsaved work if you close the page."
      (evt || window.event).returnValue = confirmationMessage # Gecko and Trident
      confirmationMessage # Gecko and WebKit

    noConfirmClose = ->
      confirmClose = false
      window.setTimeout(->
        confirmClose = true
      , 50)

    codemirror = CodeMirror.fromTextArea $('.markdown-text-js')[0],
      mode: 'markdown'
      lineWrapping: true
      viewportMargin: Infinity
      placeholder: 'Content text'

    $markdownPreview = $('#markdown-preview')

    $markdownPreview.find('li a').click (e) ->
      e.preventDefault()
      $this = $(this)
      $markdownPreview.find('.tabs li').removeClass('active')
      $this.closest('li').addClass('active')
      $tabsContent = $markdownPreview.find('.tabs-content')
      $tabsContent.find('> div').removeClass('active')
      $tabsContent.find($this.data('tab')).addClass('active')

    $markdownPreview.find('.preview a').click (e) ->
      e.preventDefault()
      $.post("/preview", { markdown_text: codemirror.getValue() }, ->
        ).done((data) ->
          $(".preview-content-js").empty().html(data.html_content)
          window.Community.Highlight.init()
        ).fail ->
          alert("Unable to preview, please try again.")

    $('[data-no-confirm-close]').on 'click', (e) ->
      noConfirmClose()
      true

Community.EditPage =
  init: ->
    $.attachConfirmClose("You will lose unsaved work if you close the page.")

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

    $('.published_at_picker').datetimepicker(format:'Y-m-d H:i:s')
    $('.published_at_picker').change ->
      $this = $(this)
      isoDate = (new Date(Date.parse($this.val()))).toISOString()
      $('.published_at').val(isoDate)

    if publishedAt = $('.published_at').val()
      d = new Date(Date.parse(publishedAt))
      z = (n) ->
        if n < 10 && n >= 0 then "0#{n}" else "#{n}"

      df = "#{d.getFullYear()}-#{z(d.getMonth()+1)}-#{z(d.getDate())} #{z(d.getHours())}:#{z(d.getMinutes())}:#{z(d.getSeconds())}"
      $('.published_at_picker').val(df).change()

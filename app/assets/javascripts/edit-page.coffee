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

    dateFormatPattern = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/i
    $('.published_at_picker').datetimepicker(format: 'Y-m-d H:i:s')
    $('.published_at_picker').change ->
      $this = $(this)
      matches = $this.val().match(dateFormatPattern)
      if matches && matches.length >= 7 # YYYY-MM-DD HH:MM:DD
        isoDate = new Date(matches[1], parseInt(matches[2], 10) - 1, matches[3], matches[4], matches[5], 0)
        $('.published_at').val(isoDate.toISOString())

    if publishedAt = $('.published_at').val()
      d = new Date(Date.parse(publishedAt))
      z = (n) ->
        if n < 10 && n >= 0 then "0#{n}" else "#{n}"

      df = "#{d.getFullYear()}-#{z(d.getMonth()+1)}-#{z(d.getDate())} #{z(d.getHours())}:#{z(d.getMinutes())}:#{z(d.getSeconds())}"
      $('.published_at_picker').val(df).change()

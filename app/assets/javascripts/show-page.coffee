Community.ShowPage =
  init: ->
    $('a.heart').click (e) ->
      e.preventDefault()
      $this = $(this)
      active = $this.hasClass('active')

      url = if active
        $this.data('unlike-path')
      else
        $this.data('like-path')

      $.post(url).done((data) ->
        if active
          $this.removeClass('active')
        else
          $this.addClass('active')

        score = data.score
        $this.find('> span').text("#{score} heart#{if score != 1 then 's' else ''}")
      ).fail (evt) ->
        if evt.status == 403
          location.href = '/login?redirect_to=' + window.encodeURIComponent(location.pathname)

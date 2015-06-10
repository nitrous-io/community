class window.Community.Search
  constructor: (@$form, $tabs) ->
    @$searchInput = @$form.find('input[type=text][name=q]')
    @tab = new Community.Tab($tabs, $.proxy(@onTabChange, @))
    @url = @$form.attr('action')
    @$form.submit($.proxy(@onSubmit, @))
    @currentQueries = {}
    @scrolls = {}

  onSubmit: (e) ->
    query = @$searchInput.val().trim()
    return if query.length < 1
    type = @tab.$currentContent.attr('id')

    if type == 'all'
      @$searchInput.val(query)
    else
      e.preventDefault()
      @fetchPartial({q: query, type: type}, @tab.$currentContent)

  onTabChange: ($tab, $content) ->
    query = @$searchInput.val().trim()
    return if query.length < 1
    type = $content.attr('id')
    for t, scroll of @scrolls
      console.log('pause', t)
      scroll.infinitescroll('pause')

    return if type == 'all'

    console.log(@currentQueries)
    if @currentQueries[type] == query
      console.log('resume', type, @scrolls[type])
      @scrolls[type]?.infinitescroll('resume')
    else
      console.log('destroy', type)
      @scrolls[type]?.infinitescroll('destroy')
      @fetchPartial({q: query, type: type}, $content)

  fetchPartial: (data, $content) ->
    @currentQueries[data.type] = data.q
    $.ajax(
      url: @url, type: 'GET', data: data
    ).done((content) =>
      $content.html(content)
      @initScroll(data, $content)
    )

  initScroll: (data, $content) ->
    containerId = $content.attr('id')
    console.log('data.type', data.type)
    @scrolls[data.type] = $content.infinitescroll
      animate: true
      navSelector: "##{containerId} a[data-next-link]"
      nextSelector: "##{containerId} a[data-next-link]"
      contentSelector: "##{containerId}"
      itemSelector: 'section'
      dataType: 'html'
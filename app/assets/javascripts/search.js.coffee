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
      @scrolls[type]?.infinitescroll('destroy')
      @fetchPartial({q: query, type: type}, @tab.$currentContent)

  onTabChange: (tab) ->
    $tab = tab.$currentTab
    $content = tab.$currentContent
    query = @$searchInput.val().trim()
    return if query.length < 1
    type = $content.attr('id')
    for _, scroll of @scrolls
      scroll.infinitescroll('pause')

    return if type == 'all'

    if @currentQueries[type] == query
      @scrolls[type]?.infinitescroll('resume')
    else
      @scrolls[type]?.infinitescroll('destroy')
      @fetchPartial({q: query, type: type}, tab.$currentContent)

  fetchPartial: (data, $content) ->
    @currentQueries[data.type] = data.q
    $.ajax(
      url: @url, type: 'GET', data: data
    ).done((content) =>
      # This is to make re-initialize infinite scroll
      # If you initialze and destroy to same element
      # It does not re-initalize
      $content.html('<div>' + content + '</div>')
      @initScroll(data, $content)
    )

  initScroll: (data, $content) ->
    containerId = $content.attr('id')
    @scrolls[data.type] = $content.find('>').infinitescroll
      animate: true
      navSelector: "##{containerId} a[data-next-link]"
      nextSelector: "##{containerId} a[data-next-link]"
      contentSelector: "##{containerId} >"
      itemSelector: 'section'
      dataType: 'html'
      debug: true
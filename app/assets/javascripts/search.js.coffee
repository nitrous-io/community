class window.Community.Search
  constructor: (@$form, $tabs) ->
    @$searchInput = @$form.find('input[type=text][name=q]')
    @tab = new Community.Tab($tabs, $.proxy(@onTabChange, @))
    @url = @$form.attr('action')
    @$form.submit($.proxy(@onSubmit, @))
    @currentQueries = {}

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
    return if type == 'all'
    return if @currentQueries[type] == query

    @fetchPartial({q: query, type: type}, $content)

  fetchPartial: (data, $content) ->
    @currentQueries[data.type] = data.query
    $.ajax(
      url: @url, type: 'GET', data: data
    ).done((data) ->
      $content.html(data)
    )

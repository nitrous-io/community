#= require spec_helper
#= require application
#= require templates/search

describe "EditPage", ->
  server = $searchInput = $postTab = $tutorialTab = $postContent = $tutorialContent = null

  beforeEach ->
    server = sinon.fakeServer.create();
    $('body').html(JST['templates/search']())
    new Community.Search($('#search_form'), $('.tabs li a'))
    $tutorialTab = $('.tabs li:nth(1) a')
    $postTab = $('.tabs li:nth(2) a')
    $tutorialContent = $('#tutorials')
    $postContent = $('#posts')
    $searchInput = $('#search_form input[type=text]')

  afterEach: ->
    server.restore()

  it "fetches tab content from server when switch tab", ->
    $searchInput.val('rails')
    server.respondWith("GET", "/search?q=rails&type=tutorials", [200, { "Content-Type": "text/html" }, '<p>tab content</p>'])
    $tutorialTab.click()
    server.respond()

    expect($tutorialContent.html()).to.eq('<div><p>tab content</p></div>')

  it "does not fetches when query is empty", ->
    $searchInput.val('')
    server.respondWith("GET", "/search?q=rails&type=tutorials", [200, { "Content-Type": "text/html" }, '<p>tab content</p>'])
    $tutorialTab.click()
    server.respond()
    expect($tutorialContent.html()).to.eq('')

  it "does not fetches when it has searched for same query", ->
    $searchInput.val('rails')
    server.respondWith("GET", "/search?q=rails&type=tutorials", [200, { "Content-Type": "text/html" }, '<p>tutorial tab content</p>'])
    server.respondWith("GET", "/search?q=rails&type=posts", [200, { "Content-Type": "text/html" }, '<p>post tab content</p>'])
    $tutorialTab.click()
    $postTab.click()
    server.respond()

    server.respondWith("GET", "/search?q=rails&type=tutorials", [200, { "Content-Type": "text/html" }, '<p>new tutorial tab content</p>'])
    $tutorialTab.click()
    server.respond()
    expect($tutorialContent.html()).to.eq('<div><p>tutorial tab content</p></div>')
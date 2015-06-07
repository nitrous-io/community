#= require spec_helper
#= require application
#= require code-mirror
#= require templates/edit_page

describe "EditPage", ->
  server = $previewTab = null

  beforeEach ->
    server = sinon.fakeServer.create();
    $('body').html(JST['templates/edit_page']())
    window.Community.EditPage.init()
    $previewTab = $('a.preview-js')

  afterEach: ->
    server.restore()

  it "when click preview tab, it send a request to convert html content from current markdown", ->
    server.respondWith("POST", "/preview", [200, { "Content-Type": "application/json" }, '{ "html_content": "<p>html content</p>" }']);
    $previewTab.click()
    server.respond()
    expect($(".preview-content-js").html()).to.eq('<p>html content</p>')
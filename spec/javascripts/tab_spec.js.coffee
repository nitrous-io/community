#= require spec_helper.js.coffee
#= require application
#= require templates/tab

describe "Tab", ->
  $firstTab = $secondTab = $secondTabContent = $firstTabContent = null

  beforeEach ->
    $('body').html(JST['templates/tab']())
    window.Community.Tab.init()
    $firstTab = $('.tabs li:first a')
    $secondTab = $('.tabs li:nth(1) a')
    $firstTabContent = $($firstTab.attr('href'))
    $secondTabContent = $($secondTab.attr('href'))

  it "selects first tab", ->
    expect($firstTab.hasClass('active')).to.be.true
    expect($secondTab.hasClass('active')).to.be.false
    expect($firstTabContent.is(':visible')).to.be.true
    expect($secondTabContent.is(':visible')).to.be.false

  it "shows corresponding content when click a tab", ->
    $secondTab.click()
    expect($firstTab.hasClass('active')).to.be.false
    expect($secondTab.hasClass('active')).to.be.true
    expect($firstTabContent.is(':visible')).to.be.false
    expect($secondTabContent.is(':visible')).to.be.true

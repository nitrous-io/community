#= require spec_helper.js.coffee
#= require application
#= require templates/tab

describe "Tab", ->
  tab = $firstTab = $secondTab = $secondTabContent = $firstTabContent = null

  beforeEach ->
    $('body').html(JST['templates/tab']())
    tab = new window.Community.Tab()
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

  it "sets $currentTab and $currentContent", ->
    $secondTab.click()
    expect(tab.$currentTab[0]).to.equal($secondTab[0])
    expect(tab.$currentContent[0]).to.equal($secondTabContent[0])
    $firstTab.click()
    expect(tab.$currentTab[0]).to.equal($firstTab[0])
    expect(tab.$currentContent[0]).to.equal($firstTabContent[0])
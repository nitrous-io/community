window.Community.Highlight =
  init: ->
    $('pre code').each ->
      $this = $(this)
      code = ($this.text() ? "").replace(/[\s\n]+$/g, '')
      language = $this.attr('class').split(/\s+/)[1]

      $this.empty()

      CodeMirror this,
        value: code
        mode: language
        lineWrapping: true
        lineNumbers: true
        readOnly: true
        cursorBlinkRate: -1
        viewportMargin: Infinity
        theme: 'github'
        
$(document).ready ->
  window.Community.Highlight.init()
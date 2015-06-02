window.Community.Highlight =
  init: ->
    $('pre code').each ->
      $this = $(@)
      $code = $this.html()
      language = $this.attr('class').split(/\s+/)[1]

      $this.empty()

      CodeMirror @,
        value: $code
        mode: language
        lineNumbers: false
        readOnly: true

window.Community.Highlight.init()
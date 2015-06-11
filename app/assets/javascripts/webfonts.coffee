window.WebFontConfig =
  google: { families: [ 'Fira+Mono:400,700:latin' ] }

wf = document.createElement('script')
wf.src = location.protocol + '//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'
wf.type = 'text/javascript'
wf.async = 'true'
s = document.getElementsByTagName('script')[0]
s.parentNode.insertBefore(wf, s)
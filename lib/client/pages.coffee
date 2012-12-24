module.exports = ->
  for textarea in $ '.codemirror'
    editor = CodeMirror.fromTextArea textarea,
      lineNumbers: on
      theme: 'monokai'
      mode: 'markdown'
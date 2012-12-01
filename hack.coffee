# repl = require 'repl'

optimist = require 'optimist'

module.exports = (app) ->
  app.argv = optimist
    .alias('verbose', 'v')
    .alias('fake', 'f')
    .argv
  
  if app.argv.verbose
    app._all = app.all
    app.all = (path, middleware...) ->
      console.log "[route] [all] #{path}"
      app._all arguments...
    
    app._get = app.get
    app.get = (path, middleware...) ->
      console.log "[route] [get] #{path}"
      app._get arguments...
    
    app._put = app.put
    app.put = (path, middleware...) ->
      console.log "[route] [put] #{path}"
      app._put arguments...
    
    app._post = app.post
    app.post = (path, middleware...) ->
      console.log "[route] [post] #{path}"
      app._post arguments...
    
    app._delete = app.delete
    app.delete = (path, middleware...) ->
      console.log "[route] [delete] #{path}"
      app._delete arguments...
  
  # repl.start
  #   prompt: '> '
  #   input: process.stdin
  #   output: process.stdout
  #   global: on
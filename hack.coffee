_ = require 'underscore'
optimist = require 'optimist'

module.exports = (app, system) ->
  module.exports.augmentApp app
  module.exports.augmentConsole()
  # module.exports.augmentDB app, system

module.exports.augmentDB = (app, db) ->
  if app.argv.verbose
    db._query = db.query
    db.query = (query, args...) ->
      unless query.match /po_advertisements/g or query.match /account_type/g
        console.log (_.filter arguments, (argument) -> typeof argument isnt 'function')...
      db._query arguments...

module.exports.augmentApp = (app) ->
  global.app = app
  
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

ticks = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

spark = (values, seperator = '') ->
  max = Math.max values...
  min = Math.min values...
  
  steps = values.map (tick) ->
    index = Math.round (tick - min) / max * (ticks.length - 1)
    ticks[index]
  
  steps.join seperator

module.exports.augmentConsole = ->
  console.times = {}
  
  console.durations = {}
  
  console.start = (name) ->
    @times[name] = Date.now()
  
  console.stop = (name) ->
    diff = Date.now() - @times[name]
    @durations[name] ?= []
    @durations[name].push diff
    # @log diff + 'ms ' + name
    diff
  
  console.report = ->
    console.log ''
    
    taskCount = (Object.keys console.durations).length
    
    do ->
      times = []
      
      for task, time of console.durations
        times.push time
      
      console.log spark times, ' '
    
    do ->
      legend = []
      
      for j in [0...taskCount]
        legend.push j
      
      console.log legend.join ' '
    
    console.log ''
    
    do ->
      i = 0
      
      for task, time of console.durations
        console.log "[#{i}] #{task} #{time}"
        i++
    
    console.log ''
  
  # repl.start
  #   prompt: '> '
  #   input: process.stdin
  #   output: process.stdout
  #   global: on
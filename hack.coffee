_ = require 'underscore'
_s = require 'underscore.string'

module.exports = (app) ->
  module.exports.augmentApp app
  module.exports.augmentConsole()

module.exports.augmentDB = (app, db) ->
  if app.argv.verbose
    db._query = db.query
    db.query = (query, args..., callback) ->
      # unless (query.match /advertisements/g) or (query.match /account_type/g) or (query.match /SHOW\sCOLUMNS/g) or (query.match /pages/g) or (query.match /adspaces/g)
      q = _s.clean (_s.lines query).join(' ')
      console.log q, (args[0] unless typeof args[0] is 'function')
      db._query query, args..., (error, args...) ->
        console.log 'ERROR', error.toString().red if error?
        callback error, args...

module.exports.augmentApp = (app) ->
  
  global.app = app
  
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
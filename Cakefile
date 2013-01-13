{exec, spawn} = require 'child_process'

task 'config', 'Build a default config file', ->
  exec 'cp example.config.coffee config.coffee', -> console.log arguments...

task 'server', 'run the server', ->
  sudo = require 'sudo'
  
  options =
    cachePassword: on
    prompt: "Password? "
    # spawnOptions: {} # other options for spawn
  
  child = sudo ['supervisor', 'server.coffee'], options
  
  child.stdout.on "data", (data) ->
    
    console.log data.toString()
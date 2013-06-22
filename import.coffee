fs = require 'fs'
path = require 'path'

_s = require 'underscore.string'

module.exports = (argv) ->
  
  models = {}
  controllers = admin: {}
  
  console.start 'import'
  
  files = fs.readdirSync './models'
  files.sort() # [TODO] [@pyro, @tehlulz]
  
  for file in files
    return if file[0] is '.'
    key = path.basename file, (path.extname file)
    console.log "✓ [model] #{key}" if argv.verbose
    model = models[key] = require "./models/#{key}"
    do (file, key, model) ->
      Object.defineProperty global, model.name,
        get: -> model
  
  fs.readdirSync('./controllers').forEach (module) ->
    return if module[0] is '.'
    return if (fs.statSync "./controllers/#{module}").isDirectory()
    console.log "✓ [controller] #{module}" if argv.verbose
    controllers[module.split('.')[0]] = require "./controllers/#{module}"
  
  console.stop 'import'
  
  return {models, controllers}
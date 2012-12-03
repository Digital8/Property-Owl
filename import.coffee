fs = require 'fs'

module.exports = (app, {models, controllers, helpers}) ->
  console.start 'import'
  
  files = fs.readdirSync('./models')
  files.sort

  for file in files
    return if file is '.'
    console.log "✓ [model] #{module}" if app.argv.verbose
    models[file.split('.')[0]] = require "./models/#{file}"

  fs.readdirSync('./controllers').forEach (module) ->
    return if module[0] is '.'
    return if (fs.statSync "./controllers/#{module}").isDirectory()
    console.log "✓ [controller] #{module}" if app.argv.verbose
    controllers[module.split('.')[0]] = require "./controllers/#{module}"

  fs.readdirSync('./controllers/admin').forEach (module) ->
    return if module[0] is '.'
    console.log "✓ [controller/admin] #{module}" if app.argv.verbose
    controllers.admin[module.split('.')[0]] = require "./controllers/admin/#{module}"

  fs.readdirSync('./controllers/dev').forEach (module) ->
    return if module[0] is '.'
    console.log "✓ [controller/dev] #{module}" if app.argv.verbose
    controllers.dev[module.split('.')[0]] = require "./controllers/dev/#{module}"

  fs.readdirSync('./lib/helpers').forEach (module) ->
    return if module[0] is '.'
    console.log "✓ [helpers] #{module}" if app.argv.verbose
    helpers[module.split('.')[0]] = require "./lib/helpers/#{module}"
  
  console.stop 'import'
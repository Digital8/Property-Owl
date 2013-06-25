_ = require 'underscore'
async = require 'async'

exports.index = (req, res) ->
  
  Media.type 'file', (error, files) ->
    
    res.render 'admin/files', files: files

exports.create = (req, res) ->
  
  files = req.files.file
  
  callback = (error) ->
    if error?
      # console.log 'error', error
      req.flash 'error', error
      res.redirect 'back'
      return
    
    res.redirect 'back'
  
  return callback null unless files?
  
  files = _.compact (_.array files)
  
  return callback null unless files.length
  
  async.forEach files, (file, callback) =>
    
    Media.upload {file, req}, callback
  
  , callback

exports.destroy = (req, res) ->
  
  Media.delete req.params.id, (error, result) ->
    
    return res.send 400 if error?
    
    return res.send 404 unless result.affectedRows
    
    res.send 200
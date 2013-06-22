_ = require 'underscore'
async = require 'async'

exports.index = (req, res) ->
  
  Media.type 'file', (error, files) ->
    
    res.render 'admin/files', files: files

exports.create = (req, res) ->
  
  async.series
    
    upload: (callback) ->
      
      return callback null unless req.files?
      return callback null unless (Object.keys req.files).length
      
      async.forEach (_.values req.files), (file, callback) =>
        
        console.log 'uploading file...', file
        
        return callback null unless file.size
        
        Media.upload
          entity_id: null
          owner_id: req.session.user_id
          file: file
          type: 'file'
        , callback
      
      , callback
  
  , (error) ->
    
    if error?
      # console.log 'error', error
      req.flash 'error', error
      res.redirect 'back'
      return
    
    res.redirect 'back'

exports.destroy = (req, res) ->
  
  Media.delete req.params.id, (error, result) ->
    
    return res.send 400 if error?
    
    return res.send 404 unless result.affectedRows
    
    res.send 200
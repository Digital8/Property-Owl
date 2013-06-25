_ = require 'underscore'

module.exports = ->
  
  (req, res, next) ->
    
    return next null unless req.method in ['post', 'put', 'patch']
    
    return next null unless req.files?
    
    for key, files of req.files
      
      if _.isArray files
        for file, index in files
          delete files[index] unless file.size
        req.files[key] = _.compact files
      
      unless _.isArray files
        
        delete req.files[key] unless files.size
    
    next null
module.exports = ->
  
  (req, res, next) ->
    
    return next null unless req.files?
    
    for key, file of req.files
      
      delete req.files[key] unless file.size
    
    next null
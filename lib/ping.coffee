module.exports = ->
  
  (req, res, next) ->
    
    return next null unless req.url is '/ping'
    
    res.send 200
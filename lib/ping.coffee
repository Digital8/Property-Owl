module.exports = ->
  
  (req, res, next) ->
    
    res.send 200 if req.url is '/ping'
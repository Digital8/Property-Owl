exports.create = (req, res, next) ->
  
  map = req.body
  map.entity_id = req.entity.id
  map.entity_type = req.entity.constructor.name.toLowerCase()
  map.user_id = req.user.id
  
  Deal.create map, (error, deal) ->
    
    return next error if error?
    
    res.send deal

exports.destroy = (req, res, next) ->
  
  Deal.delete req.params.deal_id, (error) ->
    
    return next error if error?
    
    res.send 200

exports.update = (req, res, next) ->
  
  Deal.patch req.params.deal_id, req.body, (error) ->
    
    return next error if error?
    
    res.send 200
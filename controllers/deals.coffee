exports.create = (req, res) ->
  
  map = req.body
  map.entity_id = req.params.id
  map.type = 'owl'
  map.user_id = req.user.id
  
  Deal.create req.body, (error, deal) ->
    
    res.send deal

exports.destroy = (req, res) ->
  
  Deal.delete req.params.deal_id, ->
    
    res.send 'OK'

exports.update = (req, res) ->
  
  owlId = req.params.owl_id
  dealId = req.params.deal_id
  
  Deal.patch dealId, req.body, (error, model) ->
    
    res.send status: 200
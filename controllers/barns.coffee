_ = require 'underscore'
async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  Barn.all (error, barns) ->
    
    barns = _.sortBy barns, 'created_at'
    
    Page.findByUrl '/barn', (error, page) ->
      
      try
        res.render 'barns/index',
          barns: barns
          cms: do jade.compile page.content
      
      catch {message}
        res.render 'errors/500', {message}

exports.show = (req, res) ->
  
  Barn.get req.params.id, (error, barn) ->
    
    return res.send 500, error if error?
    return res.render 'errors/404' unless barn?
    
    res.render 'barns/show', barn: barn, enquire: on

exports.owls = (req,res) ->
  Barn.get req.params.id, (error, barn) ->
    return res.send 500, error if error?
    return res.render 'errors/404' unless barn?
    res.send barn.owls

exports.nest = (req, res) ->
  exports.db.query "UPDATE owls SET barn_id = ? WHERE owl_id = ?", [req.params.id, req.body.id], (error, results) ->
    res.send [error, results]

exports.unnest = (req, res) ->
  {barn_id, owl_id} = req.params
  
  exports.db.query "UPDATE owls SET barn_id = NULL WHERE owl_id = ?", [owl_id], (error, results) ->
    res.send [error, results]

exports.addDeal = (req, res) ->
  map = req.body
  map.entity_id = req.params.id
  map.type = 'barn'
  map.user_id = req.user.id
  
  Deal.create req.body, (error, deal) ->
    res.send deal

exports.removeDeal = (req, res) ->
  Deal.delete req.params.deal_id, ->
    res.send 'OK'

exports.patchDeal = (req, res) ->
  owlId = req.params.owl_id
  dealId = req.params.deal_id
  
  Deal.patch dealId, req.body, (error, model) ->
    
    res.send status: 200

exports.print = (req, res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    res.render 'barns/print', barn: barn, enquire: on
_ = require 'underscore'
jade = require 'jade'
system = require '../system'
async = require 'async'
Barn = system.models.barn
Deal = system.models.deal

exports.index = (req, res) ->
  Page = system.models.page
  Barn.all (error, barns) ->
    barns = _.sortBy barns, 'created_at'
    async.parallel
      page: (callback) -> Page.findByUrl '/barn', callback
    , (error, {page}) ->
      try
        page = page.shift().shift()
        fn = jade.compile page.content
        cms = do fn
        res.render 'barns/index', barns: barns, cms: cms
      catch e
        res.render 'errors/404'

exports.show = (req, res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    if typeof(barn.id) is 'undefined'
      res.render 'errors/404'
    else
      res.render 'barns/show', barn: barn, enquire: on

exports.owls = (req,res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    res.send barn.owls

exports.nest = (req, res) ->
  barnId = req.params.id
  owlId = req.body.id
  
  system.db.query "UPDATE owls SET barn_id = ? WHERE owl_id = ?", [barnId, owlId], (error, results) ->
    res.send [error, results]

exports.unnest = (req, res) ->
  {barn_id, owl_id} = req.params
  
  system.db.query "UPDATE owls SET barn_id = NULL WHERE owl_id = ?", [owl_id], (error, results) ->
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
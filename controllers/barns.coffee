_ = require 'underscore'

system = require '../system'

Barn = system.models.barn

exports.index = (req, res) ->
  Barn.all (error, barns) ->
    barns = _.sortBy barns, 'created_at'
    res.render 'barns/index', barns: barns

exports.show = (req, res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    res.render 'barns/show', barn: barn, enquire: on

exports.owls = (req,res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    res.send barn.owls
# exports.owls = {}

exports.nest = (req, res) ->
  barnId = req.params.id
  owlId = req.body.id
  
  system.db.query "UPDATE owls SET barn_id = ? WHERE owl_id = ?", [barnId, owlId], (error, results) ->
    res.send [error, results]

exports.unnest = (req, res) ->
  {barn_id, owl_id} = req.params
  
  system.db.query "UPDATE owls SET barn_id = NULL WHERE owl_id = ?", [owl_id], (error, results) ->
    res.send [error, results]
  
  # res.send null
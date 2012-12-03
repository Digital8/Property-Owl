system = require '../system'

Owl = system.models.owl
console.log Owl

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'owls/index', owls: owls

exports.locate = (req, res) ->
  res.render 'owls/locate'

exports.top = (req, res) ->
  Owl.top (error, owl) ->
    res.render 'owls/show', owl: owl, bestdeal: true

exports.hot = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'owls/list', owls: owls

exports.byState = (req, res) ->
  {state} = req.params
  
  Owl.state state, (error, owls) ->
    console.log owls
    res.render 'owls/state', owls: owls, state: state

exports.show = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    res.render 'owls/show', owl: owl
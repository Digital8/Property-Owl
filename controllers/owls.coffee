_ = require 'underscore'

system = require '../system'
async = require 'async'
Owl = system.models.owl
Deal = system.models.deal

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'owls/index', owls: owls

exports.locate = (req, res) ->
  res.render 'owls/locate'

exports.top = (req, res) ->
  Owl.top (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      res.render 'owls/show', owl: owl, bestdeal: true, enquire: on, share: on

exports.hot = (req, res) ->
  async.map ['act', 'nsw', 'nt', 'qld', 'sa', 'tas', 'vic', 'wa'], (state, callback) ->
    Owl.topstate state, callback
  , (error, owls) ->
    
    owls = _.sortBy owls, 'state'
    
    async.map owls, (owl, callback) ->
      owl.hydrateForUser req.user, callback
    , (error) ->
      res.render 'owls/list', owls: owls, maxPages: 1, currentPage: 1

exports.byState = (req, res) ->
  {state} = req.params
  
  Owl.state state, (error, owls) ->
    
    if req.query.sort?
      switch req.query.sort
        when 'deal'
          owls = _.sortBy owls, 'value'
          owls.reverse()
        when 'time'
          owls = _.sortBy owls, 'created_at'
    
    async.map owls, (owl, callback) ->
      owl.hydrateForUser req.user, callback
    , (error) ->
      res.render 'owls/state', owls: owls, state: state

exports.show = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      res.render 'owls/show', owl: owl, enquire: on

exports.addDeal = (req, res) ->
  map = req.body
  map.entity_id = req.params.id
  map.type = 'owl'
  map.user_id = req.user.id
  
  console.log map
  
  Deal.create req.body, (error, deal) ->
    res.send 'OK'

exports.removeDeal = (req, res) ->
  Deal.delete req.params.deal_id, ->
    res.send 'OK'
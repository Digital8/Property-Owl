_ = require 'underscore'

system = require '../system'
async = require 'async'
Owl = system.models.owl

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'owls/index', owls: owls

exports.locate = (req, res) ->
  res.render 'owls/locate'

exports.top = (req, res) ->
  Owl.top (error, owl) ->
    res.render 'owls/show', owl: owl, bestdeal: true, enquire: on, share: on

exports.hot = (req, res) ->
  async.map ['qld', 'nsw', 'vic', 'sa', 'wa', 'nt', 'tas', 'act'], (state, callback) ->
    Owl.topstate state, callback
  , (error, owls) ->
    sortedOwls = _.sortBy owls, 'value'
    sortedOwls.reverse()
    
    res.render 'owls/list', owls: sortedOwls, maxPages: 1, currentPage: 1

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
    
    res.render 'owls/state', owls: owls, state: state

exports.show = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      res.render 'owls/show', owl: owl, enquire: on
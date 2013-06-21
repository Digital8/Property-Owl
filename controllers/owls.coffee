_ = require 'underscore'
async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  Owl.all (error, owls) ->
    
    res.render 'owls/index', owls: owls

exports.locate = (req, res) ->
  
  async.parallel
    
    page_top: (callback) -> Page.findByUrl '/owl-deals-top', callback
    
    page_bottom: (callback) -> Page.findByUrl '/owl-deals-bottom', callback
    
  , (error, {page_top, page_bottom}) ->
    
    try
      res.render 'owls/locate',
        cms_top: do jade.compile page_top.content
        cms_bottom: do jade.compile page_bottom.content
    
    catch {message}
      res.render 'errors/500', {message}

exports.top = (req, res) ->
  Owl.top (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      res.render 'owls/show', owl: owl, bestdeal: true, enquire: on, share: on, deal: owl

exports.hot = (req, res) ->
  async.map ['act', 'nsw', 'nt', 'qld', 'sa', 'tas', 'vic', 'wa'], (state, callback) ->
    Owl.topstate state, callback
  , (error, owls) ->
    
    async.map owls, (owl, callback) ->
      owl.hydrateForUser req.user, callback
    , (error) ->
      
      owls = _.filter owls, (owl) -> owl?.id?
      owls = (_.sortBy owls, 'ratio').reverse()

      
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
      
      res.render 'owls/show', owl: owl, enquire: on, deal: owl

exports.addDeal = (req, res) ->
  map = req.body
  map.entity_id = req.params.id
  map.type = 'owl'
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
  
  Owl.get id, (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      if typeof(owl.id) is 'undefined'
        res.render 'errors/404'
      else
        res.render 'owls/print', owl: owl, enquire: on

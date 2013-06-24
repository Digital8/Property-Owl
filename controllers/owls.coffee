_ = require 'underscore'
async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  if req.user.isDeveloper() and not req.user.isAdmin()
    Owl.byDeveloper req.user.id, (error, owls) ->
      res.render 'admin/owls/index', owls: owls, developers: []
  else
    Owl.all (error, owls) ->
      User.getUsersByGroup 2, (error, developers) ->
        res.render 'admin/owls/index', {owls, developers}

exports.show = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/show', {owl}

exports.edit = (req, res) ->
  
  async.parallel
    owl: (callback) -> Owl.get req.params.id, callback
    developers: (callback) -> User.developers callback
    developmentTypes: (callback) -> DevelopmentType.all callback
    developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    results.owl.set req.session.form
    delete req.session.form
    res.render 'admin/owls/edit', results

exports.add = (req, res, next) ->
  
  async.parallel
    developers: (callback) -> User.developers callback
    developmentTypes: (callback) -> DevelopmentType.all callback
    developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    Owl.new req.session.form, (error, owl) =>
      delete req.session.form
      return next error if error?
      owl.listed_by ?= req.user.id
      results.owl = owl
      res.render 'admin/owls/add', results

exports.create = (req, res, next) ->
  
  Owl.build req, (error, owl) ->
    
    if error?.errors?
      for key, message of error.errors
        req.flash 'error', "#{key} - #{message}"
      req.session.form = req.body
      return res.redirect 'back'
    
    return next error if error? 
    
    (require '../lib/mailer') 'listing-confirmation', 'Listing Confirmation',
      contactName: req.user?.first_name
      email: req.user?.email
    ,
      contactName: req.user?.first_name
      link: "/owls/#{owl.id}/edit"
    , (error) -> console.log error if error?
    
    (require '../lib/mailer') 'new-listing', 'New Listing',
      email: 'pyro@feisty.io'
    ,
      contactName: req.user?.first_name
      link: "admin/owls/#{owl.id}/edit"
    , (error) -> console.log error if error?
    
    req.flash 'success', 'Owl created!'
    res.redirect "/owls/#{owl.id}"

exports.update = (req, res, next) ->
  
  # make sure devs can't approve their own deals
  delete req.body.approved unless req.user?.isAdmin()
  
  Owl.patch req.params.id, req.body, req: req, (error, owl) =>
    
    if error?.errors?
      for key, message of error.errors
        req.flash 'error', "#{key} - #{message}"
      req.session.form = req.body
      return res.redirect 'back'
    
    if owl.approved
      (require '../../lib/mailer') 'listing-approval', 'Property Approved',
        email: owl.user.email
      ,
        contactName: owl.user.first_name
        link: "/owls/#{owl.id}/edit"
        address: owl.fullAddress
      , (error) -> console.log error if error?
    
    req.flash 'success', 'Owl updated!'
    res.redirect "/owls/#{owl.id}"

exports.patch = (req, res) ->
  
  Owl.patch req.params.id, req.body, (error, owl) ->
    
    res.send 200

exports.delete = (req, res) ->
  
  Owl.get req.params.id, (error, owl) ->
    
    res.render 'admin/owls/delete', {owl}

exports.destroy = (req, res) ->
  
  Owl.delete req.params.id, (error) ->
    
    res.send 200

# exports.clone = (req, res) ->
  
#   id = req.params.id
  
#   count = parseInt req.body.count
  
#   unless 0 <= count <= Infinity
#     return req.send status: 500
  
#   Owl.get id, (error, owl) ->
#     if error? then return req.send status: 500
    
#     console.log arguments...
    
#     async.map [0..count], (index, callback) ->
#       owl.clone callback
#     , (error) ->
#       return res.send status: 500 if error?
      
#       res.send status: 200

# exports.index = (req, res) ->
  
#   Owl.all (error, owls) ->
    
#     res.render 'owls/index', owls: owls

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

exports.print = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      if typeof(owl.id) is 'undefined'
        res.render 'errors/404'
      else
        res.render 'owls/print', owl: owl, enquire: on

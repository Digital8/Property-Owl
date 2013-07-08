_ = require 'underscore'
async = require 'async'

exports.index = (req, res) ->
  
  action = 'index'
  
  if req.user.isDeveloper() and not req.user.isAdmin()
    Owl.byDeveloper req.user.id, (error, owls) ->
      developers = []
      owls = _.sortBy owls, 'id'
      res.render 'admin/owls/index', {owls, developers, action}
  else
    Owl.all (error, owls) ->
      owls = _.sortBy owls, 'id'
      User.getUsersByGroup 2, (error, developers) ->
        res.render 'admin/owls/index', {owls, developers, action}

exports.admin = (req, res) ->
  
  async.parallel
    owl: (callback) -> Owl.get req.params.id, callback
    developers: (callback) -> User.developers callback
    developmentTypes: (callback) -> DevelopmentType.all callback
    developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    
    results.action = 'show'
    
    res.render 'admin/owls/show', results

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
    results.action = 'edit'
    res.render 'admin/owls/edit', results

exports.add = (req, res, next) ->
  
  async.parallel
    developers: (callback) -> User.developers callback
    developmentTypes: (callback) -> DevelopmentType.all callback
    developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    
    return next error if error?
    
    Owl.new req.session.form, (error, owl) =>
      delete req.session.form
      return next error if error?
      owl.listed_by ?= req.user.id
      results.owl = owl
      results.action = 'add'
      res.render 'admin/owls/add', results

exports.create = (req, res, next) ->
  
  req.body.listed_by ?= req.user.id
  
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
      email: 'swoopin@propertyowl.com.au'
    ,
      contactName: req.user?.first_name
      link: "admin/owls/#{owl.id}/edit"
    , (error) -> console.log error if error?
    
    req.flash 'success', 'Owl created!'
    res.redirect "/owls/#{owl.id}/admin"

exports.update = (req, res, next) ->
  
  # make sure devs can't approve their own deals
  delete req.body.approved unless req.user?.isAdmin()
  
  Owl.patch req.params.id, req.body, req: req, (error, owl) =>
    
    # return if req.guard req, res, next
    
    if error?.errors?
      for key, message of error.errors
        req.flash 'error', "#{key} - #{message}"
      req.session.form = req.body
      return res.redirect 'back'
    
    if owl.approved
      (require '../lib/mailer') 'listing-approval', 'Property Approved',
        email: owl.user.email
      ,
        contactName: owl.user.first_name
        link: "/owls/#{owl.id}/edit"
        address: owl.fullAddress
      , (error) -> console.log error if error?
    
    req.flash 'success', 'Owl updated!'
    res.redirect "/owls/#{owl.id}/admin"

exports.delete = (req, res) ->
  
  Owl.get req.params.id, (error, owl) ->
    
    res.render 'admin/owls/delete', {owl}

exports.destroy = (req, res) ->
  
  Owl.delete req.params.id, (error) ->
    
    res.send 200

exports.clone = (req, res, next) ->
  
  id = req.params.id
  
  count = parseInt req.body.count
  
  console.log 'cloning owl', id, count, 'times'
  
  unless 0 < count < Infinity
    return next 400
  
  Owl.get id, (error, owl) ->
    
    return next error if error?
    
    async.times count, (i, callback) -> 
      
      owl.clone (error, clone) ->
        
        return next error if error?
        
        patch = {}
        patch.entity_id = clone.id
        
        async.parallel
          deals: (callback) ->
            async.map owl.deals, (deal, callback) ->
              deal.clone (error, clone) ->
                return callback error if error?
                deal.patch patch, callback
            , callback
          files: (callback) ->
            async.map owl.files, (file, callback) ->
              file.clone (error, clone) ->
                return callback error if error?
                file.patch patch, callback
            , callback
          images: (callback) ->
            async.map owl.images, (image, callback) ->
              image.clone (error, clone) ->
                return callback error if error?
                image.patch patch, callback
            , callback
        , callback
    
    , (error) ->
      
      return next error if error?
      
      req.flash 'success', 'Owl cloned!'
      
      res.send 200

exports.locate = (req, res) ->
  
  async.parallel
    
    page_top: (callback) -> Page.block req.url, 'top', callback
    
    page_bottom: (callback) -> Page.block req.url, 'bottom', callback
    
  , (error, {page_top, page_bottom}) ->
    
    try
      res.render 'owls/locate',
        cms_top: page_top.html
        cms_bottom: page_bottom.html
    
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
      
      res.render 'owls/show', owl: owl, enquire: on, deal: owl, _action: 'show'

exports.print = (req, res) ->
  {id} = req.params
  
  Owl.get id, (error, owl) ->
    owl.hydrateForUser req.user, (error) ->
      if typeof(owl.id) is 'undefined'
        res.render 'errors/404'
      else
        res.render 'owls/print', owl: owl, enquire: on
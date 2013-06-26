_ = require 'underscore'
async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  action = 'index'
  
  if req.user.isDeveloper() and not req.user.isAdmin()
    Barn.byDeveloper req.user.id, (error, barns) ->
      res.render 'admin/barns/index', {barns, action}
  else
    Barn.all (error, barns) ->
      res.render 'admin/barns/index', {barns, action}

exports.edit = (req, res, next) ->
  
  async.parallel
    barn: (callback) -> Barn.get req.params.id, callback
    developers: (callback) -> User.developers callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    
    return next 404 unless results.barn?
    
    results.barn.set req.session.form
    
    delete req.session.form
    
    results.action = 'edit'
    
    res.render 'admin/barns/edit', results

exports.add = (req, res, next) ->
  
  async.parallel
    developers: (callback) -> User.developers callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    
    return next error if error?
    
    Barn.new req.session.form, (error, barn) =>
      delete req.session.form
      return next error if error?
      barn.listed_by ?= req.user.id
      results.barn = barn
      results.action = 'add'
      res.render 'admin/barns/add', results

exports.create = (req, res) ->
  
  req.body.listed_by ?= req.user.id
  
  Barn.build req, (error, barn) ->
    
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
      link: "/barns/#{barn.id}/edit"
    , (error) -> console.log error if error?
    
    (require '../lib/mailer') 'new-listing', 'New Listing',
      email: 'swoopin@propertyowl.com.au'
    ,
      contactName: req.user?.first_name
      link: "admin/barns/#{barn.id}/edit"
    , (error) -> console.log error if error?
    
    req.flash 'success', 'Barn created!'
    res.redirect "/barns/#{barn.id}/edit"

exports.delete = (req, res) ->
  
  Barn.get req.params.id, (error, barn) ->
    
    res.render 'admin/barns/delete', {barn}

exports.destroy = (req, res) ->
  
  Barn.delete req.params.id, (error) ->
    
    res.send 200

exports.update = (req, res, next) ->
  
  # make sure devs can't approve their own deals
  delete req.body.approved unless req.user?.isAdmin()
  
  Barn.patch req.params.id, req.body, req: req, (error, barn) =>
    
    if error?.errors?
      for key, message of error.errors
        req.flash 'error', "#{key} - #{message}"
      req.session.form = req.body
      return res.redirect 'back'
    
    if barn.approved
      (require '../lib/mailer') 'listing-approval', 'Property Approved',
        email: barn.user.email
      ,
        contactName: barn.user.first_name
        link: "/barns/#{barn.id}/edit"
        address: barn.fullAddress
      , (error) -> console.log error if error?
    
    req.flash 'success', 'Barn updated!'
    res.redirect "/barns"

exports.patch = (req, res) ->
  
  Barn.patch req.params.id, req.body, (error, barn) ->
    
    res.send 200

exports.browse = (req, res) ->
  
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
    
    barn.hydrateForUser req.user, (error) ->
      
      res.render 'barns/show', barn: barn, enquire: on, deal: barn

exports.owls = (req,res) ->
  Barn.get req.params.id, (error, barn) ->
    return res.send 500, error if error?
    return res.render 'errors/404' unless barn?
    res.send barn.owls

exports.nest = (req, res, next) ->
  
  {barn, owl} = req
  
  owl.patch barn_id: barn.id, (error) ->
    
    return next error if error?
    
    res.send 200

exports.unnest = (req, res, next) ->
  
  {barn, owl} = req
  
  owl.patch barn_id: null, (error) ->
    
    return next error if error?
    
    res.send 200

exports.print = (req, res, next) ->
  
  Barn.get req.params.id, (error, barn) ->
    
    return next error if error?
    
    res.render 'barns/print',
      barn: barn
      enquire: on
      deal: barn
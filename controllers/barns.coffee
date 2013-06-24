_ = require 'underscore'
async = require 'async'
jade = require 'jade'

exports.index = (req, res) ->
  
  if req.user.isDeveloper() and not req.user.isAdmin()
    Barn.byDeveloper req.user.id, (error, barns) ->
      res.render 'admin/barns/index', {barns}
  else
    Barn.all (error, barns) ->
      res.render 'admin/barns/index', {barns}

exports.edit = (req, res) ->
  
  async.parallel
    barn: (callback) -> Barn.get req.params.id, callback
    developers: (callback) -> User.developers callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    results.barn.set req.session.form
    delete req.session.form
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
      res.render 'admin/barns/add', results

exports.create = (req, res) ->
  
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
      email: 'pyro@feisty.io'
    ,
      contactName: req.user?.first_name
      link: "admin/barns/#{barn.id}/edit"
    , (error) -> console.log error if error?
    
    req.flash 'success', 'Barn created!'
    res.redirect "/barns/#{barn.id}"

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
      (require '../../lib/mailer') 'listing-approval', 'Property Approved',
        email: barn.user.email
      ,
        contactName: barn.user.first_name
        link: "/barns/#{barn.id}/edit"
        address: barn.fullAddress
      , (error) -> console.log error if error?
    
    req.flash 'success', 'Barn updated!'
    res.redirect "/barns/#{barn.id}"

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

exports.nest = (req, res) ->
  
  exports.db.query "UPDATE barns SET barn_id = ? WHERE barn_id = ?", [req.params.id, req.body.id], (error, results) ->
    
    res.send [error, results]

exports.unnest = (req, res) ->
  
  {barn_id, barn_id} = req.params
  
  exports.db.query "UPDATE barns SET barn_id = NULL WHERE barn_id = ?", [barn_id], (error, results) ->
    
    res.send [error, results]

exports.print = (req, res, next) ->
  
  Barn.get req.params.id, (error, barn) ->
    
    return next error if error?
    
    res.render 'barns/print',
      barn: barn
      enquire: on
      deal: barn
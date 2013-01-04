fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Owl = system.models.owl

helpers =
  mailer: system.load.helper 'mailer'

exports.index = (req, res) ->
  if res.locals.objUser.isDeveloper() and not res.locals.objUser.isAdmin()
    Owl.byDeveloper res.locals.objUser.id, (error, owls) ->
      res.render 'admin/owls/index', owls: owls
  else
    Owl.all (error, owls) ->
      res.render 'admin/owls/index', owls: owls

exports.view = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/view', owl: owl
    
exports.edit = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/edit', owl: owl

exports.add = (req, res) ->
  Owl.create {}, (error, owl) ->
    res.render 'admin/owls/add', owl: owl

exports.create = (req, res) ->
  
  if not res.locals.objUser.isAdmin() then req.body.approved = 0

  Owl.create req.body, (error, owl) ->
    
    if error then console.log error
    template = 'listing-confirmation'

    user =
      contactName: res.locals.objUser.firstName
      email: res.locals.objUser.email

    secondary = 
      contactName: res.locals.objUser.firstName
      dealLink: '/admin/owls/#{owl.insertId}/edit'

    if owl
      system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
        if results is true 
          owl.upload req, ->
            res.redirect "/owls/#{owl.id}"
        else
          res.redirect "/owls/#{owl.id}"
    else
      req.flash('error', 'Database says: ' + error.code)
      res.redirect 'back'
      
exports.update = (req, res) ->
  # delete req.body.approved
  
  if req.body.approved is 'on' then req.body.approved = true
  if not res.locals.objUser.isAdmin() then req.body.approved = false
  
  Owl.update req.params.id, req.body, (error, owl) ->
    
    owl.upload req, ->
      res.redirect '/admin/owls'

exports.patch = (req, res) ->
  Owl.patch req.params.id, req.body, (error, owl) ->
    
    res.send status: 200

exports.delete = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/delete', owl: owl

exports.destroy = (req, res) ->
  Owl.delete req.params.id, (error) ->
    req.flash 'success', 'owl deleted'
    
    res.redirect '/admin/owls'
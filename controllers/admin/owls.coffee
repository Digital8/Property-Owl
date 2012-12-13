fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Owl = system.models.owl

helpers =
  mailer: system.load.helper('mailer')

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'admin/owls/index', owls: owls

exports.view = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/view', owl: owl
    
exports.edit = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/edit', owl: owl

exports.add = (req, res) ->
  Owl.new (error, owl) ->
    res.render 'admin/owls/add', owl: owl

exports.create = (req, res) ->
  Owl.create req.body, (error, owl) ->
    console.log 'create', arguments
    
    template = 'listing-confirmation'

    user =
      contactName: res.locals.objUser.firstName
      email: res.locals.objUser.email

    secondary = 
      dealLink: '/admin/owls/#{owl.insertId}/edit'

    system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
      if results is true 
        #owl.upload req, ->
        res.redirect "/owls/#{owl.id}"
      else
        res.redirect "/owls/#{owl.id}"

exports.update = (req, res) ->
  Owl.update req.params.id, req.body, (error, owl) ->
    console.log 'update', arguments
    
    owl.upload req, ->
      res.redirect '/admin/owls'

exports.delete = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/delete', owl: owl

exports.destroy = (req, res) ->
  Owl.delete req.params.id, (error) ->
    req.flash 'success', 'owl deleted'
    
    res.redirect '/admin/owls'
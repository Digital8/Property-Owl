system = require '../../system'

Owl = system.models.owl

exports.index = (req, res) ->
  Owl.all (error, owls) ->
    res.render 'admin/owls/index', owls: owls

exports.edit = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    console.log owl
    res.render 'admin/owls/edit', owl: owl

exports.add = (req, res) ->
  Owl.new (error, owl) ->
    res.render 'admin/owls/add', owl: owl

exports.create = (req, res) ->
  Owl.create req.body, (error, owl) ->
    console.log 'create', arguments
    res.redirect "/owls/#{owl.id}"

exports.delete = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/delete', owl: owl

exports.destroy = (req, res) ->
  Owl.delete req.params.id, (error) ->
    req.flash 'success', 'owl deleted'
    
    res.redirect '/admin/owls'
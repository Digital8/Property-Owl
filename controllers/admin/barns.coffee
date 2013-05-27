fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

models =
  user: system.load.model('user')

Barn = system.models.barn
User = system.models.user

exports.index = (req, res) ->
  if res.locals.objUser.isDeveloper() and not res.locals.objUser.isAdmin()
    Barn.byDeveloper res.locals.objUser.id, (error, barns) ->
      res.render 'admin/barns/index', barns: barns or {}
  else
    Barn.all (error, barns) ->
      res.render 'admin/barns/index', barns: barns or {}

exports.edit = (req, res) ->
  Barn.get req.params.id, (error, barn) ->
    models.user.getUsersByGroup 2, (err, developers) ->
      models.user.getUsersByGroup 3, (err, admins) ->
        developers = developers.concat(admins)
        res.render 'admin/barns/edit', barn: barn, developers: developers

exports.add = (req, res) ->
  models.user.getUsersByGroup 2, (err, developers) ->
    models.user.getUsersByGroup 3, (err, admins) ->
      developers = developers.concat(admins)
      res.render 'admin/barns/add', barn: {listed_by: res.locals.objUser.id}, developers: developers or {}






exports.create = (req, res) ->
  Barn.create req.body, (error, barn) ->
    # barn.upload req, ->
    template = 'listing-confirmation'

    user =
      contactName: res.locals.objUser.firstName
      email: res.locals.objUser.email

    secondary = 
      contactName: res.locals.objUser.firstName
      link: "/admin/barns/#{barn.id}/edit"

    system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
      res.redirect 'back'

exports.delete = (req, res) ->
  Barn.get req.params.id, (error, barn) ->
    res.render 'admin/barns/delete', barn: barn

exports.destroy = (req, res) ->
  Barn.delete req.params.id, (error) ->
    req.flash 'success', 'barn deleted'
    res.redirect '/admin/barns'

exports.update = (req, res) ->
  
  finish = ->
    res.redirect '/admin/barns'

  Barn.update req.params.id, req.body, (error, barn) ->
    barn.upload req, ->
      # Redo the deals
      if req.body.deal_type_id? and req.body.deal_type_id.length > 1
        console.log('deal update')
        system.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'barn'", [req.params.id], ->
          req.body.deal_type_id.pop() # Remove empty array off the end

          j = 0

          async.whilst ->
            return j < req.body.deal_type_id.length
          ,
          (cb) ->
            values =
              desc: req.body.deal_desc[j] or ''
              entity_id: barn.id
              user_id: res.locals.objUser.id or 0
              value: req.body.deal_value[j] or 0
              deal_type_id: req.body.deal_type_id[j] or 0

            system.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'barn',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
              if err then console.log err
              j++
              cb()
          ,
          ->
            finish()
      else
        finish()



exports.patch = (req, res) ->
  
  Barn.patch req.params.id, req.body, (error, barn) ->
    
    res.send status: 200
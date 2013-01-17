fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Owl = system.models.owl
Deal = system.models.deal

helpers =
  mailer: system.load.helper 'mailer'

exports.index = (req, res) ->
  if res.locals.objUser.isDeveloper() and not res.locals.objUser.isAdmin()
    Owl.byDeveloper res.locals.objUser.id, (error, owls) ->
      res.render 'admin/owls/index', owls: owls
  else
    Owl.all (error, owls) ->
      res.render 'admin/owls/index', owls: owls

exports.show = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/show', owl: owl
    
exports.edit = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/edit', owl: owl

exports.add = (req, res) ->
  res.render 'admin/owls/add', owl: {}

exports.create = (req, res) ->
  count = 0
  
  if not res.locals.objUser.isAdmin() then req.body.approved = 0

  async.whilst ->
    # While count < clone_num evaluates true
    return count <= req.body.clone_num
  ,
  (callback) ->
    # Increment our counter
    count++

    # Create the owl
    Owl.create req.body, (error, owl) -> 
      if error then console.log error
      template = 'listing-confirmation'

      user =
        contactName: res.locals.objUser.firstName
        email: res.locals.objUser.email

      secondary = 
        contactName: res.locals.objUser.firstName
        dealLink: "/admin/owls/#{owl.id}/edit"

      email = ->
        # If owl created, send email
        if owl
          system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
            if results is true 
              owl.upload req, ->
                callback()
            else
              callback()
        else
          callback()

      # Create some deals
      if req.body.deal_type_id? and req.body.deal_type_id.length > 1

        req.body.deal_type_id.pop() # Remove empty array off the end


        j = 0

        async.whilst ->
          return j < req.body.deal_type_id.length
        ,
        (cb) ->
          values =
            desc: req.body.deal_desc[j] or ''
            entity_id: owl.id
            user_id: res.locals.objUser.id or 0
            value: req.body.deal_value[j] or 0
            deal_type_id: req.body.deal_type_id[j] or 0

          system.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'owl',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
            if err then console.log err
            j++
            cb()
        ,
        ->
          email()

      else
        email()
  ,
  (err) ->
    # Set a notification and redirect
    req.flash('success', 'Owls generated successfully')
    res.redirect 'back'
      
exports.update = (req, res) ->
  # delete req.body.approved

  req.body.clone_num ?= 0
  count = 0

  if req.body.approved is 'on' then req.body.approved = true
  if not res.locals.objUser.isAdmin() then req.body.approved = false
  
  clone = ->
    # Now, we check if we're having to create any clones before we redirect
    if parseInt(req.body.clone_num) is 0
      res.redirect '/admin/owls'
    else
      n = 0
      async.whilst ->
        # While count < clone_num evaluates true
        return n < req.body.clone_num
      ,
      (callback) ->
        # Increment our counter
        n++
        console.log "DEFUQ" + typeof(callback)
        # Create the owl
        Owl.create req.body, (error, owl) -> 
          if error then console.log error
          template = 'listing-confirmation'

          user =
            contactName: res.locals.objUser.firstName
            email: res.locals.objUser.email

          secondary = 
            contactName: res.locals.objUser.firstName
            dealLink: '/admin/owls/#{owl.insertId}/edit'

          email = ->
            # If owl created, send email
            if owl
              system.helpers.mailer template,'Listing Confirmation', user, secondary, (results) ->
                if results is true 
                  owl.upload req, ->
                    callback()
                else
                  callback()
            else
              callback()

          # Create some deals
          if req.body.deal_type_id? and req.body.deal_type_id.length > 1

            req.body.deal_type_id.pop() # Remove empty array off the end


            j = 0

            async.whilst ->
              return j < req.body.deal_type_id.length
            ,
            (cb) ->
              values =
                desc: req.body.deal_desc[j] or ''
                entity_id: owl.id
                user_id: res.locals.objUser.id or 0
                value: req.body.deal_value[j] or 0
                deal_type_id: req.body.deal_type_id[j] or 0

              system.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'owl',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
                if err then console.log err
                j++
                cb()
            ,
            ->
              email()

          else
            email()
      ,
      (err) ->
        # Set a notification and redirect
        req.flash('success', 'Owls updated successfully')
        res.redirect 'back'

  Owl.update req.params.id, req.body, (error, owl) ->
    owl.upload req, ->

      # Delete the old deals, and recreate them
      system.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'owl'", [req.params.id], ->
        j = 0

        if req.body.deal_type_id? and req.body.deal_type_id.length <= 1
          clone()
        else
          req.body.deal_type_id.pop() # Remove empty array off the end

          async.whilst ->
            return j < req.body.deal_type_id.length
          ,
          (cb) ->

            values =
              desc: req.body.deal_desc[j] or ''
              entity_id: owl.id
              user_id: res.locals.objUser.id or 0
              value: req.body.deal_value[j] or 0
              deal_type_id: req.body.deal_type_id[j] or 0

            system.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'owl',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
              if err then console.log err
              j++
              cb()
          ,
          ->
           clone()


exports.patch = (req, res) ->
  Owl.patch req.params.id, req.body, (error, owl) ->
    
    res.send status: 200

exports.delete = (req, res) ->
  Owl.get req.params.id, (error, owl) ->
    res.render 'admin/owls/delete', owl: owl

exports.destroy = (req, res) ->
  Owl.delete req.params.id, (error) ->
    
    res.send status: 200

exports.clone = (req, res) ->
  id = req.params.id
  
  count = parseInt req.body.count
  
  unless 0 <= count <= Infinity
    return req.send status: 500
  
  Owl.get id, (error, owl) ->
    if error? then return req.send status: 500
    
    console.log arguments...
    
    async.map [0..count], (index, callback) ->
      owl.clone callback
    , (error) ->
      return res.send status: 500 if error?
      
      res.send status: 200
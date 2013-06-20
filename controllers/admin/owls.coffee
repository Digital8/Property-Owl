async = require 'async'

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
    res.render 'admin/owls/edit', results

exports.add = (req, res) ->
  
  async.parallel
    developers: (callback) -> User.developers callback
    developmentTypes: (callback) -> DevelopmentType.all callback
    developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    results.owl = listed_by: req.user.id
    res.render 'admin/owls/add', results

exports.create = (req, res) ->
  count = 0
  popped = false
  
  if not req.user?.isAdmin() then req.body.approved = 0
  req.body.listed_by ?= req.user?.id


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
        contactName: req.user?.first_name
        email: req.user?.email

      secondary = 
        contactName: req.user?.first_name
        link: "/admin/owls/#{owl.id}/edit"

      email = ->
        # If owl created, send email
        if owl
          (require '../../lib/mailer') template,'Listing Confirmation', user, secondary, (results) ->
            if results is true
              # Notify Admin of new listing
              template = 'new-listing'

              user =
                email: 'swoopin@propertyowl.com.au'

              secondary = 
                contactName: req.user?.first_name
                link: "admin/owls/#{owl.id}/edit"

              (require '../../lib/mailer') template,'New Listing', user, secondary, (results) ->
                owl.upload req, ->
                  callback()
            else
              callback()
        else
          callback()

      # Create some deals
      if req.body.deal_type_id? and req.body.deal_type_id.length > 1

        if popped is false
          req.body.deal_type_id.pop() # Remove empty array off the end
          popped = true


        j = 0

        async.whilst ->
          return j < req.body.deal_type_id.length
        ,
        (cb) ->
          values =
            desc: req.body.deal_desc[j] or ''
            entity_id: owl.id
            user_id: req.user?.id or 0
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
  if not req.user?.isAdmin() then req.body.approved = false
  
  clone = (owl) ->
    # Now, we check if we're having to create any clones before we redirect
    if parseInt(req.body.clone_num) is 0
      if req.body.approved
        template = 'listing-approval'
        user =
          email: owl.user.email

        secondary =
          contactName: owl.user.first_name 
          link: '/admin/owls/#{owl.id}/edit'
          address: "#{owl.address}, #{owl.suburb}, #{owl.state.toUpperCase()}"
        
        # Send approval message
        (require '../../lib/mailer') template,'Property Approved', user, secondary, (results) ->
          res.redirect '/admin/owls'

      else
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
        
        # Create the owl
        req.body.listed_by ?= req.user?.id
        Owl.create req.body, (error, owl) ->
          if error then console.log error
          template = 'listing-confirmation'

          user =
            contactName: req.user?.first_name
            email: req.user?.email

          secondary = 
            contactName: req.user?.first_name
            dealLink: '/admin/owls/#{owl.insertId}/edit'

          email = ->
            # If owl created, send email
            if owl
              (require '../../lib/mailer') template,'Listing Confirmation', user, secondary, (results) ->
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
                user_id: req.user?.id or 0
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
          clone(owl)
        else
          req.body.deal_type_id.pop() # Remove empty array off the end

          async.whilst ->
            return j < req.body.deal_type_id.length
          ,
          (cb) ->

            values =
              desc: req.body.deal_desc[j] or ''
              entity_id: owl.id
              user_id: req.user?.id or 0
              value: req.body.deal_value[j] or 0
              deal_type_id: req.body.deal_type_id[j] or 0

            system.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'owl',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
              if err then console.log err
              j++

              cb()
          ,
          ->
            clone(owl)

exports.patch = (req, res) ->
  
  Owl.patch req.params.id, req.body, (error, owl) ->
    
    res.send 200

exports.delete = (req, res) ->
  
  Owl.get req.params.id, (error, owl) ->
    
    res.render 'admin/owls/delete', owl: owl

exports.destroy = (req, res) ->
  
  Owl.delete req.params.id, (error) ->
    
    res.send 200

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
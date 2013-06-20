async = require 'async'

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
    # developmentTypes: (callback) -> DevelopmentType.all callback
    # developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    res.render 'admin/barns/edit', results

exports.add = (req, res) ->
  
  async.parallel
    developers: (callback) -> User.developers callback
    # developmentTypes: (callback) -> DevelopmentType.all callback
    # developmentStatuses: (callback) -> DevelopmentStatus.all callback
    dealTypes: (callback) -> DealType.all callback
  , (error, results) ->
    results.barn = listed_by: req.user.id
    console.log results.developers
    res.render 'admin/barns/add', results

exports.create = (req, res) ->
  
  Barn.create req.body, (error, barn) ->
    
    barn.upload req, ->
      
      (require '../../lib/mailer') 'listing-confirmation', 'Listing Confirmation',
        contactName: req.user.first_name
        email: req.user.email
      ,
        contactName: req.user.first_name
        link: "/admin/barns/#{barn.id}/edit"
      , (results) ->
        res.redirect 'admin/barns'

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
        exports.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'barn'", [req.params.id], ->
          req.body.deal_type_id.pop() # Remove empty array off the end
          
          j = 0
          
          async.whilst ->
            return j < req.body.deal_type_id.length
          ,
          (cb) ->
            values =
              desc: req.body.deal_desc[j] or ''
              entity_id: barn.id
              user_id: req.user.id or 0
              value: req.body.deal_value[j] or 0
              deal_type_id: req.body.deal_type_id[j] or 0
            
            exports.db.query "INSERT INTO deals(description,entity_id,user_id,value,deal_type_id,type,updated_at, created_at) VALUES(?,?,?,?,?,'barn',now(), now())", [values.desc, values.entity_id, values.user_id, values.value, values.deal_type_id], (err, results) ->
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
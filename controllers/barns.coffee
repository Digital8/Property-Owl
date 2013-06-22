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
    
    return res.send 500, error if error?
    return res.render 'errors/404' unless barn?
    
    res.render 'barns/show', barn: barn, enquire: on, deal: barn

exports.owls = (req,res) ->
  Barn.get req.params.id, (error, barn) ->
    return res.send 500, error if error?
    return res.render 'errors/404' unless barn?
    res.send barn.owls

exports.nest = (req, res) ->
  exports.db.query "UPDATE owls SET barn_id = ? WHERE owl_id = ?", [req.params.id, req.body.id], (error, results) ->
    res.send [error, results]

exports.unnest = (req, res) ->
  {barn_id, owl_id} = req.params
  
  exports.db.query "UPDATE owls SET barn_id = NULL WHERE owl_id = ?", [owl_id], (error, results) ->
    res.send [error, results]

exports.addDeal = (req, res) ->
  map = req.body
  map.entity_id = req.params.id
  map.type = 'barn'
  map.user_id = req.user.id
  
  Deal.create req.body, (error, deal) ->
    res.send deal

exports.removeDeal = (req, res) ->
  Deal.delete req.params.deal_id, ->
    res.send 'OK'

exports.patchDeal = (req, res) ->
  owlId = req.params.owl_id
  dealId = req.params.deal_id
  
  Deal.patch dealId, req.body, (error, model) ->
    
    res.send status: 200

exports.print = (req, res) ->
  {id} = req.params
  
  Barn.get id, (error, barn) ->
    res.render 'barns/print', barn: barn, enquire: on, deal: barn
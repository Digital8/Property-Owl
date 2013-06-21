# TODO error checking

exports.create = (req, res) ->
  
  return if req.guard arguments...
  
  {entity, user} = req
  
  user ?= id: 0
  
  Enquiry.create
    user_id: user.id
    entity_id: req.param 'entity_id'
    entity_type: req.param 'entity_type'
    comment: req.param 'comment'
  , (error, enquiry) ->
    
    return next error if error?
    
    res.send id: enquiry.id
    
    template = {
      affiliate: 'affiliate-enquiry'
      owl: 'deal-enquiry'
      barn: 'deal-enquiry'
    }[entity.constructor.name.toLowerCase()]
    
    email = {
      affiliate: -> entity.email
      owl: -> entity.user.email
      barn: -> entity.user.email
    }[entity.constructor.name.toLowerCase()]()
    
    dear = {
      affiliate: -> entity.name
      owl: -> entity.user.first_name
      barn: -> entity.user.first_name
    }[entity.constructor.name.toLowerCase()]()
    
    user =
      email: email
      dear: dear
    
    link = "/#{entity.constructor.table.name}/#{entity.id}"
    
    secondary =
      first_name: req.param 'first_name'
      last_name: req.param 'last_name'
      link: link
      address: entity.address
      comment: req.param 'comment'
      entity_type: entity.constructor.name.toLowerCase()
      entity_id: entity.id
      email: req.param 'email'
      phone: req.param 'phone'
      contact_method: req.param 'contact_method'
      name: entity.name
    
    (require '../lib/mailer') template, 'New Enquiry', user, secondary, (error) ->
    
    template = {
      affiliate: 'affiliate-enquiry-confirmation'
      owl: 'deal-enquiry-confirmation'
      barn: 'deal-enquiry-confirmation'
    }[entity.constructor.name.toLowerCase()]
    
    user =
      email: req.param 'email'
      dear: req.param 'first_name'
    
    (require '../lib/mailer') template, 'Enquiry Confirmation', user, secondary, (error) ->
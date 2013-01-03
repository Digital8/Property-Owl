system = require '../system'

Enquiry = system.models.enquiry
Affiliate = system.models.affiliate
Owl = system.models.owl
Barn = system.models.barn

exports.create = (req, res) ->
  
  {entity_id, entity_type} = req.body
  
  unless entity_type in ['owl', 'barn', 'affiliate']
    return res.send status: 500
  
  model = system.models[entity_type]
  
  model.get entity_id, (error, record) ->
    if error? or not record
      return res.send status: 404
    
    map =
      user_id: req.user.id
      entity_id: req.body.entity_id
      entity_type: req.body.entity_type
      enquiry: req.body.enquiry
    
    Enquiry.create map, (error, model) ->
      console.log arguments...
      
      res.send status: 200
      
      template_map =
        affiliate: 'service-enquiry'
      
      if template_map[entity_type]?
        
        template = template_map[entity_type]
        
        user =
          firstName: req.body.name
          email: req.body.email
          lastName: req.body.name
          phone: req.body.phone
        
        secondary =
          contactName: req.body.name
          description: req.body.enquiry
          contact_method: req.body.contact or 'phone'
          enquiryEmail: req.body.email
        
        system.helpers.mailer template, 'New Enquiry', user, secondary, (results) ->
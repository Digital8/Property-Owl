system = require '../system'

Enquiry = system.models.enquiry
Affiliate = system.models.affiliate
Owl = system.models.owl
Barn = system.models.barn
User = system.models.user

exports.create = (req, res) ->
  {entity_id, entity_type} = req.body
  
  unless entity_type in ['owl', 'barn', 'affiliate']
    return res.send status: 500
  
  model = system.models[entity_type]
  
  model.get entity_id, (error, record) ->
    if error? or not record
      return res.send status: 404
    User.getUserById record.listed_by , (err, developer) ->
      map =
        user_id: req.user.id
        entity_id: req.body.entity_id
        entity_type: req.body.entity_type
        enquiry: req.body.enquiry
      
      Enquiry.create map, (error, model) ->
        
        res.send status: 200
        
        template_map =
          affiliate: 'service-enquiry'
          owl: 'owl-deal-enquiry'
          barn: 'barn-deal-enquiry'
        
        if template_map[entity_type]?
          template = template_map[entity_type]
          user =
            email: developer[0].email
            firstName: req.body.name or res.locals.objUser.displayName
            email: req.body.email or res.locals.objUser.email
            lastName: ''
            phone: req.body.phone
          
          secondary =
            owl_id: record.id
            contactName: req.body.name
            address: record.address or ''
            description: req.body.enquiry
            contact_method: req.body.contact or 'phone'
            enquiryEmail: req.body.email or res.locals.objUser.email
            contactName: developer[0].first_name
          
          system.helpers.mailer template, 'New Enquiry', user, secondary, (results) ->
            if results is true
              res.send status: 200
            else
              res.send status: 500
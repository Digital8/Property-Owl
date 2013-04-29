system = require '../system'

Enquiry = system.models.enquiry
Affiliate = system.models.affiliate
Owl = system.models.owl
Barn = system.models.barn
User = system.models.user

exports.create = (req, res) ->
  {entity_id, entity_type} = req.body

  console.log 'enquiry form', req.body
  
  unless entity_type in ['owl', 'barn', 'affiliate']
    return res.send status: 500
  
  model = system.models[entity_type]
  
  model.get entity_id, (error, record) ->
    if error? or not record
      return res.send status: 404

    rcpt = res.locals.objUser.email or ''
    
    if record.user? then rcpt = record.user.email

    User.getUserById record.listed_by , (err, developer) ->
      if entity_type is 'affiliate'
        rcpt = record.email

      if developer.length is 0
        developer = 'Service'
      else
        developer = developer[0].first_name
        
      map =
        user_id: req.user?.id or 0
        entity_id: req.body.entity_id
        entity_type: req.body.entity_type
        enquiry: req.body.enquiry
      
      Enquiry.create map, (error, model) ->
        if error then throw error
        res.send status: 200
        
        template_map =
          affiliate: 'affiliate-enquiry'
          owl: 'owl-deal-enquiry'
          barn: 'barn-deal-enquiry'
        
        if template_map[entity_type]?
          template = template_map[entity_type]

          user =
            email: rcpt
            firstName: req.body.name# or res.locals.objUser.displayName
            lastName: ''
            phone: req.body.phone
          
          secondary =
            owl_id: record.id
            contactName: req.body.name
            address: record.address or ''
            title: record.name or ''
            description: req.body.enquiry
            contact_method: req.body.contact or 'phone'
            enquiryEmail: req.body.email# or res.locals.objUser.email
            contactName: developer
            link: "/#{entity_type}s/#{record.id}"
          
          system.helpers.mailer template, 'New Enquiry', user, secondary, (results) ->
            user =
              email: req.body.email# or res.locals.objUser.email
              firstName: req.body.name# or res.locals.objUser.displayName
              lastName: ''

            system.helpers.mailer "#{entity_type}-enquiry-confirmation", "Enquiry Confirmation", user, secondary, ->
              if results is true
                res.send status: 200
              else
                res.send status: 500

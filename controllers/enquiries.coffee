# TODO error checking

exports.create = (req, res) ->
  
  {entity_id, entity_type} = req.body
  
  console.log 'enquiry form', req.body
  
  unless entity_type in ['owl', 'barn', 'affiliate']
    return res.send 500
  
  model = exports.models[entity_type]
  
  model.get entity_id, (error, record) ->
    
    return res.send 500, erorr if error?
    return res.send 404 unless record?
    
    rcpt = req.user?.email or ''
    
    if record.user? then rcpt = record.user.email
    
    User.get record.listed_by, (error, developer) ->
      
      if entity_type is 'affiliate'
        rcpt = record.email
      
      if developer?
        developer = developer.first_name
      else
        developer = 'Service'
      
      console.log req.user
      
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
            firstName: req.body.name
            lastName: ''
            phone: req.body.phone
          
          secondary =
            owl_id: record.id
            barn_id: record.id
            contactName: req.body.name
            address: record.address or ''
            title: record.name or ''
            description: req.body.enquiry
            contact_method: req.body.contact or 'phone'
            enquiryEmail: req.body.email
            contactName: developer
            link: "/#{entity_type}s/#{record.id}"
          
          (require '../lib/mailer') template, 'New Enquiry', user, secondary, (results) ->
            
            user =
              email: req.body.email
              firstName: req.body.name
              lastName: ''
            
            (require '../lib/mailer') "#{entity_type}-enquiry-confirmation", "Enquiry Confirmation", user, secondary, ->
              
              res.send 200
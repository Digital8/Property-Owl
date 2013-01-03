system = require '../system'

Enquiry = system.models.enquiry

exports.create = (req, res) ->
  console.log req.body
  
  system.db.query "SELECT * FROM affiliates WHERE affiliate_id = ?", [req.body.entity_id], (err, affiliate) ->
    
    if err or affiliate.length is 0
      
      res.send status: 500, error: 'Invalid product', body: req.body or {}
    
    else
      template = 'service-enquiry'
      
      user =
        firstName: req.body.name
        email: affiliate[0].email
        lastName: ''
        phone: req.body.phone
      
      secondary =
        contactName: affiliate[0].name
        description: req.body.enquiry
        contact_method: req.body.contact or 'phone'
        enquiryEmail: req.body.email
      
      system.helpers.mailer template,'New Enquiry', user, secondary, (results) ->
        
        map =
          user_id: req.user.id
          entity_id: req.body.entity_id
          entity_type: req.body.entity_type
          enquiry: req.body.enquiry
        
        Enquiry.create map, (error, model) ->
          console.log arguments...
          res.send status: 200

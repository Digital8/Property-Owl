system = require '../system'

Enquiry = system.models.enquiry

exports.create = (req, res) ->
  # system.db.query "SELECT * FROM affiliates WHERE affiliate_id = ?", [req.body.aid], (err, affiliate) ->
  #   if err or affiliate.length is 0
  #     res.send status: 500, error: 'Invalid product'
  #   else
  #     template = 'service-enquiry'

  #     user =
  #       firstName: res.locals.objUser.firstName
  #       email: affiliate[0].email
  #       lastName: res.locals.objUser.lastName
  #       phone: res.locals.objUser.phone

  #     secondary =
  #       contactName: affiliate[0].name
  #       description: req.body.enquiry
  #       contact_method: 'email'
  #       enquiryEmail: res.locals.objUser.email
      
  #     system.helpers.mailer template,'New Enquiry', user, secondary, (results) ->
  
  map =
    user_id: req.user.id
    entity_id: req.body.entity_id
    entity_type: req.body.entity_type
    enquiry: req.body.enquiry
  
  Enquiry.create map, (error, model) ->
    console.log arguments...
    res.send status: 200
  
  # system.db.query  "INSERT INTO enquiries VALUES ?", map, (err, rows) ->
  #   if err 
  #     res.send status: 500, error: err
  #   else 
  #     res.send status: 200
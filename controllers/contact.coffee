{SendGrid, Email} = require 'sendgrid'
sendgrid = new SendGrid 'digital8', '1lovedDMDN'

exports.index = (req,res) ->
  
  form = req.session.form or {}
  delete req.session.form
  res.render 'contact/index', {form}

exports.create = (req,res) ->
  
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('name', 'Please enter a name').notEmpty()
  req.assert('comment', 'Please enter a comment').notEmpty()
  
  req.body.type ?= 'General Enquiry'
  req.body.phone ?= ''
  req.body.state ?= ''
  req.body.contact_method ?= 'Phone'
  req.body.company ?= ''
  req.body.address ?= ''
  req.body.city ?= ''
  req.body.state ?= ''
  
  errors = req.validationErrors true
  
  if errors is false then errors = {}
  
  if Object.keys(errors)?.length > 0
    
    keys = Object.keys errors
    
    for key in keys
      req.flash 'error', errors[key].msg
    
    req.session.form = req.body
    
    res.redirect '/contact'
  
  else
    agent =
      "general enquiry": "rob@propertyowl.com.au"
      "developer enquiry": "rob@propertyowl.com.au"
      "advertising enquiry": "advertising@propertyowl.com.au"

    email = new Email
      to: "#{agent[req.body.type.toLowerCase()]}"
      from: "#{req.body.email}"
      fromname: "#{req.body.name}"
      subject: "#{req.body.type} - #{req.body.name}"
      html: """
        <html>
          <table>
            <tr>
              <td>Enquiry Type</td>
              <td>{{type}}</td>
            </tr>
            <tr>
              <td>Company</td>
              <td>{{company}}</td>
            </tr>
            <tr>
              <td>Name</td>
              <td>{{name}}</td>
            </tr>
            <tr>
              <td>Phone</td>
              <td>{{phone}}</td>
            </tr>
            <tr>
              <td>Email</td>
              <td>{{email}}</td>
            </tr>
            <tr>
              <td>Address</td>
              <td>{{address}}</td>
            </tr>
            <tr>
              <td>City</td>
              <td>{{city}}</td>
            </tr>
            <tr>
              <td>State</td>
              <td>{{state}}</td>
            </tr>
            <tr>
              <td>Preferred Contact</td>
              <td>{{contact_method}}</td>
            </tr>
            <tr>
              <td>Enquiry Comments</td>
              <td>{{comments}}</td>
            </tr>
          </table>
        </html>
      """
    
    email.setCategory 'Property Owl'
    
    email.addSubVal '{{email}}', req.body.email
    email.addSubVal '{{name}}', req.body.name
    email.addSubVal '{{comments}}', req.body.comment.toString().replace /\n/g, '<br />'
    email.addSubVal '{{type}}', req.body.type
    email.addSubVal '{{phone}}', req.body.phone
    email.addSubVal '{{state}}', req.body.state
    email.addSubVal '{{contact_method}}', req.body.contact_method
    email.addSubVal '{{company}}', req.body.company
    email.addSubVal '{{address}}', req.body.address
    email.addSubVal '{{city}}', req.body.city
    
    sendgrid.send email, ->
      
      email.to = 'swoopin@propertyowl.com.au'
      
      sendgrid.send email, ->
        
        req.flash 'success', 'message sent successfully'
        
        req.session.form = {}
        
        res.redirect '/contact'
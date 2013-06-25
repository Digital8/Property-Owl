#{Email} = require 'email'
{SendGrid, Email} = require 'sendgrid'
sendgrid = new SendGrid 'digital8', '1lovedDMDN'

exports.index = (req,res) ->
  
  res.render 'contact/index'

exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('name', 'Please enter a name').notEmpty()
  req.assert('comments', 'Please enter the comments').notEmpty()
  
  req.body.type ?= 'General Enquiry'
  req.body.phone ?= ''
  req.body.state ?= ''
  req.body.contact_method ?= 'Phone'
  req.body.company ?= ''
  req.body.address ?= ''
  req.body.city ?= ''
  req.body.state ?= ''

  #console.log req.body
  
  errors = req.validationErrors true
  
  if errors is false then errors = {}
  
  if Object.keys(errors)?.length > 0
    
    keys = Object.keys errors
    
    req.flash('error', errors[key].msg) for key in keys
    
    res.redirect '/contact'
  
  else

    ###
    Developer - rob@propertyowl.com.au
    Agent - rob@propertyowl.com.au
    Advertising - advertising@propertyowl.com.au
    ###

    agent =
      "general enquiry": "jeff@digital8.com.au"
      "developer enquiry": "jeff@digital8.com.au"
      "advertising enquiry": "jeff@digital8.com.au"

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
    email.addSubVal '{{comments}}', req.body.comments
    email.addSubVal '{{type}}', req.body.type
    email.addSubVal '{{phone}}', req.body.phone
    email.addSubVal '{{state}}', req.body.state
    email.addSubVal '{{contact_method}}', req.body.contact_method
    email.addSubVal '{{company}}', req.body.company
    email.addSubVal '{{address}}', req.body.address
    email.addSubVal '{{city}}', req.body.city
    
    sendgrid.send email, ->
      email.to = 'pyro@feisty.io'
      sendgrid.send email, ->

        req.flash 'success', 'message sent successfully'
        res.redirect '/contact'

{Email} = require 'email'

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
    
    console.log "cunt cunt cunt"

    console.log
      from: "#{req.body.email}"
      to: "#{agent[req.body.type.toLowerCase()]}"
      subject: "#{req.body.type} - #{req.body.name}"
      body: "Who's there?\n\nnewline\n\n<br /><br />rofl rofl<br /><br />lol"

    myMsg = new Email
      from: "#{req.body.email}"
      to: "#{agent[req.body.type.toLowerCase()]}"
      subject: "#{req.body.type} - #{req.body.name}"
      body: "Who's there?\n\nnewline\n\n<br /><br />rofl rofl<br /><br />lol"
    
    myMsg.send (err) ->
      
      if err
        req.flash 'error', 'an error occured'
      else
        req.flash 'success', 'message sent successfully'
      
      res.redirect '/contact'

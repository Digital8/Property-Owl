{Email} = require 'email'

exports.index = (req,res) -> res.render 'contact/index'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('name', 'Please enter a name').notEmpty()
  req.assert('comments', 'Please enter the comments').notEmpty()
  
  console.log req.body
  
  errors = req.validationErrors true
  
  if errors is false then errors = {}
  
  if Object.keys(errors)?.length > 0
    
    keys = Object.keys errors
    
    req.flash('error', errors[key].msg) for key in keys
    
    res.redirect '/contact'
  
  else
    
    myMsg = new Email
      from: 'alex@digital8.com.au'
      to:   'jeff@digital8.com.au'
      subject: 'Knock knock...'
      body: "Who's there?"
    
    myMsg.send (err) ->
      
      if err
        console.log err
        req.flash 'error', 'an error occured'
      else
        req.flash 'success', 'Contact Enquiry Sent'
      
      res.redirect '/contact'

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
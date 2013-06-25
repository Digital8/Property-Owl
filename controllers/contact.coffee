{Email} = require 'email'

exports.index = (req,res) ->
  
  res.render 'contact/index'

exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('name', 'Please enter a name').notEmpty()
  req.assert('comments', 'Please enter the comments').notEmpty()
  
  #these probably don't need to be mandatory...
  #company
  #phone
  #city
  #state


  console.log req.body
  
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
    
    myMsg = new Email
      from: 'bscarvell@gmail.com'
      to:   'bscarvell@gmail.com'
      subject: 'Knock knock...'
      body: "Who's there?"
    
    myMsg.send (err) ->
      
      if err
        req.flash 'error', 'an error occured'
      else
        req.flash 'success', 'message sent successfully'
      
      res.redirect '/contact'
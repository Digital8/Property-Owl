###
 * Contact Controller
 *
 * Renders and handles the site contact page
 *
 * @package   Digital8
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

Email = require('email').Email

exports.index = (req,res) ->
  res.render 'contact/index'
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('name', 'Please enter a name').notEmpty()
  req.assert('comments', 'Please enter the comments').notEmpty()

  console.log(req.body);
  
  errors = req.validationErrors(true)

  if errors is false then errors = {}
  if Object.keys(errors)?.length > 0
    req.flash('error', JSON.stringify(errors))
    res.redirect '/contact'
  
  else    
    myMsg = new Email
      from: "bscarvell@gmail.com"
      to:   "bscarvell@gmail.com"
      subject: "Knock knock..."
      body: "Who's there?"

    myMsg.send (err) ->
      if err
        req.flash('error','an error occured')
      else
        req.flash('success','message sent successfully')
      res.redirect '/contact'

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->
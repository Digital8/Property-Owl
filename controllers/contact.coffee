###
 * Contact Controller
 *
 * Renders and handles the site contact page
 *
 * @package   Digital8
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

exports.index = (req,res) ->
  res.render 'contact/index'
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->
  req.flash('info','Send the email yo')
  res.redirect '/contact'

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->
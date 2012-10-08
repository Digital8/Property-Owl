###
 * User class
 *
 * Creates an object of the users credentials
 *
 * @package		Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

accountLevel = require('../../system').config.acl

module.exports = class User
	constructor: (userData) ->
	  userData.admin_rights ?= ''

	  # Properties
	  @id = userData.user_id or 0
	  @alias = userData.alias or 'Guest'
	  @firstName = userData.first_name or 'Guest'
	  @lastName = userData.last_name or ''
	  @displayName = "#{@firstName} #{@lastName}"
	  @email = userData.email or ''
	  @level = userData.account_type_id or 0
	  @funds = userData.funds or 0
	  @notes = userData.admin_notes or ''
	  @rights = userData.admin_rights.split '.'
	  @avatar = if userData.photo  then "/uploads/#{userData.photo}" else 'http://placehold.it/150x150'
	
	isBuyer: ->
	  return (@level >= accountLevel.buyer) ? true : false
	
	isDeveloper: ->
	  return (@level >= accountLevel.developer) ? true : false
	
	isAdmin: ->
	  return (@level == accountLevel.admin) ? true : false
	   
	isOwner: (owner_id) ->
	  
	  if @id == owner_id
	    return true
	  else if @isAdmin()
	    return true
	  else 
	    return false
	    
	isAuthed: ->
	  if @id is 0 then return false else return true
	  
	checkRights: (right) ->
	  if @isAdmin() 
	    return true
	  else
	    if not right?
	      return @userRights.length
	    else
  	    authorized = false
  	    for priv in @rights
  	      if priv == right
  	        authorized = true
  	        break
	        
	    return authorized

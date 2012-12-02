###
 * Emailer Helper
 *
 * Helper to quickly generate and return a hash
 *
 * @package   Time for Advice
 * @author    Jeff Lynne <jeff@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

{SendGrid, Email} = require 'sendgrid'
sendgrid = new SendGrid 'digital8', '1lovedDMDN'

module.exports = (obj, category) ->
  email = new Email obj
  
  if category?
    email.setCategory category
  
  sendgrid.send email, (success, message) ->
    if success
      console.log 'email sent to', email.to
      return true
    else
      console.log message
      return false
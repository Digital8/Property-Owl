###
 * Emailer Helper
 *
 * Helper to send emails to users
 *
 * @package   Property Owl
 * @author    Jeff Lynne <jeff@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

{SendGrid, Email} = require 'sendgrid'
sendgrid = new SendGrid 'digital8', '1lovedDMDN'
fs = require 'fs'

module.exports = (template, subject, objUser, objProperty) ->

  fs.readFile "../emails/#{template}.html", 'utf-8', (err, data) ->
    if err?
      console.log 'Error:', err
      throw err
    else     
      email = new Email
        to: objUser.email
        from: 'no-reply@propertyowl.com.au'
        fromname: 'Property Owl'
        subject: subject
        html: data

      switch template
        when 'barn-deal-enquiry', 'barn-deal-registration-developer'
          email.setCategory 'Property Owl'
          email.addSubVal '{{first_name}}', objUser.firstName
          email.addSubVal '{{address}}', objProperty.address
        

      sendgrid.send email, (success, message) ->
        if success
          console.log 'email sent to', email.to
        else
          console.log message
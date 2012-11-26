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

module.exports = (template, objUser, objProperty) ->
  #the first thing we need to do is try to load the template
  fs.readFile "../emails/#{template}.html", 'utf-8', (err, data) ->
    if err?
      console.log 'Error:', err
      throw err
    else     
      email = new Email
        to: objUser.email
        from: 'mailer@timeforadvice.com.au'
        fromname: 'Time For Advice'
        subject: 'Question Updated'
        html: data

      email.setCategory 'TFA Question Updated'
      email.addSubVal '||first_name||', objUser.firstName
      email.addSubVal '||question||', objQuestion.text

      sendgrid.send email, (success, message) ->
        if success
          console.log 'email sent to', email.to
        else
          console.log message
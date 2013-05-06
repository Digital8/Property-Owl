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

module.exports = (template, subject, objUser, secondary, callback) ->

  fs.readFile __dirname + "/../../public/emails/#{template}.html", 'utf-8', (err, data) ->
    if err?
      console.log 'Error:', err
      throw err
    else

      #check for valid email address
      #minimum... a@b.cn
      return unless objUser.email.length > 5

      email = new Email
        to: objUser.email
        from: 'no-reply@propertyowl.com.au'
        fromname: 'Property Owl'
        subject: subject
        html: data
        bcc: ['swoopin@propertyowl.com.au']

      switch template
        when 'affiliate-enquiry-confirmation','affiliate-enquiry','barn-deal-enquiry','barn-deal-registration-developer','barn-deal-registration','barn-enquiry-confirmation','expression-of-interest','forgot-password','listing-approval','listing-confirmation','new-listing','news','owl-deal-enquiry','owl-deal-registration-developer','owl-deal-registration','owl-enquiry-confirmation','password-reset','property-recommendations','signup-confirmation','withdraw-interest'
          email.setCategory 'Property Owl'
          email.addSubVal '{{contact_name}}', secondary.contact_name
          email.addSubVal '{{contactName}}', secondary.contactName
          email.addSubVal '{{firstname}}', objUser.firstName
          email.addSubVal '{{lastname}}', objUser.lastName
          email.addSubVal '{{email}}', objUser.email or secondary.email
          email.addSubVal '{{address}}', secondary.address
          email.addSubVal '{{phone}}', objUser.phone
          email.addSubVal '{{title}}', secondary.title
          email.addSubVal '{{description}}', secondary.description
          email.addSubVal '{{comments}}', secondary.description
          email.addSubVal '{{code}}', secondary.code or ''
          email.addSubVal '{{barn_id}}', secondary.barn_id
          email.addSubVal '{{owl_id}}', secondary.owl_id
          email.addSubVal '{{contact_method}}', secondary.contact_method
          email.addSubVal '{{title}}', secondary.title
          email.addSubVal '{{address}}', secondary.address
          email.addSubVal '{{description}}', secondary.description
          email.addSubVal '{{link}}', secondary.link
          email.addSubVal '{{enquiry_email}}', secondary.enquiryEmail
          email.addSubVal '{{enquiryEmail}}', secondary.enquiryEmail
          email.addSubVal '{{image}}', secondary.image
          email.addSubVal '{{entity}}', secondary.entity
          email.addSubVal '{{NewsTitle}}', secondary.title
          email.addSubVal '{{NewsSummary}}', secondary.summary
          email.addSubVal '{{NewsLink}}', secondary.link

      sendgrid.send email, callback

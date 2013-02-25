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
      email = new Email
        to: objUser.email
        from: 'no-reply@propertyowl.com.au'
        fromname: 'Property Owl'
        subject: subject
        html: data
        bcc: ['swoopin@propertyowl.com.au']

      switch template
        when 'owl-enquiry-confirmation', 'affiliate-enquiry-confirmation', 'listing-approval','password-reset','forgot-password','barn-deal-enquiry', 'barn-deal-registration-developer', 'barn-deal-registration', 'expression-of-interest', 'withdraw-interest', 'signup-confirmation', 'service-enquiry', 'service-enquiry-confirmation', 'property-recommendations', 'property-enquiry-confirmation', 'owl-deal-registration-developer', 'owl-deal-registration','owl-deal-enquiry', 'barn-deal-enquiry', 'new-listing', 'listing-confirmation'
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
        when 'news'
          email.addSubVal '{{NewsTitle}}', secondary.title
          email.addSubVal '{{NewsSummary}}', secondary.summary
          email.addSubVal '{{NewsLink}}', secondary.link
		  
      sendgrid.send email, callback
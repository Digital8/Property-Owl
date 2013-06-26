fs = require 'fs'

{SendGrid, Email} = require 'sendgrid'

sendgrid = new SendGrid 'digital8', '1lovedDMDN'

module.exports = (template, subject, user, secondary, callback = ->) ->
  
  fs.readFile "#{__dirname}/../public/emails/#{template}.html", 'utf8', (error, html) ->
    
    return callback error if error?
    
    #check for valid email address
    #minimum... a@b.cn
    return unless user.email.length > 5
    
    email = new Email
      to: user.email
      from: 'no-reply@propertyowl.com.au'
      fromname: 'Property Owl'
      subject: subject
      html: html
      #bcc: ['swoopin@propertyowl.com.au']
    
    email.setCategory 'Property Owl'
    
    email.addSubVal '{{address}}', secondary.address
    email.addSubVal '{{barn_id}}', secondary.barn_id
    email.addSubVal '{{code}}', secondary.code or ''
    email.addSubVal '{{comments}}', secondary.description
    email.addSubVal '{{comment}}', secondary.comment
    email.addSubVal '{{contact_method}}', secondary.contact_method
    email.addSubVal '{{contact_name}}', secondary.contact_name
    email.addSubVal '{{contactName}}', secondary.contactName
    email.addSubVal '{{description}}', secondary.description
    email.addSubVal '{{email}}', user.email or secondary.email
    email.addSubVal '{{enquiry_email}}', secondary.enquiryEmail
    email.addSubVal '{{enquiryEmail}}', secondary.enquiryEmail
    email.addSubVal '{{entity_id}}', secondary.entity_id
    email.addSubVal '{{entity_type}}', secondary.entity_type
    email.addSubVal '{{entity}}', secondary.entity
    email.addSubVal '{{firstname}}', user.first_name
    email.addSubVal '{{friend_name}}', secondary.first_name
    email.addSubVal '{{image}}', secondary.image
    email.addSubVal '{{lastname}}', user.last_name
    email.addSubVal '{{link}}', secondary.link
    email.addSubVal '{{NewsLink}}', secondary.link
    email.addSubVal '{{NewsSummary}}', secondary.summary
    email.addSubVal '{{NewsTitle}}', secondary.title
    email.addSubVal '{{owl_id}}', secondary.owl_id
    email.addSubVal '{{phone}}', user.phone
    email.addSubVal '{{subject}}', subject
    email.addSubVal '{{title}}', secondary.title
    
    email.addSubVal '{{name}}', secondary.name
    email.addSubVal '{{dear}}', user.dear or user.first_name
    email.addSubVal '{{token}}', secondary.token
    for key in ['email', 'phone', 'first_name', 'last_name', 'address']
      email.addSubVal "{{secondary_#{key}}}", secondary[key]
    
    sendgrid.send email, ->
      email.to = 'swoopin@propertyowl.com.au'
      sendgrid.send email, callback

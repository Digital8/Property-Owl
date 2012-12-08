{SendGrid, Email} = require 'sendgrid'

sendgrid = new SendGrid 'digital8', '1lovedDMDN'

module.exports = (template, data, callback) ->
  
  data =
    deal: {barn | owl} .id, .title/.name
    user: {} .id, .firstname,
    friend:
    comments: '' 
   
  email = new Email
    to: objUser.email
    from: 'no-reply@propertyowl.com.au'
    fromname: 'Property Owl'
    subject: subject
    html: template

  email.setCategory 'Property Owl'

  email.addSubVal '{{first_name}}', objUser.firstName
  email.addSubVal '{{last_name}}', objUser.lastName
  email.addSubVal '{{email}}', objUser.email
  email.addSubVal '{{phone}}', objUser.phone

  email.addSubVal '{{address}}', secondary.address
  email.addSubVal '{{title}}', secondary.title
  email.addSubVal '{{description}}', secondary.description

  # sendgrid.send email, callback
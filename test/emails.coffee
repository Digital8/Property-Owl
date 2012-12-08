mailer = require '../lib/mailer'

fs = require 'fs'
path = require 'path'

fs.readdir "#{__dirname}/../public/emails", (error, files) ->
  
  for file in files
    # console.log arguments
  
    if (path.extname file) is '.html'
      console.log file
      
      # console.log "#{__dirname}/../public/emails/#{file}"
      
      template = fs.readFileSync "#{__dirname}/../public/emails/#{file}", 'utf8'
      console.log template
      
      # {SendGrid, Email} = require 'sendgrid'
      # sendgrid = new SendGrid 'digital8', '1lovedDMDN'
      # email = new Email
      
      mailer template, 

# mailer template, 
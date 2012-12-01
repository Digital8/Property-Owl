mail = require './lib/helpers/mailer'

template = 'barn-deal-enquiry'

user =
  firstName: 'Test'
  lastName: 'User'
  email: 'brendan@digital8.com.au'
  phone: '1800 123 456'

secondary =
  address: '123 WTF Street'
  title: 'Fuck shit'


mail template,'test subject',user,secondary, (err, msg) ->
  console.log "Error: #{err}"
  console.log "Msg: #{msg}"
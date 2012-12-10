mail = require './lib/helpers/mailer'

template = 'signup-confirmation'

user =
  firstName: 'Test'
  lastName: 'User'
  email: 'brendan@digital8.com.au'
  phone: '1800 123 456'

secondary =
  contact_name: 'Developer'
  address: '123 WTF Street'
  title: 'Fuck shit'
  barn_id: ''
  contact_method: 'phone'
  comments: 'here is a comment'


mail template,'', user, secondary, (results) ->
  console.log results
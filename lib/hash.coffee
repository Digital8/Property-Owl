crypto = require 'crypto'

module.exports = hash = (msg) ->
  
  crypto.createHmac('sha256', 'TimeForAdviceSalt').update(msg).digest('hex')

unless module.parent?
  
  console.log hash process.argv[2]
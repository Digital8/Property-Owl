crypto = require 'crypto'

module.exports = (msg) ->
  crypto.createHmac('sha256', 'TimeForAdviceSalt').update(msg).digest('hex')
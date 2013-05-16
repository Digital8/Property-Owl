###
 * Hash Helper
 *
 * Helper to quickly generate and return a hash
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
crypto = require 'crypto'

#console.log 'hash for password', crypto.createHmac('sha256', 'TimeForAdviceSalt').update('password').digest('hex')

module.exports = (msg) ->
  crypto.createHmac('sha256', 'TimeForAdviceSalt').update(msg).digest('hex')

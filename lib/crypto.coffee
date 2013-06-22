crypto = require 'crypto'

concat = require 'concat-stream'

module.exports = {}

KEY = 'TimeForAdviceSalt'
ALGORITHM = 'aes256'
ENCODING = 'hex'

module.exports.encrypt = encrypt = (plaintext, args..., callback) ->
  
  args = (args or [{}])[0] or {}
  
  cipher = crypto.createCipher (args.algorithm or ALGORITHM), (args.key or KEY)
  cipher.pipe concat (buffer) ->
    callback null, buffer.toString (args.encoding or ENCODING)
  
  cipher.end plaintext

module.exports.decrypt = decrypt = (ciphertext, args..., callback) ->
  
  args = (args or [{}])[0] or {}
  
  cipher = crypto.createDecipher (args.algorithm or ALGORITHM), (args.key or KEY)
  cipher.pipe concat (buffer) ->
    callback null, buffer.toString()
  
  cipher.end ciphertext, (args.encoding or ENCODING)

unless module.parent?
  
  input = JSON.parse process.argv[2]
  json = JSON.stringify input
  
  console.log {input, json}
  
  encrypt json, (error, ciphertext) ->
    
    console.log ciphertext
    
    decrypt ciphertext, (error, plaintext) ->
      console.log plaintext
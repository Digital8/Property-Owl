knox = require 'knox'

module.exports = s3 = (config) ->
  
  {key, secret, bucket} = config
  
  client = knox.createClient config
  
  return client

unless module.parent?
  
  client = s3 (require '../config').s3
  
  console.log client
  
  put = (object, callback) ->
    
    string = JSON.stringify object
    
    req = client.put "/test",
      "Content-Length": string.length
      "Content-Type": "application/json"
    
    req.on "response", (res) ->
      
      console.log res
      
      console.log "saved to %s", req.url  if 200 is res.statusCode
      
      callback()
    
    req.end string
  
  put foo: "bar", ->
    
    client.list (error, data) ->
      
      console.log arguments...
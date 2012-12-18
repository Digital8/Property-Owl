###
 * File Uploader
 *
 * Allows uploading of files to a specified directory
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
fs = require 'fs'
uuid = require 'node-uuid'

class fileUploader
  
  constructor: ->
    @uploadPath = __dirname + '/'
    
    # Set an error function to handle errors.
    # This can be customized by passing your own error handler by calling onError
    @error = (err) ->
      console.log err
      if err then throw err
      
  
  onError: (func) ->
    @error = func

  upload: (tmpPath, callback) -> 
    fs.readFile tmpPath, (err, data) ->
      if err then @error err

      # Generate a uuid name for the file
      newFileName = uuid.v1() + '.' + tmpPath.split(/[\. ]+/).pop();
      newPath = @uploadPath + newFileName

      # Write the contents to its upload path
      fs.writeFile newPath, data, (err) ->
        if err
          @error err
        else
          callback err, newFileName
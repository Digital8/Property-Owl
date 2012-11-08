###
 * File Uploader
 *
 * Allows uploading of files to a specified directory
 *
 * @package   Digital8
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
fs = require 'fs'
uuid = require 'node-uuid'

module.exports = class fileUploader
  
  # `Options` (Object) :
  #   `uploadDir` (String) : Directory path to store uploaded file
  
  constructor: (options) ->
    if not options? then options = {}
    @uploadPath = options.uploadDir or __dirname + '/'
    console.log @uploadPath

  upload: (fInfo, callback) -> 
    uploadPath = @uploadPath
    
    # Read the file from the fInfo
    fs.readFile fInfo.path, (err, data) ->
      if err 
        callback(err, results)
      else
        # Generate a uuid name for the file
        newFileName = uuid.v1() + '.' + fInfo.filename.split(/[\. ]+/).pop();
        newPath = uploadPath + newFileName
      
        # Check that the new directory exists
        fs.exists uploadPath, (exists) ->
          if not exists
            callback 'Upload directory doesn\'t exist', null
          else      
            # Write the contents to its upload path
            fs.writeFile newPath, data, (err) ->
              if err
                callback(err, null)
              else
                callback null, {status: 200, filename: newFileName}
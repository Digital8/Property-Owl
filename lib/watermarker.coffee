fs = require 'fs'

{Image} = Canvas = require 'canvas'

module.exports = (path, watermarkPath = "#{__dirname}/../public/images/watermark.png") ->
  watermarkImage = new Image
  
  watermarkImage.onload = ->
    image = new Image
    
    image.onload = ->
      canvas = new Canvas image.width, image.height
      
      ctx = canvas.getContext '2d'
      
      ctx.drawImage image, 0, 0, image.width, image.height
      
      ctx.globalAlpha = 0.5
      
      ctx.drawImage watermarkImage, image.width - watermarkImage.width, image.height - watermarkImage.height, watermarkImage.width, watermarkImage.height
      
      canvas.toBuffer (error, buffer) ->
        fs.writeFile "#{__dirname}/test.png", buffer, ->
          console.log 'done'
    
    image.src = path
  
  watermarkImage.src = watermarkPath
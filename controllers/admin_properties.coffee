###
 * Admin Pages Controller
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  users: system.load.model('user')
  properties: system.load.model('properties')
  media: system.load.model('media')
  deals: system.load.model('deals')

classes =
  uploader: system.load.class('uploader')

helpers = {}
 
exports.index = (req,res) ->
  
exports.view = (req,res) ->

## GET ##  
exports.add = (req,res) ->
  # debug part
  # req.session.newPropertyId = 9
  
  models.properties.getPropertyTypes (err, property_types) ->
    models.users.getUsersByGroup 2, (err, developers) ->
      if err then throw err
      
      if req.query.step? and req.session.newPropertyId?        
        switch req.query.step
          when '1'
            # delete req.session.newPropertyId
            res.render 'administration/properties/details', developers: developers, property_types: property_types
          when '2'
            models.media.getMediaByPropertyId req.session.newPropertyId, (err, files) ->
              if err then throw err
              res.render 'administration/properties/features', files: files or {}
          when '3'
            models.deals.getDealsByPropertyId req.session.newPropertyId, (err, deals) ->
              res.render 'administration/properties/deals', deals: deals or {}
          when '4'
            models.media.getImagesByPropertyId req.session.newPropertyId, (err, files) ->
              if err then throw err
              res.render 'administration/properties/images', images: files or {}
          when 'finish'
            res.render 'administration/properties/finished'
          else
            res.render 'administration/properties/details', developers: developers, property_types: property_types
      else
        res.render 'administration/properties/details', developers: developers, property_types: property_types

## POST ##
exports.create = (req,res) ->
  if req.query.step?
    switch req.query.step
      when '1'
        models.properties.addProperty req.body, (err, results) ->
          if err then throw err
          req.session.newPropertyId results.insertId
          res.redirect "/administration/properties/add?step=2"
      when '2'
        if req.body.cmdUpload?
          uploader = new classes.uploader(uploadDir: __dirname + '/../public/uploads/')            
          uploader.upload req.files.file, (err, results) ->
            if err then throw err
            
            if results.status is 200
              
              # add the media into the database
              mediaInfo = 
                property_id: req.session.newPropertyId
                owner_id: res.locals.objUser.id
                filename: results.filename
                description: req.body.filename
                image: '0'
                  
              models.media.addMedia mediaInfo, (err, results) ->
                req.flash('success','File uploaded successfully!')
                res.redirect "/administration/properties/add?step=2"
            else
              req.flash('error','A system error occured processing the upload :(')
              res.redirect "/administration/properties/add?step=2"
        else
          models.properties.updateProperty req.body, (err, results) ->
            res.redirect "/administration/properties/add?step=3"
            
      # Step 3
      when '3'
        if req.body.cmdNext?
          res.redirect '/administration/properties/add?step=4'
        else
          req.body.property_id = req.session.newPropertyId
          req.body.created_by = res.locals.objUser.id
        
          models.deals.addDeal req.body, (err, results) ->
            if err then throw err
            res.redirect '/administration/properties/add?step=3'
      # Step 4
      when '4'
        uploader = new classes.uploader(uploadDir: __dirname + '/../public/uploads/')     
        if req.files.file.name is ''
          req.flash('error','No file speicified to upload')
          res.redirect '/administration/properties/add?step=4'
        else            
          uploader.upload req.files.file, (err, results) ->
            if err 
              req.flash('error', err)
              res.redirect 'back'
        
            if results.status is 200
          
              # add the media into the database
              mediaInfo = 
                property_id: req.session.newPropertyId
                owner_id: res.locals.objUser.id
                filename: results.filename
                description: ''
                image: '1'
              
              models.media.addMedia mediaInfo, (err, results) ->
                if err then throw err
                req.flash('success','File uploaded successfully!')
                res.redirect "/administration/properties/add?step=4"
            else
              req.flash('error','A system error occured processing the upload :(')
              res.redirect '/administration/properties/add?step=4'
              
      else
        res.send 'an error occured'
  else
    res.render 'administration/properties/details'
  
exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->
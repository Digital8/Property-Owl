exports.destroy = (require '../behaviors/destroy') Registration

exports.create = (req, res, next) ->
  
  req.assert('comment', 'missing').notNull()
  req.assert('comment', 'empty').notEmpty()
  
  req.assert('phone', 'missing').notNull()
  req.assert('phone', 'empty').notEmpty()
  req.assert('phone', 'invalid').is /^[\+0-9][ 0-9]*[0-9]$/
  req.assert('phone', 'too short').len 8
  req.assert('phone', 'too long').len null, 16
  
  return if req.guard arguments...
  
  {entity, user} = req
  
  # use the barn if there is one
  entity = entity.barn if entity.barn?
  
  entity.hydrate (error) ->
    
    Registration.registered {entity, user}, (error, registered) ->
      
      return next error if error?
      
      return next message: 'Already registered', status: 409 if registered
      
      Registration.create
        user_id: user.id
        entity_id: entity.id
        entity_type: entity.constructor.name.toLowerCase()
        comment: req.param 'comment'
        phone: req.param 'phone'
      , (error, registration) ->
        
        return next error if error?
        
        res.send id: registration.id
        
        link = "/#{entity.constructor.table.name}/#{entity.id}"
        
        # email
        secondary =
          link: link
          title: entity.title
          address: entity.address
          description: entity.description
          image: if entity.feature_image then "uploads/#{entity.feature_image}" else 'images/placeholder.png'
          entity_type: entity.constructor.name.toLowerCase()
        
        subject = "#{entity.constructor.name} Deal Registration"
        
        (require '../lib/mailer') [
          'registration'
          subject
          user
          secondary
        ]..., (error) ->
          
          entity.user ?= name: 'Subscriber'
          
          primary =
            first_name: user.first_name
            first_name: user.last_name
            email: entity.user.email
            phone: registration.phone
          
          secondary =
            entity_id: entity.id
            entity_type: entity.constructor.name.toLowerCase()
            contactName: entity.user.first_name
            address: entity.address
            title: entity.title
            comment: registration.comment
            enquiryEmail: user.email
            link: link
          
          (require '../lib/mailer') [
            'registration-developer'
            subject
            primary
            secondary
          ]..., (error) ->
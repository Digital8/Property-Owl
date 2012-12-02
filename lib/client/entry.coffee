faker = require 'Faker'
moment = require 'moment'
_ = require 'underscore'

$ ->
  forms = ($ '.details-form')
  
  for form in forms
    $button = $ '<button>fake</button>'
    
    $button.click (event) ->
      event.preventDefault()
      
      fields = ($ form).find 'input, textarea, select'
      
      map =
        'title': -> faker.Company.catchPhrase()
        'description': -> faker.Lorem.paragraphs()
        'address': -> faker.Address.streetAddress()
        'suburb': -> faker.Address.city()
        'postcode': -> faker.Helpers.replaceSymbolWithNumber '####'
      
      for field in fields
        field = $ field
        
        name = field.attr 'name'
        type = field.attr 'type'
        
        continue if type is 'submit'
        
        if field.is 'select'
          $options = field.find 'option'
          random = ~~(Math.random() * $options.length)
          random = Math.max 1, random # skip the first option
          $options.eq(random).prop 'selected', true
        
        else
          value = ''
          
          if map[name]
            value = do map[name]
          
          console.log "setting #{name} to #{value}"
          
          field.val value
    
    $button.prependTo form

$ ->
  geoURL = (q, sensor = no) ->
    "http://maps.googleapis.com/maps/api/geocode/json?address=#{q}&sensor=#{sensor}"
  
  for geo in ($ '[data-geo]')
    $geo = $ geo
    
    $geo.keydown (event) ->
      query = $geo.val()
      
      url = geoURL query
      
      $.get url, () -> console.log arguments
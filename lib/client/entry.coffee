faker = require 'Faker'
moment = require 'moment'

$ ->
  forms = ($ '.details-form')
  
  for form in forms
    button = $ '<button>fake</button>'
    button.click (event) ->
      event.preventDefault()
      
      console.log 'cicks'
      
      fields = ($ form).find 'input'
      
      map =
        'title': -> faker.Lorem.sentence()
        'description': -> faker.Lorem.paragraphs()
        'title': -> faker.Lorem.sentence()
        'title': -> faker.Lorem.sentence()
      
      for field in fields
        field = $ field
        
        name = field.attr 'name'
        type = field.attr 'type'
        
        continue if type is 'submit'
        
        value = ''
        
        if map[name]
          value = do map[name]
        
        field.val value
    
    button.prependTo form
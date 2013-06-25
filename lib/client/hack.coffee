module.exports = ->
  
  return unless window['1fe957f4-f2d5-4714-a262-556b8de13dd2']?
  
  forms = ($ '.fake')
  
  for form in forms
    $button = $ '<button>fake</button>'
    $button.css 'opacity', 0.05
    
    $button.click (event) ->
      event.preventDefault()
      
      fields = ($ form).find 'input, textarea, select'
      
      map =
        'title': -> faker.Company.catchPhrase()
        'description': -> faker.Lorem.paragraphs()
        'address': -> faker.Address.streetAddress()
        'suburb': -> faker.Address.city()
        'postcode': -> faker.Helpers.replaceSymbolWithNumber '####'
        'fname': -> faker.Name.firstName()
        'lname': -> faker.Name.lastName()
        'email': -> faker.Internet.email()
        'phone': -> faker.Helpers.replaceSymbolWithNumber '(##) #### ####'
        'workPhone': -> faker.Helpers.replaceSymbolWithNumber '(##) #### ####'
        'mobile': -> faker.Helpers.replaceSymbolWithNumber '#### ### ###'
        'company': -> faker.Company.companyName()
        'password': -> 'password'
        'confirmPassword': -> 'password'
      
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
        
        else if (field.is 'input') and (field.attr 'type') is 'number'
          min = if (field.attr 'min')? then (field.attr 'min') else 0
          max = if (field.attr 'max')? then (field.attr 'max') else 5
          
          field.val _.random min, max
        
        else
          value = ''
          
          if map[name]
            value = do map[name]
          
          field.val value
    
    $button.prependTo form
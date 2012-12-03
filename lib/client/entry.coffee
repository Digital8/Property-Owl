faker = require 'Faker'
moment = require 'moment'
_ = require 'underscore'
window.commas = commas = require '../helpers/commas'

$ ->

  $('body').on 'keypress', (event) ->
    if (event.keyCode == 6) and event.ctrlKey
      console.log 'fake that shit'

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
          
          console.log "setting #{name} to #{value}"
          
          field.val value
    
    $button.prependTo form

$ ->
  for geo in ($ '[data-geo]')
    $geo = $ geo
    
    $input = $geo.find 'input'
    
    form = $geo.parent()
    
    ul = $ '<ul>'
    ul.appendTo $geo
    
    throttled = _.debounce (event) ->
      query = $input.val()
      
      $.post '/geocode', query: query, ({results, status}) ->
        ul.empty()
        
        return unless results?.length
        
        for result in results then do (result) ->
          console.log result
          li = $ '<li>'
          li.appendTo ul
          
          a = $ '<a>'
          a.attr 'href', '#'
          a.appendTo li
          
          img = $ '<img>'
          img.attr 'src', "http://maps.googleapis.com/maps/api/staticmap?sensor=false&center=#{result.formatted_address}&zoom=13&size=48x32"
          img.appendTo a
          
          span = $ '<span>'
          span.text result.formatted_address
          span.appendTo a
          
          a.click (event) ->
            event.preventDefault()
            
            ($ '#address').val null
            ($ '#suburb').val null
            ($ '#postcode').val null
            ($ '#state')[0].selectedIndex = 0
            
            for component in result.address_components
              if 'street_number' in component.types
                ($ '#address').val ($ '#address').val() + component.long_name
              
              if 'route' in component.types
                ($ '#address').val ($ '#address').val() + ' ' + component.long_name
              
              if 'locality' in component.types
                ($ '#suburb').val component.long_name
              
              if 'postal_code' in component.types
                ($ '#postcode').val component.long_name
              
              if 'administrative_area_level_1' in component.types
                ($ '#state').val component.short_name.toLowerCase()
        
      , 'json'
    , 1000
    
    $input.bind 'change', ->
      ul.empty()
      
      throttled arguments...
faker = require 'Faker'
moment = require 'moment'
_ = require 'underscore'
window.commas = commas = require './commas'

$ ->
  (require './shim') $
  
  do require './login'
  
  do require './admin'
  
  do require './media'
  
  do require './news'
  
  do require './files'
  
  do require './affiliates'
  
  do require './categories'
  
  do require './advertisers'
  do require './advertisements'
  
  do require './live'
  
  do require './bookmarks'
  
  do require './barns'
  
  do require './owls'
  
  do require './pages'
  
  do require './google_maps'
  
  do require './enquiries'

  do require './registration'
  
  do require './referral'
  
  do require './map'
  
  do require './timer'
  
  do require './modals'
  
  do require './user'

  do require './hack'

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
            
            ($ '.inputs .address').val null
            ($ '.inputs .suburb').val null
            ($ '.inputs .postcode').val null
            ($ '.inputs .state').selectedIndex = 0
            
            for component in result.address_components
              if 'street_number' in component.types
                ($ '.inputs .address').val ($ '.inputs .address').val() + component.long_name
              
              if 'route' in component.types
                ($ '.inputs .address').val ($ '.inputs .address').val() + ' ' + component.long_name
              
              if 'locality' in component.types
                ($ '.inputs .suburb').val component.long_name
              
              if 'postal_code' in component.types
                ($ '.inputs .postcode').val component.long_name
              
              if 'administrative_area_level_1' in component.types
                ($ '.inputs .state').val component.short_name.toLowerCase()

            address = ($ '.inputs .address').val()
            suburb = ($ '.inputs .suburb').val()
            
            if address.length > 1 and suburb.length > 1
              $('.inputs .address').change()
        
      , 'json'
    , 1000
    
    $input.bind 'change', ->
      return if ul.length
      throttled arguments...

    $input.bind 'keyup', ->
      throttled arguments...

$ ->
  ($ 'textarea').autosize()

module.exports = ->
  
  for mapElement in $ '.map'
    
    options =
      zoom: 15
      disableDefaultUI: true
      mapTypeId: google.maps.MapTypeId.ROADMAP
    
    map = new google.maps.Map mapElement, options
    
    $map = $ mapElement
    
    address = $map.data 'address'
    
    geocoder = new google.maps.Geocoder
    
    geocoder.geocode address: address, (results, status) ->
      return if status is 'ERROR'
      return unless results.length
      
      map.setCenter results[0].geometry.location
      
      marker = new google.maps.Marker
        position: results[0].geometry.location
        map: map
        title: address

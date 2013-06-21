module.exports = (form) ->
  
  map = {}
  for input in ($ form).serializeArray()
    map[input.name] = input.value
  
  return map
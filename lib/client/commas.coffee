module.exports = (nStr) ->
  nStr += ''
  x = nStr.split '.'
  x1 = x[0]
  if x.length > 1 then x2 = ".#{x[1]}" else x2 = ''

  rgx = /(\d+)(\d{3})/
  
  while rgx.test(x1)
    x1 = x1.replace rgx, '$1' + ',' + '$2'
  
  x1 + x2
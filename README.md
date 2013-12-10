# Property Owl

## Servers

### Production

http: http://propertyowl.com.au:1337

https: https://propertyowl.com.au

NODE_ENV=production sudo supervisor --ignore . -- server.coffee

### Staging

http: http://propertyowl.com.au:10080

https: https://propertyowl.com.au:10443

## Testing

### Times

#### Spoof a time

sudo supervisor -- server.coffee --hack --verbose --time '2013-01-01T15:24:39+10:00'

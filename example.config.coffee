module.exports =
  globals:
    site:
      name: 'Property Owl'
  
  database:
    type: 'mysql'
    host: 'localhost'
    user: 'root'
    password: ''
    name: 'po'
    prefix: 'po_'
  
  modules:
    login: on
    register: on
  
  acl:
    buyer: 1
    developer: 2
    admin: 3
  
  http:
    port: 80
  
  https:
    port: 443
  
  ssl:
    key: './ssl/localhost.key'
    cert: './ssl/localhost.crt'
    passphrase: ''
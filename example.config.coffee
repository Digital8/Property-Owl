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
  
  hack:
    user:
      id: 1
  
  bucket: "#{__dirname}/public/uploads"
  
  fs:
    root: "#{__dirname}/public/uploads"
  
  s3:
    key: null
    secret: null
    region: null
    bucket: null
  
  mimes:
    application: [
      'javascript'
      'json'
      'pdf'
      'x-shockwave-flash'
      'xml'
      'zip'
    ]
    image: [
      'bmp'
      'gif'
      'jpeg'
      'png'
      'svg+xml'
      'tiff'
      'webp'
    ]
    video: [
      'h261'
      'h263'
      'h264'
      'mp4'
      'mpeg'
      'ogg'
      'quicktime'
      'x-flv'
      'x-m4v'
      'x-matroska'
      'x-ms-wmv'
      'x-msvideo'
    ]
    text: [
      'css'
      'csv'
      'html'
      'plain'
      'xml'
    ]
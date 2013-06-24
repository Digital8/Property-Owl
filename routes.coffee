{acl} = config = require './config'

authenticate = require './lib/authenticate'
authorize = require './lib/authorize'

set = (map) ->
  (req, res, next) ->
    req[key] = value for key, value of map
    next? null

module.exports = ({app, controllers}) ->
  
  app.get '/', controllers.index.index
  
  app.get '/tokens/:uuid', controllers.tokens.uuid
  
  # advertisements
  app.get '/advertisements/:id(\\d+)/click', controllers.advertisements.click
  
  # epoch
  app.get '/epoch', controllers.epoch
  
  # recovery
  app.get  '/recoveries', controllers.recoveries.index
  app.get  '/recoveries/:id', controllers.recoveries.show
  app.post '/recoveries', controllers.recoveries.create
  
  # auth
  app.get '/login',   controllers.login.index
  app.get '/logout',  controllers.misc.logout
  app.get '/signup',  controllers.signup.add
  app.post '/signup', controllers.signup.create
  
  # preferences - my account
  app.get '/preferences', authenticate, controllers.account.preferences
  app.post '/preferences', authenticate, controllers.account.updatePreferences
  
  # registrations - my account
  app.get '/registrations', authenticate, controllers.account.registrations
  
  # referrals - my account
  app.get '/referrals', authenticate, controllers.account.referrals
  
  ### contact ###
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  # account - my account
  app.get '/account', authenticate, controllers.account.index
  app.put '/account', authenticate, controllers.account.update
  
  ### enquiries ###
  app.post '/enquiries', controllers.enquiries.create
  
  ### registrations ###
  app.post '/registrations', authenticate, controllers.registrations.create
  app.del '/registrations/:id(\\d+)', authenticate, controllers.registrations.destroy
  
  ### referrals ###
  app.post '/referrals', authenticate, controllers.referrals.create
  # app.del '/referrals/:id(\\d+)', authenticate, controllers.referrals.destroy
  
  ### categories ###
  app.post  '/categories',           authenticate, controllers.categories.create
  app.get   '/categories/add',       authenticate, controllers.categories.add
  app.patch '/categories/:id(\\d+)', authenticate, controllers.categories.update
  app.del   '/categories/:id(\\d+)', authenticate, controllers.categories.destroy
  
  app.del '/medias/:id(\\d+)', authenticate, controllers.medias.destroy
  
  app.get  '/bookmarks',           authenticate, controllers.bookmarks.index
  app.post '/bookmarks',           authenticate, controllers.bookmarks.create
  app.del  '/bookmarks/:id(\\d+)', authenticate, controllers.bookmarks.destroy
  
  # affiliates
  app.get '/products-and-services', controllers.affiliates.browse
  
  # app.get '/owls',                 controllers.owls.index
  app.get '/owls/:id(\\d+)/print', controllers.owls.print
  app.get '/owls/:id(\\d+)',       controllers.owls.show
  app.get '/owls/top',             controllers.owls.top
  app.get '/owls/hot',             controllers.owls.hot
  app.get '/owls/locate',          controllers.owls.locate
  app.get '/owls/state/:state',    controllers.owls.byState
  
  app.get '/barns/browse',          controllers.barns.browse
  app.get '/barns/:id(\\d+)/print', controllers.barns.print
  app.get '/barns/:id(\\d+)',       controllers.barns.show
  app.get '/barns/:id(\\d+)/owls',  controllers.barns.owls
  
  for key in ['news', 'research'] then do (key) ->
    app.get "/#{key}", (set type: key), controllers.posts.type
    app.get "/#{key}/:id(\\d+)", authenticate, (set type: key), controllers.posts.view
  
  app.get 'search', controllers.search.index
  
  # advertisers
  app.del  '/advertisers/:id(\\d+)',        (authorize acl.admin), controllers.advertisers.destroy
  app.get  '/advertisers',                  (authorize acl.admin), controllers.advertisers.index
  app.get  '/advertisers/:id(\\d+)/delete', (authorize acl.admin), controllers.advertisers.delete
  app.get  '/advertisers/:id(\\d+)/edit',   (authorize acl.admin), controllers.advertisers.edit
  app.get  '/advertisers/add',              (authorize acl.admin), controllers.advertisers.add
  app.post '/advertisers',                  (authorize acl.admin), controllers.advertisers.create
  app.put  '/advertisers/:id(\\d+)',        (authorize acl.admin), controllers.advertisers.update
  
  # advertisements
  app.del  '/advertisements/:id(\\d+)',        (authorize acl.admin), controllers.advertisements.destroy
  app.get  '/advertisements',                  (authorize acl.admin), controllers.advertisements.index
  app.get  '/advertisements/:id(\\d+)/delete', (authorize acl.admin), controllers.advertisements.delete
  app.get  '/advertisements/:id(\\d+)/edit',   (authorize acl.admin), controllers.advertisements.edit
  app.get  '/advertisements/add',              (authorize acl.admin), controllers.advertisements.add
  app.post '/advertisements',                  (authorize acl.admin), controllers.advertisements.create
  app.put  '/advertisements/:id(\\d+)',        (authorize acl.admin), controllers.advertisements.update
  
  app.get '/admin', (authorize acl.developer), controllers.admin.index
  
  # affiliates
  app.del  '/affiliates/:id(\\d+)',        (authorize acl.admin), controllers.affiliates.destroy
  app.get  '/affiliates',                  (authorize acl.admin), controllers.affiliates.index
  app.get  '/affiliates/:id(\\d+)/delete', (authorize acl.admin), controllers.affiliates.delete
  app.get  '/affiliates/:id(\\d+)/edit',   (authorize acl.admin), controllers.affiliates.edit
  app.get  '/affiliates/add',              (authorize acl.admin), controllers.affiliates.add
  app.post '/affiliates/add',              (authorize acl.admin), controllers.affiliates.create
  app.put  '/affiliates/:id(\\d+)',        (authorize acl.admin), controllers.affiliates.update
  
  # admin/posts
  app.delete '/posts/:id(\\d+)',        (authorize acl.admin), controllers.posts.destroy
  app.get    '/posts',                  (authorize acl.admin), controllers.posts.index
  app.get    '/posts/:id(\\d+)/delete', (authorize acl.admin), controllers.posts.delete
  app.get    '/posts/:id(\\d+)/edit',   (authorize acl.admin), controllers.posts.edit
  app.get    '/posts/add',              (authorize acl.admin), controllers.posts.add
  app.post   '/posts',                  (authorize acl.admin), controllers.posts.create
  app.put    '/posts/:id(\\d+)',        (authorize acl.admin), controllers.posts.update
  
  # admin/members
  app.del  '/users/:id(\\d+)',        (authorize acl.admin), controllers.users.destroy
  app.get  '/users',                  (authorize acl.admin), controllers.users.index
  app.get  '/users/:id(\\d+)/delete', (authorize acl.admin), controllers.users.delete
  app.get  '/users/:id(\\d+)/edit',   (authorize acl.admin), controllers.users.edit
  app.get  '/users/add',              (authorize acl.admin), controllers.users.add
  app.post '/users',                  (authorize acl.admin), controllers.users.create
  app.put  '/users/:id(\\d+)',        (authorize acl.admin), controllers.users.update
  
  # pages
  app.del  '/pages/:id(\\d+)',        (authorize acl.admin), controllers.pages.destroy
  app.get  '/pages',                  (authorize acl.admin), controllers.pages.index
  app.get  '/pages/:id(\\d+)/delete', (authorize acl.admin), controllers.pages.delete
  app.get  '/pages/:id(\\d+)/edit',   (authorize acl.admin), controllers.pages.edit
  app.get  '/pages/add',              (authorize acl.admin), controllers.pages.add
  app.post '/pages',                  (authorize acl.admin), controllers.pages.create
  app.put  '/pages/:id(\\d+)',        (authorize acl.admin), controllers.pages.update
  
  # files
  app.get   '/files',           (authorize acl.admin), controllers.files.index
  app.post  '/files',           (authorize acl.admin), controllers.files.create
  app.del   '/files/:id(\\d+)', (authorize acl.admin), controllers.files.destroy
  
  for key in ['owls', 'barns']
    app.del   "/#{key}/:id(\\d+)",        (authorize acl.developer), controllers[key].destroy
    app.get   "/#{key}",                  (authorize acl.developer), controllers[key].index
    app.get   "/#{key}/:id(\\d+)",        (authorize acl.developer), controllers[key].show
    app.get   "/#{key}/:id(\\d+)/edit",   (authorize acl.developer), controllers[key].edit
    app.get   "/#{key}/add",              (authorize acl.developer), controllers[key].add
    app.patch "/#{key}/:id(\\d+)",        (authorize acl.developer), controllers[key].patch
    app.post  "/#{key}", (authorize 2),   (authorize acl.developer), controllers[key].create
    app.put   "/#{key}/:id(\\d+)",        (authorize acl.developer), controllers[key].update
  
  # app.post '/owls/:id(\\d+)/clone', (authorize acl.admin), controllers.owls.clone
  
  entity = (model) ->
    (req, res, next) ->
      model.get req.params["#{model.name.toLowerCase()}_id"], (error, entity) ->
        return next error if error?
        req.entity = entity
        next null
  
  # nesting
  app.post '/barns/:barn_id(\\d+)/owls',               (authorize acl.admin), (entity Barn), controllers.barns.nest
  app.del  '/barns/:barn_id(\\d+)/owls/:owl_id(\\d+)', (authorize acl.admin), (entity Barn), controllers.barns.unnest
  
  # owl deals
  app.post  '/owls/:owl_id(\\d+)/deals',                (authorize acl.admin), (entity Owl), controllers.deals.create
  app.patch '/owls/:owl_id(\\d+)/deals/:deal_id(\\d+)', (authorize acl.admin), (entity Owl), controllers.deals.update
  app.del   '/owls/:owl_id(\\d+)/deals/:deal_id(\\d+)', (authorize acl.admin), (entity Owl), controllers.deals.destroy
  
  # barn deals
  app.post  '/barns/:barn_id(\\d+)/deals',                (authorize acl.admin), (entity Barn), controllers.deals.create
  app.patch '/barns/:barn_id(\\d+)/deals/:deal_id(\\d+)', (authorize acl.admin), (entity Barn), controllers.deals.update
  app.del   '/barns/:barn_id(\\d+)/deals/:deal_id(\\d+)', (authorize acl.admin), (entity Barn), controllers.deals.destroy
  
  # reports
  app.get '/reports',                      (authorize acl.admin), controllers.reports.index
  app.get '/reports/dealListings',         (authorize acl.admin), controllers.reports.dealListings
  app.get '/reports/websiteRegistrations', (authorize acl.admin), controllers.reports.websiteRegistrations
  app.get '/reports/propertySearches',     (authorize acl.admin), controllers.reports.propertySearches
  app.get '/reports/dealRegistrations',    (authorize acl.admin), controllers.reports.dealRegistrations
  app.get '/reports/servicesEnquiries',    (authorize acl.admin), controllers.reports.servicesEnquiries
  app.get '/reports/advertisingClicks',    (authorize acl.admin), controllers.reports.advertisingClicks
  app.get '/reports/referrals',            (authorize acl.admin), controllers.reports.referrals
  
  # ajax TODO
  app.post '/ajax/login', controllers.ajax.login
  app.get '/ajax/search', controllers.ajax.search
  
  app.all '*', controllers.pages.serve
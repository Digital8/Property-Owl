{acl} = config = require './config'

authenticate = require './lib/authenticate'
authorize = require './lib/authorize'

area = (key = 'master') ->
  (req, res, next) ->
    res.locals.area = key
    next? null

set = (map) ->
  (req, res, next) ->
    req[key] = value for key, value of map
    next? null

module.exports = ({app, controllers}) ->
  
  app.get '/', (area 'index'), controllers.index.index
  
  app.get '/tokens/:uuid', controllers.tokens.uuid
  
  # advertisements
  app.get '/advertisements/:id(\\d+)/click', controllers.advertisements.click
  
  # epoch
  app.get '/epoch', controllers.epoch
  
  # Reset password
  app.get '/account/recover', controllers.forgot_pwd.index
  app.post '/account/recover', controllers.forgot_pwd.create
  
  # auth
  app.get '/login', controllers.login.index
  app.get '/logout', controllers.misc.logout
  app.get '/signup', controllers.signup.add
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
  app.post '/categories', authenticate, controllers.categories.create
  app.get '/categories/add', authenticate, controllers.categories.add
  # app.post '/categories/add', authenticate, controllers.categories.dontDoNicksStupidCreate
  app.patch '/categories/:id(\\d+)', authenticate, controllers.categories.update
  
  # media - what does this do???
  media = (method, path, middleware...) ->
    app[method] "/medias#{path}", authenticate, middleware...
  
  # media 'get', '', controllers.bookmarks.index
  # media 'post', '', controllers.medias.create
  # why is there only delete??
  media 'del', '/:id(\\d+)', controllers.medias.destroy
  
  # media
  category = (method, path, middleware...) ->
    app[method] "/categories#{path}", authenticate, middleware...
  
  # media 'get', '', controllers.bookmarks.index
  # media 'post', '', controllers.medias.create
  category 'del', '/:id(\\d+)', controllers.categories.destroy
  
  # bookmarks - my account
  bookmark = (method, path, middleware...) ->
    app[method] "/bookmarks#{path}", authenticate, middleware...
    # app[method] "/bookmarks#{path}", middleware...
  
  bookmark 'get', '', controllers.bookmarks.index
  bookmark 'post', '', controllers.bookmarks.create
  bookmark 'del', '/:id(\\d+)', controllers.bookmarks.destroy
  
  #app.get '/affiliates', authenticate, controllers.affiliates.index
  app.get '/affiliates', controllers.affiliates.index
  
  owl = (method, path, middleware...) ->
    #app[method] "/owls#{path}", authenticate, middleware...
    app[method] "/owls#{path}", middleware...
  
  owl 'get', '', controllers.owls.index
  owl 'get', '/:id(\\d+)/print', controllers.owls.print
  owl 'get', '/:id(\\d+)', controllers.owls.show
  owl 'get', '/top', controllers.owls.top
  owl 'get', '/hot', controllers.owls.hot
  owl 'get', '/locate', controllers.owls.locate
  owl 'get', '/state/:state', controllers.owls.byState
  
  barn = (method, path, middleware...) ->
    app[method] "/barns#{path}", middleware...
  
  barn 'get', '', controllers.barns.index
  barn 'get', "/:id(\\d+)/print", controllers.barns.print
  barn 'get', "/:id(\\d+)", controllers.barns.show
  barn 'get', "/:id(\\d+)/owls", controllers.barns.owls
  
  for key in ['news', 'research'] then do (key) ->
    app.get "/#{key}", (set type: key), controllers.posts.type
    app.get "/#{key}/:id(\\d+)", authenticate, (set type: key), controllers.posts.view
  
  ### search ###
  search = (method, path, middleware...) ->
    app[method] "/search#{path}", middleware...
  
  search 'get', '', controllers.search.index
  
  # advertisers
  app.del  '/advertisers/:id(\\d+)',        controllers.advertisers.destroy
  app.get  '/advertisers',                  controllers.advertisers.index
  app.get  '/advertisers/:id(\\d+)/delete', controllers.advertisers.delete
  app.get  '/advertisers/:id(\\d+)/edit',   controllers.advertisers.edit
  app.get  '/advertisers/add',              controllers.advertisers.add
  app.post '/advertisers',                  controllers.advertisers.create
  app.put  '/advertisers/:id(\\d+)',        controllers.advertisers.update
  
  # advertisements
  app.del  '/advertisements/:id(\\d+)',        controllers.advertisements.destroy
  app.get  '/advertisements',                  controllers.advertisements.index
  app.get  '/advertisements/:id(\\d+)/delete', controllers.advertisements.delete
  app.get  '/advertisements/:id(\\d+)/edit',   controllers.advertisements.edit
  app.get  '/advertisements/add',              controllers.advertisements.add
  app.post '/advertisements',                  controllers.advertisements.create
  app.put  '/advertisements/:id(\\d+)',        controllers.advertisements.update
  
  ### admin ###
  admin = (method, path, middleware...) ->
    if (path.indexOf('/owls') != -1 or path.indexOf('/barn') != -1 or path.indexOf('') != -1)
      app[method] "/admin#{path}", (authorize acl.developer), middleware...
    else
      app[method] "/admin#{path}", (authorize acl.admin), middleware...
  
  admin 'get', '', controllers.admin.index.index
  
  # admin/affiliates
  admin 'get', '/affiliates', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.affiliates.index
  admin 'post', '/affiliates/add', controllers.admin.affiliates.create
  admin 'get', '/affiliates/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.affiliates.add
  admin 'get', '/affiliates/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.affiliates.edit
  admin 'put', '/affiliates/:id(\\d+)', controllers.admin.affiliates.update
  admin 'get', '/affiliates/:id(\\d+)/delete', controllers.admin.affiliates.delete
  admin 'delete', '/affiliates/:id(\\d+)', controllers.admin.affiliates.destroy
  
  # admin/posts
  app.get    '/posts',                  controllers.posts.index
  app.post   '/posts',                  controllers.posts.create
  app.get    '/posts/add',              controllers.posts.add
  app.get    '/posts/:id(\\d+)/edit',   controllers.posts.edit
  app.put    '/posts/:id(\\d+)',        controllers.posts.update
  app.get    '/posts/:id(\\d+)/delete', controllers.posts.delete
  app.delete '/posts/:id(\\d+)',        controllers.posts.destroy
  
  # admin/members
  app.get  '/users',                  controllers.users.index
  app.post '/users',                  controllers.users.create
  app.put  '/users/:id(\\d+)',        controllers.users.update
  app.del  '/users/:id(\\d+)',        controllers.users.destroy
  app.get  '/users/:id(\\d+)/edit',   controllers.users.edit
  app.get  '/users/add',              controllers.users.add
  app.get  '/users/:id(\\d+)/delete', controllers.users.delete
  
  # admin/pages
  app.get    '/pages',                  controllers.pages.index
  app.post   '/pages',                  controllers.pages.create
  app.put    '/pages/:id(\\d+)',        controllers.pages.update
  app.delete '/pages/:id(\\d+)',        controllers.pages.destroy
  app.get    '/pages/add',              controllers.pages.add
  app.get    '/pages/:id(\\d+)/edit',   controllers.pages.edit
  app.get    '/pages/:id(\\d+)/delete', controllers.pages.delete
  
  # admin/files
  admin 'get', '/files', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.files.index
  admin 'post', '/files', controllers.admin.files.create
  admin 'delete', '/files/:id(\\d+)', controllers.admin.files.destroy
  
  # admin/owls
  admin 'get', '/owls', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.owls.index
  admin 'get', '/owls/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.owls.add
  admin 'get', '/owls/:id(\\d+)', ((req, res, next) -> res.locals.action = 'show' ; next()), controllers.admin.owls.show
  admin 'post', '/owls', (authorize 2), controllers.admin.owls.create
  admin 'get', '/owls/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.owls.edit
  admin 'put', '/owls/:id(\\d+)', controllers.admin.owls.update
  admin 'patch', '/owls/:id(\\d+)', controllers.admin.owls.patch
  admin 'get', '/owls/:id(\\d+)/delete', controllers.admin.owls.delete
  admin 'del', '/owls/:id(\\d+)', controllers.admin.owls.destroy
  
  admin 'post', '/owls/:id(\\d+)/clone', controllers.admin.owls.clone
  
  # admin/barn
  admin 'get', '/barns', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.barns.index
  admin 'get', '/barns/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.barns.add
  admin 'post', '/barns', controllers.admin.barns.create
  admin 'get', '/barns/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.barns.edit
  admin 'put', '/barns/:id(\\d+)', controllers.admin.barns.update
  admin 'patch', '/barns/:id(\\d+)', controllers.admin.barns.patch
  # admin 'get', '/barns/delete/:barn_id(\\d+)/:owl_id(\\d+)', controllers.admin.barns.delete
  admin 'del', '/barns/:id(\\d+)', controllers.admin.barns.destroy
  
  # nesting
  admin 'post', '/barns/:id(\\d+)/owls', controllers.barns.nest
  admin 'del',  '/barns/:barn_id(\\d+)/owls/:owl_id(\\d+)', controllers.barns.unnest
  
  # owl deals
  admin 'post',  '/owls/:id(\\d+)/deals', controllers.owls.addDeal
  admin 'patch', '/owls/:owl_id(\\d+)/deals/:deal_id(\\d+)', controllers.owls.patchDeal
  admin 'del',   '/owls/:owl_id(\\d+)/deals/:deal_id(\\d+)', controllers.owls.removeDeal
  
  # barn deals
  admin 'post',  '/barns/:id(\\d+)/deals', controllers.barns.addDeal
  admin 'patch', '/barns/:barn_id(\\d+)/deals/:deal_id(\\d+)', controllers.barns.patchDeal
  admin 'del',   '/barns/:barn_id(\\d+)/deals/:deal_id(\\d+)', controllers.barns.removeDeal
  
  # admin/reports
  admin 'get', '/reports', controllers.admin.reports.index
  admin 'get', '/reports/dealListings', controllers.admin.reports.dealListings
  admin 'get', '/reports/websiteRegistrations', controllers.admin.reports.websiteRegistrations
  admin 'get', '/reports/propertySearches', controllers.admin.reports.propertySearches
  admin 'get', '/reports/dealRegistrations', controllers.admin.reports.dealRegistrations
  admin 'get', '/reports/servicesEnquiries', controllers.admin.reports.servicesEnquiries
  admin 'get', '/reports/advertisingClicks', controllers.admin.reports.advertisingClicks
  admin 'get', '/reports/referrals', controllers.admin.reports.referrals
  
  ### ajax ###
  ajax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", middleware...
  
  ajax 'post', '/login', controllers.ajax.login
  ajax 'get', '/search', controllers.ajax.search
  
  # authedAjax = (method, path, middleware...) ->
  #   app[method] "/ajax#{path}", authenticate, middleware...
  
  # authedAjax 'post', '/securedeal', controllers.ajax.securedeal
  # authedAjax 'post', '/referfriend', controllers.ajax.referfriend
  # authedAjax 'get', '/addRegistration', controllers.ajax.addRegistration
  # authedAjax 'get', '/delRegistration', controllers.ajax.delRegistration
  # authedAjax 'post', '/registerStatus', controllers.ajax.registerStatus
  
  # adminAjax = (method, path, middleware...) ->
  #   app[method] "/ajax#{path}", authenticate, (authorize acl.admin), middleware...
  
  # adminAjax 'post', '/addDeal', controllers.ajax.addDeal
  # adminAjax 'del', '/deleteDeal', controllers.ajax.delDeal
  # adminAjax 'put', '/updateHero', controllers.ajax.updateHero
  # adminAjax 'del', '/deleteMedia', controllers.ajax.deleteMedia
  
  app.all '*', controllers.pages.serve

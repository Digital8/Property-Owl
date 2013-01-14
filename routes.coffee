{acl, helpers, controllers} = require './system'

{authenticate, authorize} = helpers

area = (key = 'master') ->
  return (req, res, next) ->
    res.locals.area = key
    do next

module.exports = (app) ->
  app.get '/', (area 'index'), controllers.index.index
  
  # epoch
  app.get '/epoch', controllers.epoch
  
  # clicks
  app.post '/clicks', controllers.clicks.create
  
  # auth
  app.all '/login', controllers.login.index
  app.get '/sign-out', controllers.misc.logout
  app.get '/logout', controllers.misc.logout
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create
  
  # ads
  app.get '/adclick/:id', controllers.adclick.index
  
  # preferences
  app.get '/preferences', authenticate, controllers.account.preferences
  app.post '/preferences', authenticate, controllers.account.updatePreferences
  
  # registrations
  app.get '/registrations', authenticate, controllers.account.registrations

  # referals
  app.get '/referals', authenticate, controllers.account.referals

  ### contact ###
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  ### account ###
  app.get '/account', authenticate, controllers.account.index
  app.put '/account', authenticate, controllers.account.update
  
  ### enquiries ###
  app.post '/enquiries', authenticate, controllers.enquiries.create
  
  ### enquiries ###
  app.post '/categories', authenticate, controllers.categories.create
  app.patch '/categories/:id((\\d+))', authenticate, controllers.categories.patch
  
  # media
  media = (method, path, middleware...) ->
    app[method] "/medias#{path}", authenticate, middleware...
  
  # media 'get', '', controllers.bookmarks.index
  # media 'post', '', controllers.medias.create
  media 'del', '/:id(\\d+)', controllers.medias.destroy
  
  # media
  category = (method, path, middleware...) ->
    app[method] "/categories#{path}", authenticate, middleware...
  
  # media 'get', '', controllers.bookmarks.index
  # media 'post', '', controllers.medias.create
  category 'del', '/:id(\\d+)', controllers.categories.destroy
  
  bookmark = (method, path, middleware...) ->
    app[method] "/bookmarks#{path}", authenticate, middleware...
  
  bookmark 'get', '', controllers.bookmarks.index
  bookmark 'post', '', controllers.bookmarks.create
  bookmark 'del', '/:id(\\d+)', controllers.bookmarks.destroy
  
  app.get '/affiliates', authenticate, controllers.affiliates.index
  
  owl = (method, path, middleware...) ->
    app[method] "/owls#{path}", authenticate, middleware...
  
  owl 'get', '', controllers.owls.index
  owl 'get', '/:id(\\d+)/print', controllers.owls.print
  owl 'get', '/:id(\\d+)', controllers.owls.show
  owl 'get', '/top', controllers.owls.top
  owl 'get', '/hot', controllers.owls.hot
  owl 'get', '/locate', controllers.owls.locate
  owl 'get', '/state/:state', controllers.owls.byState
  
  barn = (method, path, middleware...) ->
    app[method] "/barns#{path}", authenticate, middleware...
  
  barn 'get', '', controllers.barns.index
  barn 'get', "/:id(\\d+)/print", controllers.barns.print
  barn 'get', "/:id(\\d+)", controllers.barns.show
  barn 'get', "/:id(\\d+)/owls", controllers.barns.owls
  
  news = (method, path, middleware...) ->
    app[method] "/news#{path}", middleware...
  
  news 'get', '', controllers.news.index
  news 'get', '/:id(\\d+)', controllers.news.view
  
  research = (method, path, middleware...) ->
    app[method] "/research#{path}", authenticate, middleware...
  
  research 'get', '', controllers.research.index
  research 'get', '/:id(\\d+)', controllers.research.view
  
  ### search ###
  search = (method, path, middleware...) ->
    app[method] "/search#{path}", authenticate, middleware...
  
  search 'get', '', controllers.search.index
  
  ### admin ###
  admin = (method, path, middleware...) ->
    if (path.indexOf('/owls') != -1 or path.indexOf('/barn') != -1 or path.indexOf('') != -1)
      app[method] "/admin#{path}", (authorize acl.developer), middleware...
    else
      app[method] "/admin#{path}", (authorize acl.admin), middleware...
  
  admin 'get', '', controllers.admin.index.index
  
  # admin/advertising
  admin 'get', '/advertising', controllers.admin.advertising.index
  
  # admin/advertisers
  admin 'get', '/advertisers', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.advertisers.index
  admin 'post', '/advertisers', controllers.admin.advertisers.create
  admin 'get', '/advertisers/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.advertisers.add
  admin 'get', '/advertisers/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.advertisers.edit
  admin 'put', '/advertisers/:id(\\d+)', controllers.admin.advertisers.update
  admin 'get', '/advertisers/:id(\\d+)/delete', controllers.admin.advertisers.delete
  admin 'delete', '/advertisers/:id(\\d+)', controllers.admin.advertisers.destroy
  
  # admin/advertisements
  admin 'get', '/advertisements', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.advertisements.index
  admin 'post', '/advertisements', controllers.admin.advertisements.create
  admin 'get', '/advertisements/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.advertisements.add
  admin 'get', '/advertisements/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.advertisements.edit
  admin 'put', '/advertisements/:id(\\d+)', controllers.admin.advertisements.update
  admin 'get', '/advertisements/:id(\\d+)/delete', controllers.admin.advertisements.delete
  admin 'delete', '/advertisements/:id(\\d+)', controllers.admin.advertisements.destroy
  
  # admin/affiliates
  admin 'get', '/affiliates', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.affiliates.index
  admin 'post', '/affiliates/add', controllers.admin.affiliates.create
  admin 'get', '/affiliates/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.affiliates.add
  admin 'get', '/affiliates/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.affiliates.edit
  admin 'put', '/affiliates/:id(\\d+)', controllers.admin.affiliates.update
  admin 'get', '/affiliates/:id(\\d+)/delete', controllers.admin.affiliates.delete
  admin 'delete', '/affiliates/:id(\\d+)', controllers.admin.affiliates.destroy
  
  # admin/news
  admin 'get', '/news', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.news.index
  admin 'post', '/news', controllers.admin.news.create
  admin 'get', '/news/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.news.add
  admin 'get', '/news/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.news.edit
  admin 'put', '/news/:id(\\d+)', controllers.admin.news.update
  admin 'get', '/news/:id(\\d+)/delete', controllers.admin.news.delete
  admin 'delete', '/news/:id(\\d+)', controllers.admin.news.destroy
  
  # admin/members
  admin 'get', '/members', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.members.index
  admin 'post', '/members', controllers.admin.members.create
  admin 'put', '/members/:id(\\d+)', controllers.admin.members.update
  admin 'delete', '/members/:id(\\d+)', controllers.admin.members.destroy
  admin 'get', '/members/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.members.edit
  admin 'get', '/members/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.members.add
  admin 'get', '/members/:id(\\d+)/delete', controllers.admin.members.delete
  
  # admin/pages
  admin 'get', '/pages', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.pages.index
  admin 'post', '/pages', controllers.admin.pages.create
  admin 'put', '/pages/:id(\\d+)', controllers.admin.pages.update
  admin 'delete', '/pages/:id(\\d+)', controllers.admin.pages.destroy
  admin 'get', '/pages/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.pages.add
  admin 'get', '/pages/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.pages.edit
  admin 'get', '/pages/:id(\\d+)/delete', controllers.admin.pages.delete
  
  # admin/advertising
  admin 'get', '/deals', controllers.admin.deals.index
  
  # admin/owls
  admin 'get', '/owls', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.owls.index
  admin 'get', '/owls/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.owls.add
  admin 'get', '/owls/:id(\\d+)', ((req, res, next) -> res.locals.action = 'show' ; next()), controllers.admin.owls.show
  admin 'post', '/owls', (authorize acl.developers), controllers.admin.owls.create
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
  
  ### ajax ###
  ajax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", middleware...
  
  ajax 'post', '/login', controllers.ajax.login
  ajax 'post', '/register', controllers.ajax.register
  ajax 'get', '/search', controllers.ajax.search
  
  authedAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, middleware...
  
  authedAjax 'post', '/securedeal', controllers.ajax.securedeal
  authedAjax 'post', '/referfriend', controllers.ajax.referfriend
  authedAjax 'get', '/addRegistration', controllers.ajax.addRegistration
  authedAjax 'get', '/delRegistration', controllers.ajax.delRegistration
  authedAjax 'post', '/registerStatus', controllers.ajax.registerStatus
  
  adminAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, (authorize acl.admin), middleware...
  
  # adminAjax 'post', '/addDeal', controllers.ajax.addDeal
  # adminAjax 'del', '/deleteDeal', controllers.ajax.delDeal
  # adminAjax 'put', '/updateHero', controllers.ajax.updateHero
  # adminAjax 'del', '/deleteMedia', controllers.ajax.deleteMedia
  
  app.all '*', controllers.pages.index
{acl, helpers, controllers} = require './system'

{authenticate, authorize} = helpers

area = (key = 'master') ->
  return (req, res, next) ->
    res.locals.area = key
    do next

module.exports = (app) ->
  app.get '/', (area 'index'), controllers.index.index
  
  # auth
  #app.all '/login', controllers.login.index
  app.get '/sign-out', controllers.misc.logout
  app.get '/logout', controllers.misc.logout
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create
  
  app.get '/adclick/:id', controllers.adclick.index
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', authenticate, controllers.account.index
  app.post '/account', authenticate, controllers.account.update
  
  app.get '/saved', authenticate, controllers.saveddeals.index
  
  app.get '/affiliates', authenticate, controllers.affiliates.index
  
  owl = (method, path, middleware...) ->
    app.get "/owls#{path}", authenticate, middleware...
  
  owl 'get', '', controllers.owls.index
  owl 'get', '/:id(\\d+)', controllers.owls.show
  owl 'get', '/top', controllers.owls.top
  owl 'get', '/hot', controllers.owls.hot
  owl 'get', '/locate', controllers.owls.locate
  owl 'get', '/state/:state', controllers.owls.byState
  
  barn = (method, path, middleware...) ->
    app[method] "/barns#{path}", authenticate, middleware...
  
  barn 'get', '', controllers.barns.index
  barn 'get', "/:id(\\d+)", controllers.barns.show
  
  developer = (method, path, middleware...) ->
    app[method] "/developer#{path}", (authorize acl.developer), (authorize acl.admin), middleware...
  
  developer 'get', '/properties', controllers.dev.properties.index
  developer 'get', '/properties/add', controllers.dev.properties.add
  developer 'get', '/properties/add', controllers.dev.properties.create
  
  developer 'get', '/deals', controllers.dev.deals.index
  developer 'get', '/deals/add', controllers.dev.deals.add
  developer 'get', '/deals/add', controllers.dev.deals.create
  
  news = (method, path, middleware...) ->
    app[method] "/news#{path}", middleware...
  
  news 'get', '', controllers.news.index
  news 'get', '/:id(\\d+)', controllers.news.view
  
  research = (method, path, middleware...) ->
    app[method] "/research#{path}", authenticate, middleware...
  
  research 'get', '', controllers.research.index
  research  'get', '/:id(\\d+)', controllers.research.view
  
  ### search ###
  search = (method, path, middleware...) ->
    app[method] "/search#{path}", authenticate, middleware...
  
  search 'get', '', controllers.search.index
  
  ### admin ###
  admin = (method, path, middleware...) ->
    app[method] "/admin#{path}", (authorize acl.admin), middleware...
  
  admin 'get', '', controllers.admin.index.index
  
  # admin/advertising
  admin 'get', '/advertising', controllers.admin.advertising.index
  
  # admin/advertisers
  admin 'get', '/advertisers', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.advertisers.index
  admin 'post', '/advertisers/add', controllers.admin.advertisers.create
  admin 'get', '/advertisers/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.advertisers.add
  admin 'get', '/advertisers/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.advertisers.edit
  admin 'put', '/advertisers/:id(\\d+)/edit', controllers.admin.advertisers.update
  admin 'get', '/advertisers/:id(\\d+)/delete', controllers.admin.advertisers.delete
  admin 'delete', '/advertisers/:id(\\d+)/delete', controllers.admin.advertisers.destroy
  
  # admin/advertisements
  admin 'get', '/advertisements', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.advertisements.index
  admin 'post', '/advertisements/add', controllers.admin.advertisements.create
  admin 'get', '/advertisements/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.advertisements.add
  admin 'get', '/advertisements/edit/:id(\\d+)', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.advertisements.edit
  admin 'put', '/advertisements/edit/:id(\\d+)', controllers.admin.advertisements.update
  admin 'get', '/advertisements/delete/:id(\\d+)', controllers.admin.advertisements.delete
  admin 'delete', '/advertisements/delete/:id(\\d+)', controllers.admin.advertisements.destroy
  
  # admin/news
  admin 'get', '/news', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.news.index
  admin 'post', '/news/add', controllers.admin.news.create
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
  
  # admin 'get', '/services', controllers.admin.services.index
  # admin 'get', '/services/add', controllers.admin.services.add
  # admin 'get', '/services/edit/:id(\\d+)', controllers.admin.services.edit
  # admin 'put', '/services/edit/:id(\\d+)', controllers.admin.services.update
  # admin 'get', '/services/delete/:id(\\d+)', controllers.admin.services.delete
  # admin 'post', '/services/add', controllers.admin.services.create
  
  # admin/advertising
  admin 'get', '/deals', controllers.admin.deals.index
  
  # admin/owls
  admin 'get', '/owls', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.owls.index
  admin 'get', '/owls/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.owls.add
  admin 'get', '/owls/:id(\\d+)/view', ((req, res, next) -> res.locals.action = 'view' ; next()), controllers.admin.owls.view
  admin 'post', '/owls', controllers.admin.owls.create
  admin 'get', '/owls/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.owls.edit
  admin 'put', '/owls/:id(\\d+)', controllers.admin.owls.update
  admin 'get', '/owls/:id(\\d+)/delete', controllers.admin.owls.delete
  admin 'del', '/owls/:id(\\d+)', controllers.admin.owls.destroy
  
  # admin/barn
  admin 'get', '/barns', ((req, res, next) -> res.locals.action = 'index' ; next()), controllers.admin.barns.index
  admin 'get', '/barns/add', ((req, res, next) -> res.locals.action = 'add' ; next()), controllers.admin.barns.add
  admin 'post', '/barns', controllers.admin.barns.create
  admin 'get', '/barns/:id(\\d+)/edit', ((req, res, next) -> res.locals.action = 'edit' ; next()), controllers.admin.barns.edit
  admin 'put', '/barns/:id(\\d+)', controllers.admin.barns.update
  # admin 'get', '/barns/delete/:barn_id(\\d+)/:owl_id(\\d+)', controllers.admin.barns.delete
  # admin 'del', '/barns/delete/:barn_id(\\d+)/:owl_id(\\d+)', controllers.admin.barns.destroy
  
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
  
  ajax 'get', '/epoch', controllers.ajax.epoch
  
  ajax 'get', '/search', controllers.ajax.search
  
  authedAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, middleware...
  
  authedAjax 'post', '/bookmark', controllers.ajax.bookmark
  authedAjax 'post', '/unbookmark', controllers.ajax.unbookmark
  
  authedAjax 'post', '/securedeal', controllers.ajax.securedeal
  authedAjax 'post', '/referfriend', controllers.ajax.referfriend
  authedAjax 'get', '/addRegistration', controllers.ajax.addRegistration
  authedAjax 'get', '/delRegistration', controllers.ajax.delRegistration
  
  adminAjax = (method, path, middleware...) ->
    app[method] "/ajax#{path}", authenticate, (authorize acl.admin), middleware...
  
  adminAjax 'post', '/addDeal', controllers.ajax.addDeal
  adminAjax 'del', '/deleteDeal', controllers.ajax.delDeal
  adminAjax 'put', '/updateHero', controllers.ajax.updateHero
  adminAjax 'del', '/deleteMedia', controllers.ajax.deleteMedia
  
  app.all '*', controllers.pages.index
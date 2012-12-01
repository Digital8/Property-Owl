fs = require 'fs'

{acl, controllers} = system = require './system'

fs.readdirSync("./controllers").forEach (module) -> 
  controllers[module.split('.')[0]] = require("./controllers/" + module)

helpers =
  authenticate: system.load.helper 'requireAuth'
  authorize: system.load.helper 'restrictTo'

{authenticate, authorize} = helpers

module.exports = (app) ->
  app.get '/', controllers.index.index
  
  # auth
  app.all '/login', controllers.login.index
  app.get '/sign-out', controllers.signout.index
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create

  app.get '/adclick/:id', controllers.adclick.index
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', authenticate, controllers.account.index
  app.post '/account', authenticate, controllers.account.update
  
  app.get '/best-deal', authenticate, controllers.best_deal.index
  
  app.get '/saved', authenticate, controllers.saveddeals.index
  
  app.get '/owl-deals', authenticate, controllers.owl_deals.index
  
  app.get '/products', authenticate, controllers.products.index
  
  app.get '/barn-deals', authenticate, controllers.barn_deals.index
  
  app.get '/barn/deals/:id', authenticate, controllers.barn_deals.view
  
  app.get '/deals/state', authenticate, controllers.deals_state.index
  app.get '/deals/state/:state', authenticate, controllers.deals_state.view
  
  app.get '/properties/view/:id', authenticate, controllers.properties.view
  
  app.get '/developers/properties', (authorize acl.developer), (authorize acl.admin), controllers.dev_properties.index
  app.get '/developers/properties/add', (authorize acl.developer), (authorize acl.admin), controllers.dev_properties.add
  app.post '/developers/properties/add', (authorize acl.developer), (authorize acl.admin), controllers.dev_properties.create
  
  app.get '/developers/deals', (authorize acl.developer), (authorize acl.admin), controllers.dev_deals.index
  app.get '/developers/deals/add', (authorize acl.developer), (authorize acl.admin), controllers.dev_deals.add
  app.post '/developers/deals/add', (authorize acl.developer), (authorize acl.admin), controllers.dev_deals.create
  
  # news
  app.get '/news', authenticate, controllers.news.index
  app.get '/news/:id', authenticate, controllers.news.view
  
  # research
  app.get '/research', authenticate, controllers.research.index
  app.get '/research/:id', authenticate, controllers.research.view
  
  # search
  app.get '/search', authenticate, controllers.search.index
  
  # administration
  app.get '/administration', (authorize acl.admin), controllers.admin_index.index
  
  # advertising
  app.get '/administration/advertising', (authorize acl.admin), controllers.admin_advertising.index
  
  # advertisers
  app.get '/administration/advertisers', (authorize acl.admin), controllers.admin_advertisers.index
  app.post '/administration/advertisers/add', (authorize acl.admin), controllers.admin_advertisers.create
  app.get '/administration/advertisers/add', (authorize acl.admin), controllers.admin_advertisers.add
  app.get '/administration/advertisers/edit/:id', (authorize acl.admin), controllers.admin_advertisers.edit
  app.put '/administration/advertisers/edit/:id', (authorize acl.admin), controllers.admin_advertisers.update
  app.get '/administration/advertisers/delete/:id', (authorize acl.admin), controllers.admin_advertisers.delete
  app.delete '/administration/advertisers/delete/:id', (authorize acl.admin), controllers.admin_advertisers.destroy
  
  # advertisements
  app.get '/administration/advertisements', (authorize acl.admin), controllers.admin_advertisements.index
  app.post '/administration/advertisements/add', (authorize acl.admin), controllers.admin_advertisements.create
  app.get '/administration/advertisements/add', (authorize acl.admin), controllers.admin_advertisements.add
  app.get '/administration/advertisements/edit/:id', (authorize acl.admin), controllers.admin_advertisements.edit
  app.put '/administration/advertisements/edit/:id', (authorize acl.admin), controllers.admin_advertisements.update
  app.get '/administration/advertisements/delete/:id', (authorize acl.admin), controllers.admin_advertisements.delete
  app.delete '/administration/advertisements/delete/:id', (authorize acl.admin), controllers.admin_advertisements.destroy
  
  app.get '/administration/news', (authorize acl.admin), controllers.admin_news.index
  app.post '/administration/news/add', (authorize acl.admin), controllers.admin_news.create
  app.get '/administration/news/add', (authorize acl.admin), controllers.admin_news.add
  app.get '/administration/news/edit/:id', (authorize acl.admin), controllers.admin_news.edit
  app.put '/administration/news/edit/:id', (authorize acl.admin), controllers.admin_news.update
  app.get '/administration/news/delete/:id', (authorize acl.admin), controllers.admin_news.delete
  app.delete '/administration/news/delete/:id', (authorize acl.admin), controllers.admin_news.destroy
  
  app.get '/administration/members', (authorize acl.admin), controllers.admin_members.index
  app.get '/administration/members/add', (authorize acl.admin), controllers.admin_members.add
  app.post '/administration/members/add', (authorize acl.admin), controllers.admin_members.create
  app.get '/administration/members/edit/:id', (authorize acl.admin), controllers.admin_members.edit
  app.put '/administration/members/edit/:id', (authorize acl.admin), controllers.admin_members.update
  
  app.get '/administration/pages', (authorize acl.admin), controllers.admin_pages.index
  app.get '/administration/pages/add', (authorize acl.admin), controllers.admin_pages.add
  app.get '/administration/pages/edit/:id', (authorize acl.admin), controllers.admin_pages.edit
  app.put '/administration/pages/edit/:id', (authorize acl.admin), controllers.admin_pages.update
  app.get '/administration/pages/delete/:id', (authorize acl.admin), controllers.admin_pages.delete
  app.post '/administration/pages/add', (authorize acl.admin), controllers.admin_pages.create
  app.delete '/administration/pages/delete/:id', (authorize acl.admin), controllers.admin_pages.destroy
  
  app.get '/administration/services', (authorize acl.admin), controllers.admin_services.index
  app.get '/administration/services/add', (authorize acl.admin), controllers.admin_services.add
  app.get '/administration/services/edit/:id', (authorize acl.admin), controllers.admin_services.edit
  app.put '/administration/services/edit/:id', (authorize acl.admin), controllers.admin_services.update
  app.get '/administration/services/delete/:id', (authorize acl.admin), controllers.admin_services.delete
  app.post '/administration/services/add', (authorize acl.admin), controllers.admin_services.create
  
  # TODO
  app.get '/administration/services/categories', (authorize acl.admin), controllers.admin_services.viewCategories
  app.get '/administration/services/categories/add', (authorize acl.admin), controllers.admin_services.addCategory
  app.post '/administration/services/categories/add', (authorize acl.admin), controllers.admin_services.createCategory
  app.get '/administration/services/categories/edit/:id', (authorize acl.admin), controllers.admin_services.editCategory
  app.put '/administration/services/categories/edit/:id', (authorize acl.admin), controllers.admin_services.updateCategory
  app.get '/administration/services/categories/delete/:id', (authorize acl.admin), controllers.admin_services.deleteCategory
  
  app.get '/administration/barn', (authorize acl.admin), controllers.admin_barn.index
  app.get '/administration/barn/edit/:id', (authorize acl.admin), controllers.admin_barn.edit
  app.get '/administration/barn/add', (authorize acl.admin), controllers.admin_barn.add
  app.post '/administration/barn/add', (authorize acl.admin), controllers.admin_barn.create
  app.get '/administration/barn/delete/:barn_id/:property_id', (authorize acl.admin), controllers.admin_barn.delete
  app.del '/administration/barn/delete/:barn_id/:property_id', (authorize acl.admin), controllers.admin_barn.destroy
  
  app.get '/administration/properties', (authorize acl.admin), controllers.admin_properties.index
  app.get '/administration/properties/add', (authorize acl.admin), controllers.admin_properties.add
  app.post '/administration/properties/add', (authorize acl.admin), controllers.admin_properties.create
  app.get '/administration/properties/edit/:id', (authorize acl.admin), controllers.admin_properties.edit
  app.put '/administration/properties/add', (authorize acl.admin), controllers.admin_properties.update

  app.get '/administration/reports', (authorize acl.admin), controllers.admin_reports.index
  
  # ajax
  app.post '/ajax/login', controllers.ajax.login
  app.post '/ajax/savedeal', authenticate, (authorize acl.admin), controllers.ajax.savedeal
  app.post '/ajax/removedeal', authenticate, (authorize acl.admin), controllers.ajax.removedeal
  app.post '/ajax/addDeal', authenticate, (authorize acl.admin), controllers.ajax.addDeal
  app.del '/ajax/deleteDeal', authenticate, (authorize acl.admin), controllers.ajax.delDeal
  app.put '/ajax/updateHero', authenticate, (authorize acl.admin), controllers.ajax.updateHero
  app.del '/ajax/deleteMedia', authenticate, (authorize acl.admin), controllers.ajax.deleteMedia
  app.get '/ajax/addRegistration', authenticate, controllers.ajax.addRegistration
  app.get '/ajax/delRegistration', authenticate, controllers.ajax.delRegistration

  app.all '*', controllers.pages.index
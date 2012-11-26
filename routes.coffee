###
 * Routes
 *
 * Binds the website routes to specific actions in controllers
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
system = require './system'
fs = require 'fs'

# Load in the controllers
controllers = {}

fs.readdirSync("./controllers").forEach (module) -> 
  controllers[module.split('.')[0]] = require("./controllers/" + module)

# Load in the helpers
helpers =
  requireAuth: system.load.helper 'requireAuth'
  checkModule: system.load.helper 'checkModule'
  checkRights: system.load.helper 'checkRights'
  restrictTo: system.load.helper 'restrictTo'

module.exports = (app) ->
  # index
  app.get '/', controllers.index.index
  
  app.all '/login', controllers.login.index
  
  # Sign-Out
  app.get '/sign-out', controllers.signout.index
  
  # Sign-Up
  app.get '/sign-up', controllers.signup.index
  app.post '/sign-up', controllers.signup.create
  
  app.get '/contact', controllers.contact.index
  app.post '/contact', controllers.contact.create
  
  app.get '/account', helpers.requireAuth, controllers.account.index
  app.post '/account', helpers.requireAuth, controllers.account.update
  
  app.get '/best-deal', helpers.requireAuth, controllers.best_deal.index
  
  app.get '/saved', helpers.requireAuth, controllers.saveddeals.index
  
  app.get '/owl-deals', helpers.requireAuth, controllers.owl_deals.index
  
  app.get '/why-the-owl', controllers.wto.index
  
  app.get '/products', helpers.requireAuth, controllers.products.index
  
  app.get '/barn-deals', helpers.requireAuth, controllers.barn_deals.index
  
  app.get '/barn/deals/:id', helpers.requireAuth, controllers.barn_deals.view
  
  app.get '/deals/state', helpers.requireAuth, controllers.deals_state.index
  app.get '/deals/state/:state', helpers.requireAuth, controllers.deals_state.view
  
  app.get '/properties/view/:id', helpers.requireAuth, controllers.properties.view
  
  app.get '/developers/properties', helpers.restrictTo(system.config.acl.developer), helpers.restrictTo(system.config.acl.admin), controllers.dev_properties.index
  app.get '/developers/properties/add', helpers.restrictTo(system.config.acl.developer), helpers.restrictTo(system.config.acl.admin), controllers.dev_properties.add
  app.post '/developers/properties/add', helpers.restrictTo(system.config.acl.developer), helpers.restrictTo(system.config.acl.admin), controllers.dev_properties.create
  
  app.get '/developers/deals', helpers.restrictTo(system.config.acl.developer), helpers.restrictTo(system.config.acl.admin), controllers.dev_deals.index
  app.get '/developers/deals/add', helpers.restrictTo(system.config.acl.deeveloper), helpers.restrictTo(system.config.acl.admin), controllers.dev_deals.add
  app.post '/developers/deals/add', helpers.restrictTo(system.config.acl.deeveloper), helpers.restrictTo(system.config.acl.admin), controllers.dev_deals.create
  
  # News
  app.get '/news', helpers.requireAuth, controllers.news.index
  
  # Search
  app.get '/search', helpers.requireAuth, controllers.search.index
  
  # Administration Routes
  app.get '/administration', helpers.restrictTo(system.config.acl.admin), controllers.admin_index.index
  
  app.get '/administration/advertising', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertising.index
  
  # advertisers
  app.get '/administration/advertisers', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.index
  app.post '/administration/advertisers/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.create
  app.get '/administration/advertisers/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.add
  app.get '/administration/advertisers/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.edit
  app.put '/administration/advertisers/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.update
  app.get '/administration/advertisers/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.delete
  app.delete '/administration/advertisers/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisers.destroy
  
  # advertisements
  app.get '/administration/advertisements', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.index
  app.post '/administration/advertisements/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.create
  app.get '/administration/advertisements/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.add
  app.get '/administration/advertisements/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.edit
  app.put '/administration/advertisements/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.update
  app.get '/administration/advertisements/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.delete
  app.delete '/administration/advertisements/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_advertisements.destroy
  
  app.get '/administration/news', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.index
  app.post '/administration/news/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.create
  app.get '/administration/news/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.add
  app.get '/administration/news/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.edit
  app.put '/administration/news/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.update
  app.get '/administration/news/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.delete
  app.delete '/administration/news/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_news.destroy
  
  app.get '/administration/members', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.index
  app.get '/administration/members/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.add
  app.post '/administration/members/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.create
  app.get '/administration/members/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.edit
  app.put '/administration/members/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_members.update
  
  app.get '/administration/pages', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.index
  app.get '/administration/pages/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.add
  app.get '/administration/pages/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.edit
  app.put '/administration/pages/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.update
  app.get '/administration/pages/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.delete
  app.post '/administration/pages/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.create
  app.delete '/administration/pages/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_pages.destroy
  
  app.get '/administration/services', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.index
  app.get '/administration/services/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.add
  app.get '/administration/services/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.edit
  app.put '/administration/services/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.update
  app.get '/administration/services/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.delete
  app.post '/administration/services/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.create

  app.get '/administration/services/categories', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.viewCategories
  app.get '/administration/services/categories/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.addCategory
  app.post '/administration/services/categories/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.createCategory
  app.get '/administration/services/categories/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.editCategory
  app.put '/administration/services/categories/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.updateCategory
  app.get '/administration/services/categories/delete/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_services.deleteCategory
  
  app.get '/administration/barn', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.index
  app.get '/administration/barn/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.edit
  app.get '/administration/barn/add/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.add
  app.post '/administration/barn/add/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.create
  app.get '/administration/barn/delete/:barn_id/:property_id', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.delete
  app.del '/administration/barn/delete/:barn_id/:property_id', helpers.restrictTo(system.config.acl.admin), controllers.admin_barn.destroy
  
  app.get '/administration/properties', helpers.restrictTo(system.config.acl.admin), controllers.admin_properties.index
  app.get '/administration/properties/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_properties.add
  app.post '/administration/properties/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_properties.create
  app.get '/administration/properties/edit/:id', helpers.restrictTo(system.config.acl.admin), controllers.admin_properties.edit
  app.put '/administration/properties/add', helpers.restrictTo(system.config.acl.admin), controllers.admin_properties.update
  
  # Misc Routes
  #app.get '/login', controllers.misc.login
  #app.get '/logout', controllers.misc.logout
  app.post '/ajax/login', controllers.ajax.login
  app.post '/ajax/savedeal', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.savedeal
  app.post '/ajax/removedeal', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.removedeal
    
  app.post '/ajax/addDeal', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.addDeal
  app.del '/ajax/deleteDeal', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.delDeal
  app.put '/ajax/updateHero', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.updateHero
  app.del '/ajax/deleteMedia', helpers.requireAuth, helpers.restrictTo(system.config.acl.admin), controllers.ajax.deleteMedia
  
  app.all '*', controllers.pages.index
  
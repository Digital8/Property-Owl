async = require 'async'

exports.index = (req, res) ->
  
  async.parallel
    
    owls: (callback) -> Owl.pending callback
    
    barns: (callback) -> Barn.pending callback
    
    activeAdvertisementCount: (callback) -> Advertisement.countActive callback
    
    usersThisMonth: (callback) -> User.thisMonth callback
    
    affiliates: (callback) -> Affiliate.all callback
    
    signupsThisMonth: (callback) =>
      exports.db.query "SELECT COUNT(*) AS count FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)", (error, rows) ->
        return callback error if error?
        callback null, rows[0].count
  
  , (error, {owls, barns, activeAdvertisementCount, usersThisMonth, affiliates, signupsThisMonth}) ->
    
    res.render 'admin/index',
      activeAdvertisementCount: activeAdvertisementCount
      owls: owls or {}
      barns: barns or {}
      usersThisMOnth: usersThisMonth or {}
      affiliates: affiliates or {}
      signupsThisMonth: signupsThisMonth or NaN
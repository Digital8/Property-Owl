module.exports = ->
  
  (req, res, next) ->
    
    res.locals.navigation = [
      {key: 'aus-best-deal',   href: '/owls/top',       label: "Australia's Best Deal"}
      {key: 'best-state-deal', href: '/owls/state/qld', label: 'Best State Deal'}
      {key: 'owl-deals',       href: '#',               label: 'Owl Deals'}
      {key: 'wise-owl',        href: '#',               label: 'Wise Owl'}
      {key: 'products',        href: '#',               label: 'Products & Services'}
      {key: 'my-nest',         href: '#',               label: 'My Nest'}
    ]
    
    next? null
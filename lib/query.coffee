module.exports = class Query
  constructor: (args = {}) ->
    @select = args.select
    @where = args.where
    @limit = args.limit
    @order = args.order
    @group = args.group
    
    @table = args.table
    
    Object.defineProperty this, 'sql', get: => @toSQL()
    
    @lines = {}
    
    Object.defineProperty @lines, 'limit', get: => "LIMIT #{@limit}"
    Object.defineProperty @lines, 'order', get: => "ORDER BY #{@order}"
    Object.defineProperty @lines, 'group', get: => "GROUP BY #{@group}"
    
    Object.defineProperty @lines, 'select', get: =>
      selects = ["#{@table.name}.#{@table.key}"]
      
      for select in @selects
        selects.push select
      
      """
      SELECT
        #{selects.join ',\n  '}
      """
    
    Object.defineProperty @lines, 'join', get: =>
      """
      #{@join}
      """
    
    Object.defineProperty @lines, 'from', get: =>
      """
      FROM
        #{@table.name}
      """
  
  toSQL: ->
    
    try
      {select, from, join, group, order, limit} = @lines
    catch e
      console.log e
    
    unless @select? then select = ''
    unless @from? then from = ''
    unless @join? then join = ''
    unless @group then group = ''
    unless @order? then order = ''
    unless @limit? then limit = ''
    
    """
    #{select}
    #{from}
    #{join}
    #{group}
    #{order}
    #{limit}
    """
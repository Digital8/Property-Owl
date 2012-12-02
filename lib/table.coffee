module.exports = class Table
  constructor: (args = {}) ->
    @name = args.name
    @key = args.key
    @columns = args.columns or {}
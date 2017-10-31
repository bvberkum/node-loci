qs = require 'qs'


parse_simple_types = ( query ) ->
  for key, value of query
    if value in [ 'true', 'false' ]
      query[key] = Boolean value
    else if not isNaN parseInt value, 10
      query[key] = parseInt value, 10
    else if typeof value == "object"
      parse_simple_types query[key]


module.exports = ( ctx ) ->

  express = require('express')
  app = ctx.app = express()

  if not ctx.static_proto
    ctx.static_proto = express.static

  app.set 'port', ctx.config.port
  app.set 'showStackError', ctx.config['show-stack-trace']

  ctx.server = require("http").createServer app
  ctx.io = require('socket.io') ctx.server

  # Get a generic templater and set our filename extensions
  engines = require 'consolidate'
  for ext_engine_map in ctx.config.engines
    if 'string' is typeof ext_engine_map
      app.engine ext_engine_map, engines[ext_engine_map]
    else
      ext = _.keys( ext_engine_map )[0]
      app.engine ext, engines[ext_engine_map[ext]]

  app.set 'query parser', ( query_str ) ->
    query = qs.parse query_str
    parse_simple_types query
    query

  ctx.redir = ( ref, p ) ->
    # Express redir handler
    ctx.app.all ref, (req, res) ->
      res.redirect p

  app

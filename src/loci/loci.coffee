_ = require 'lodash'
process = require 'process'
nodelib = require 'nodelib-mpe'
path = require 'path'
cc = require 'coffee-script'
fs = require 'fs'

libexpress = require './express'
libroutes = require './routes'


ServiceContainer = require 'service-container'


class LociContext extends nodelib.Context

  constructor: ( init, sup ) ->
    super init, sup
    @class = LociContext
    _.defaultsDeep @route,
      page:
        title: 'Loci'
      head:
        js: []
        cs: []
        css: [
          '/vendor/bootstrap.css'
          '/vendor/bootstrap-table.css'
        ]
        rjs: []
      pkg: @package
      menu: {}
      filters:
        'loci-tree': ( text, options ) ->
          'tree'
        'loci-graph': ( text, options ) ->
          'graph'
      lib: _.bind @resolve_js, @

  serve_vendor: ( req, res ) ->
    rp = req.params
    res.type 'js'
    cpath = "src/#{rp.vendor}/app/#{rp.path}.coffee"
    res.write cc._compileFile cpath
    res.end()

  resolve_js: ( id,
    formats=['js','css','svg','web-font','true-font'],
    schemes=['http','local']
  ) ->
    if id of @deps.url
      return @deps.url[id]
    for ct in formats
      if ct not of @cdn then continue
      for s in schemes
        if s not of @cdn[ct] then continue
        if id of @cdn[ct][s].packages
          return @cdn[ct][s] + @cdn[ct][s].ext
    throw new Error "No JS for #{id}"

  add_shim_inits: ( jsonstr ) ->
    for lib of @deps.shim
      if 'init-script' of @deps.shim[lib]
        fn = @deps.shim[lib]['init-script']
        if fn.match /.coffee$/
          func = cc._compileFile fn
        else
          func = fs.readFileSync fn

        func = String(func).trim()
        jsonstr = jsonstr.replace "\"#{lib}\":{",
            "\"#{lib}\":{\"init\": #{func},"

    jsonstr


  # XXX: should do hyperlink resolving
  ref: ->

  # template data for express request
  tpld: ( req ) ->
    @route
 

module.exports = lib =

    log: console.log

    # Bootstrap context
    init: ( ctxp ) ->

      #proc =
      #    noderoot: '../..'
      #    scriptname: 'loci'
      ctxp = _.defaultsDeep ctxp,
        proc: {}
        config:
          port: 7020
        route: {}
        package: {}
        packages: {}
        var:
          lib:
            loci:
              core: null
              context: null
              container: null

          local:
            loci:
              types: {}
              services: {}
              parameters: {}

      if process.env.LOCI_PORT
        ctx.config.port = process.env.LOCI_PORT
      #if process.pid not in ctxp.proc:
      core = ctxp.proc[process.pid]

      # Load services.json and services_<env>.json
      container = ServiceContainer.buildContainer core.noderoot, {}

      ctxp.var.lib.loci.container = container
      ctxp.var.lib.loci.core = core

      ctx = new LociContext ctxp
      ctx.var.lib.loci.context = ctx
      ctx

    start: ( ctx ) ->
      app = libexpress ctx
      libroutes ctx
      app

    serve: ( done, ctx ) ->
      lib.log "Starting #{ctx.package.version} "+\
        "(Express #{ctx.packages.express.version}) "+\
        "server at localhost:#{ctx.config.port}"

      return if ctx.config.host
        ctx.server.listen ctx.config.port, ctx.config.host, ->
          if ctx.verbose
            lib.log "Listening", "Express server on port #{ctx.config.port}. "
          !done || done()

      else
        ctx.server.listen ctx.config.port, ->
          if ctx.verbose
            lib.log "Listening", "Express server on port #{ctx.config.port}. "
          !done || done()

    run_main: ( ctx, opts, done ) ->
      for k in ['port','host']
        if k of opts and opts[k]
          ctx.config[k] = opts['--'+k]
      app = lib.start ctx, opts
      lib.serve done, ctx
      app

#

_ = require 'lodash'
process = require 'process'
nodelib = require 'nodelib-mpe'
path = require 'path'

libexpress = require './express'
libroutes = require './routes'


ServiceContainer = require 'service-container'


class LociContext extends nodelib.Context

  
module.exports = lib =
  {
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
  }

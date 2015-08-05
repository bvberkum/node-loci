# coffeelint: disable=max_line_length
_ = require 'lodash'
path = require 'path'
jade = require 'jade'



view = module.exports =

  init_jade_handler: ( name, seed={} ) ->
    tplPath = require.resolve "./#{name}.jade"
    clientTpl = jade.compileFile tplPath
    ( req, res ) ->
      params = view.default_params seed
      res.write clientTpl params
      res.end()

  default_params: ( seed={} ) ->
    defaults =
        pkg: require './../../../package.json'
        page:
          title: "Loci"
        head:
          lib:
            cs: {}
            js:
              'socket.io': '/socket.io/socket.io.js'
              jquery: '/components/jquery/dist/jquery.js'
              lodash: '/components/lodash/lodash.js'
              bootstrap: '/components/bootstrap/dist/js/bootstrap.js'
              coffeescript: '/components/coffee-script/extras/coffee-script.js'
              backbone: '/components/backbone/backbone.js'
              'backbone.marionette': '/components/backbone.marionette/lib/backbone.marionette.js'
              #'backbone.marionette': 'https://rawgit.com/marionettejs/backbone.marionette/master/lib/backbone.marionette.js'
              #'backbone.marionette': 'https://rawgit.com/derickbailey/backbone.marionette/master/lib/backbone.marionette.js'
              #'backbone.memento': 'https://rawgit.com/derickbailey/backbone.memento/master/backbone.memento.min.js'
              #'backbone.modelbinding': 'https://rawgit.com/derickbailey/backbone.modelbinding/master/backbone.modelbinding.min.js'

            css:
              bootstrap: '/components/bootstrap/dist/css/bootstrap.css'
              'bootstrap-theme': '/components/bootstrap/dist/css/bootstrap-theme.css'
          init:
            rjs: []
        menu: []
        modules: []

    # FIXME: merge is not effective, order is not guaranteed.
    # Deep merge of object, and union all arrays--no way to reset
    _.merge seed, defaults, ( objVal, srcVal, key, obj, src ) ->
      if _.isArray( objVal ) && _.isArray( srcVal )
        _.union( objVal, srcVal )


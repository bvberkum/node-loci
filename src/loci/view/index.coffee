_ = require 'lodash'


module.exports =
  default_params: ( config, seed={} ) ->

    comp_base = config.root + '/components'

    head_lib = {
      cs: {}
      js:
        bootstrap: comp_base+'/bootstrap/dist/js/bootstrap.js'
        jquery: comp_base+'/jquery/dist/jquery.js'
      css:
        bootstrap: comp_base+'/bootstrap/dist/css/bootstrap.css'
        'bootstrap-theme': comp_base+'/bootstrap/dist/css/bootstrap-theme.css'
    }

    seed.comp_base = comp_base
    seed.config = config

    _.defaults seed,
        pkg: require './../../../package.json'
        page:
          title: "Loci"
        head:
          lib: head_lib
          init:
            cs: []
            js: [
              'jquery', 'bootstrap'
            ]
            css: [
              'bootstrap'
              'bootstrap-theme'
            ]
            rjs: []
        menu: []
        modules: []


_ = require 'lodash'


head_lib = {
  cs: {}
  js:
    bootstrap: '/components/bootstrap/dist/js/bootstrap.js'
    jquery: '/components/jquery/dist/jquery.js'
  css:
    bootstrap: '/components/bootstrap/dist/css/bootstrap.css'
    'bootstrap-theme': '/components/bootstrap/dist/css/bootstrap-theme.css'
}

module.exports =
  default_params: ( seed={} ) ->
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


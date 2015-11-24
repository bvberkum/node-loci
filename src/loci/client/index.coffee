jade = require 'jade'

view = require '../view'
loci = require '../'

module.exports = ( app, config ) ->

  console.log 'config client/index', config

  clientTpl = jade.compileFile require.resolve '../view/client/main.jade'
  app.get config.root+'/client', ( req, res ) ->
    params = view.default_params(config)
    res.write clientTpl params
    res.end()

  clientTpl = jade.compileFile require.resolve '../view/client/slideshow.jade'
  console.log "Serving on ", config.root+'/client/slideshow'
  app.get config.root+'/client/slideshow', ( req, res ) ->
    params = view.default_params(config)
    urlFile = req.query.list || loci.default_settings().load_urls
    console.log "Serving /client/slideshow for", urlFile
    params.urlList = loci.load_urls( urlFile )
    res.write clientTpl params
    res.end()


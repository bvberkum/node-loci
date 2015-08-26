jade = require 'jade'

view = require '../view'
loci = require '../'

module.exports = ( app, config ) ->

  clientTpl = jade.compileFile require.resolve '../view/client/main.jade'
  app.get config.root+'/client', ( req, res ) ->
    params = view.default_params(config)
    res.write clientTpl params
    res.end()

  clientTpl = jade.compileFile require.resolve '../view/client/slideshow.jade'
  app.get config.root+'/client/slideshow', ( req, res ) ->
    params = view.default_params(config)
    urlFile = req.query.list || loci.default_settings().load_urls
    params.urlList = loci.load_urls( urlFile )
    res.write clientTpl params
    res.end()


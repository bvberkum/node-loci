jade = require 'jade'

view = require '../view'
loci = require '../'

module.exports = ( app ) ->

	clientTpl = jade.compileFile require.resolve '../view/client/main.jade'
	app.get '/client', ( req, res ) ->
		params = view.default_params()
		res.write clientTpl params
		res.end()

	clientTpl = jade.compileFile require.resolve '../view/client/slideshow.jade'
	app.get '/client/slideshow', ( req, res ) ->
		params = view.default_params()
		params.urlList = loci.load_urls( req.query.list || loci.default_settings().load_urls )
		res.write clientTpl params
		res.end()


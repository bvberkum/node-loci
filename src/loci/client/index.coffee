jade = require 'jade'

view = require '../view'

module.exports = ( app ) ->

	clientTpl = jade.compileFile require.resolve '../view/client/main.jade'
	app.get '/client', ( req, res ) ->
		params = view.default_params()
		res.write clientTpl params
		res.end()

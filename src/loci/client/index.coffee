view = require '../view'



module.exports = ( app ) ->

  require( './example-data' ) app

  listname = 'urls.list'
  require( './backend' ) app, listname

  app.get '/main', view.init_jade_handler 'client/main',
    listname: listname
    head:
      lib:
        cs:
          client: '/client.coffee'

  app.get '/slideshow', view.init_jade_handler 'client/slideshow',
    listname: listname
    head:
      lib:
        cs:
          client: '/client.coffee'

  app.get '/view/part/url-tile', view.init_jade_handler 'client/part/url-tile', {}



port = 7001

express = require 'express.io'

app = express()
app.http().io()


# Setup the ready route, and emit talk event.
app.io.route 'ready', (req) ->
  req.io.emit 'talk',
    message: 'io event from an io route on the server'

# Send the client html.
app.get '/client.html', (req, res) ->
  console.log 'Serving client'
  res.sendfile __dirname + '/public/client.html'

app.get '/', ( req, res ) ->
  res.redirect '/client.html'


app.use express.static './public'

# Export server module
module.exports =
  port: port
  app: app
  proc: null
  init: ( done ) ->
    port = module.exports.port
    proc = app.listen port, ->
      console.log "server at localhost:#{port}"
      !done || done()
    module.exports.proc = proc
    proc


a = process.argv
if a.length == 2 and a[0] == 'coffee' and a[1] == require.resolve './server'
  console.log "Starting server"
  module.exports.init()



port = 7001

app = require('express.io')()
app.http().io()


# Setup the ready route, and emit talk event.
app.io.route 'ready', (req) ->
  req.io.emit 'talk',
    message: 'io event from an io route on the server'

# Send the client html.
app.get '/', (req, res) ->
  console.log 'Serving client'
  res.sendfile __dirname + '/public/client.html'

module.exports =
  port: port
  app: app
  proc: null
  init: ( done ) ->
    proc = app.listen port, ->
      console.log "server at localhost:#{port}"
      !done || done()
    module.exports.proc = proc
    proc


a = process.argv
if a.length == 2 and a[0] == 'coffee' and a[1] == require.resolve './server'
  console.log "Starting server"
  module.exports.init()



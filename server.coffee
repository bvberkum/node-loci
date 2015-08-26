port = 7001

express = require 'express.io'
fs = require 'fs'
cs = require 'coffee-script'

app = express()
app.http().io()


config = require './config/server'
root = config.root || ''


# Setup the ready route, and emit talk event.
app.io.route 'ready', (req) ->
  req.io.emit 'talk',
    message: 'io event from an io route on the server'

# Send the client html.
app.get root+'/', (req, res) ->
  console.log 'Serving client'
  res.sendfile __dirname + '/public/client.html'


app.get root+'/client/slideshow.js', (req, res) ->
  data = fs.readFileSync 'public/slideshow.coffee'
  compiled = cs.compile data.toString()
  res.write compiled
  res.end()

# first setup for Jade client
require( './src/loci/client' )(app, config)

app.use root, express.static './public'

# Export server module
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



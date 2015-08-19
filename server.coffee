port = 7001

express = require 'express.io'

app = express()
app.http().io()


app.get '/', ( req, res ) ->
  res.redirect '/main'

app.use express.static './public'

# Setup client to serve list file

# TODO: build a frontend to relay paths to list files
require( './src/loci/client' )(app)


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




app = require('express.io')()
app.http().io()


# Setup the ready route, and emit talk event.
app.io.route 'ready', (req) ->
  req.io.emit 'talk',
    message: 'io event from an io route on the server'

# Send the client html.
app.get '/', (req, res) ->
  res.sendfile __dirname + '/public/client.html'


app.listen 7076, -> console.log "server at localhost:7076"



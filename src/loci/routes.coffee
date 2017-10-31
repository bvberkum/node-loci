module.exports = ( ctx ) ->

  ctx.io.sockets.on 'connection', ( socket ) ->
    console.log 'socket conn est'

    socket.on 'echo', ( req, res ) ->
      console.log 'socket received echo', arguments

    socket.on 'ready', ( req, res ) ->
      console.log 'socket received ready', arguments
      ctx.io.sockets.emit 'talk',
        message: 'io event from an io route on the server'


  app = ctx.app

  app.all '/tree', ( req, res ) ->
    ctx.io.sockets.emit 'tree'
    res.json result: "tree sent over IO"

  app.all '/graph', ( req, res ) ->
    ctx.io.sockets.emit 'graph'
    res.json result: "graph sent over IO"

  # Send the client html.
  app.get '/client.html', (req, res) ->
    console.log 'Serving client'
    res.sendfile 'public/client.html'

  app.get '/', ( req, res ) ->
    res.redirect '/client.html'

  proc = ctx.proc[process.pid]
  app.use ctx.static_proto proc.noderoot+'/public'

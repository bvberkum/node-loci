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

  ctx.redir '/', '/graph.html'

  app.all '/tree', ( req, res ) ->
    ctx.io.sockets.emit 'tree'
    res.json result: "tree sent over IO"

  app.all '/graph.html', ( req, res ) ->
    res.render 'client/graph.pug', ctx.tpld req

  app.all '/vendor/:pack.:ext', ( req, res ) ->
    ps = req.params ; p = ctx.cdn[ps.ext]["http"]
    res.redirect p.packages[ps.pack]+p.ext

  app.all '/client', ( req, res ) ->
    res.render 'client/main.pug'

  app.all '/client/slideshow', ( req, res ) ->
    res.render 'client/slideshow.pug'
    #urlFile = req.query.list || loci.default_settings().load_urls
    #params.page.title = urlFile+" - Loci"
    #console.log "Serving /client/slideshow for", urlFile
    #params.urlList = loci.load_urls( urlFile )

  app.get '/index.html', (req, res) ->
    res.render 'index.pug', ( err, html ) ->
      if err
        res.status 500
      else
        res.type 'html'
        res.write html
      res.end()

  ctx.redir '/client.html', '/socket-test.html'

  app.get '/socket-test.html', (req, res) ->
    res.render 'socket-test.pug', ( err, html ) ->
      if err
        res.status 500
      else
        res.type 'html'
        res.write html
      res.end()

  app.get '/favicon.ico', (req, res) ->
    res.sendfile 'assets/favicon-clone.ico'

  proc = ctx.proc[process.pid]
  app.use ctx.static_proto proc.noderoot+'/public'

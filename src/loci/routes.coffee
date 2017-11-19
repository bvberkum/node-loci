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


  # Basic site routers

  app.all '/vendor/:pack.:ext', ( req, res ) ->
    rp = req.params ; p = ctx.cdn[rp.ext]["http"]
    res.redirect p.packages[rp.pack]+p.ext

  app.get '/favicon.ico', (req, res) ->
    res.sendfile 'assets/favicon-clone-e64a19.ico'


  # Main pages

  ctx.redir '/', '/tree'


  client_ctx = ctx.getSub
    route: head: rjs: [ 'loci-rjs-app' ]

  app.all '/main', ( req, res ) ->
    res.render 'client/main.pug', client_ctx.tpld req

  client_cfg =
    paths: ctx.cdn.js.http.packages
    shim: ctx.deps.shim
    map: ctx.deps.map
    baseUrl: '/app'
    deps: ["require-css","cs!loci/main"]

  app.get '/app/loci/config.json', ( req, res ) ->
    res.json client_cfg

  app.get '/app/loci/rjs.js', ( req, res ) ->
    res.type "js"
    client_cfg_json = ctx.add_shim_inits JSON.stringify client_cfg
    #client_cfg_json = JSON.stringify client_cfg
    res.write "requirejs.config(#{client_cfg_json});"
    res.end()

  app.get '/app/:vendor/:path.coffee', ( req, res ) ->
    rp = req.params
    res.sendfile "src/#{rp.vendor}/app/#{rp.path}.coffee"

  app.get '/app/:vendor/:path.js', ctx.serve_vendor


  # Hypertext interface
  app.all '/tree', ( req, res ) ->
    res.render 'client/tree.pug', ctx.tpld req

  # Graphical interface
  app.all '/graph', ( req, res ) ->
    res.render 'client/graph.pug', ctx.tpld req



  app.all '/data', ( req, res ) ->
    res.sendfile "data.yml"


  # Testing

  app.all '/msg', ( req, res ) ->
    ctx.msg.sockets.emit 'msg'
    res.msg result: "msg sent over IO"

  app.all '/site', ( req, res ) ->
    res.render 'client/site.pug', ctx.tpld req

  app.all '/slideshow', ( req, res ) ->
    res.render 'client/slideshow.pug', ctx.tpld req
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

  app.get '/socket-test.html', (req, res) ->
    res.render 'socket-test.pug', ( err, html ) ->
      if err
        res.status 500
      else
        res.type 'html'
        res.write html
      res.end()


  proc = ctx.proc[process.pid]
  app.use ctx.static_proto proc.noderoot+'/public'

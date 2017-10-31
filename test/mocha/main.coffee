request = require 'request'
fs = require 'fs'
cli = require '../../bin/loci-cli.coffee'
lib = require '../../src/loci'

chai = require 'chai'
chai.should()
expect = chai.expect


describe "node-loci", ->

  base = null
  app = null
  server = null
  sessionCookie = null

  reqInit = ( path, method='GET' ) ->
    host: "localhost"
    port: base.config.port || 7000
    path: path
    method: 'GET'
    headers:
      Cookie: sessionCookie

  before ( done ) ->
    app = lib.run_main cli.base, {}, ->
      base = cli.base
      app = cli.base.app
      server = cli.base.server
      done()

  after ( done ) ->
    server.close()
    !done || done()


  it "runs a Socket.IO enabled Express app", ( done ) ->

    expect( app ).to.be.an.object

    sio_url = "http://localhost:#{base.config.port}/socket.io/socket.io.js"

    request.get sio_url, ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      done()

  it "serves a static HTML client", ( done ) ->
    req = uri: "http://localhost:#{base.config.port}/client.html"
    request.get req, ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      client = fs.readFileSync 'public/client.html'
      expect( res.body.toString() ).to.equal client.toString()

      done()

  it "redirects to HTML client", ( done ) ->
    req =
      url: "http://localhost:#{base.config.port}/"
      followRedirect: false
    request req, ( err, res, body ) ->

      expect( res.headers['location'] ).to.equal '/client.html'
      expect( res.statusMessage ).to.equal 'Found' #Moved Temporarily'
      expect( res.statusCode ).to.equal 302 #301

      done()

request = require 'request'
fs = require 'fs'

chai = require 'chai'
chai.should()
expect = chai.expect


pathResolve = ( path ) ->
  require.resolve process.cwd(), path


describe "node-expressio-seed-mpe", ->

  server = null
  sessionCookie = null

  reqInit = ( path, method='GET' ) ->
    host: "localhost"
    port: server.port || 7000
    path: path
    method: 'GET'
    headers:
      Cookie: sessionCookie

  before ( done ) ->
    server = require pathResolve 'server'
    server.init done

  after ( done ) ->
    server.proc.close()
    done()


  it "runs a Socket.IO enabled Express app", ( done ) ->

    expect( server.app ).to.be.an.object

    sio_url = "http://localhost:#{server.port}/socket.io/socket.io.js"
    request.get sio_url, ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      done()

  it "serves a static HTML client", ( done ) ->
    req = uri: "http://localhost:#{server.port}/client.html"
    request.get req, ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      client = fs.readFileSync 'public/client.html'
      expect( res.body.toString() ).to.equal client.toString()

      done()

  it "redirects to HTML client", ( done ) ->
    req =
      url: "http://localhost:#{server.port}/"
      followRedirect: false
    request req, ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'Moved Temporarily'
      expect( res.headers['location'] ).to.equal '/client.html'
      expect( res.statusCode ).to.equal 302

      done()



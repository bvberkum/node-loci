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


  it "runs a Socket.IO enabled Express app,
      serving a HTML client at the root", ( done ) ->

    expect( server.app ).to.be.an.object

    request.get "http://localhost:#{server.port}", ( err, res, body ) ->

      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      client = fs.readFileSync 'public/client.html'
      expect( res.body.toString() ).to.equal client.toString()
      done()



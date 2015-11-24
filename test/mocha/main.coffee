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


  before ( done ) ->
    server = require pathResolve 'server'
    server.init done

  after ( done ) ->
    server.proc.close()
    done()


  it "runs a Socket.IO enabled Express app", ( done ) ->

    expect( server.port ).to.be.a.number
    expect( server.app ).to.be.an.object

    sio_url = "http://localhost:#{server.port}/socket.io/socket.io.js"
    request.get sio_url, ( err, res, body ) ->

      expect( res.statusCode ).to.equal 200
      expect( res.headers['content-type'] ).to.equal 'application/javascript'
#      expect( res.statusMessage ).to.equal 'OK'

      done()


  it "serves a HTML client at the root", ( done ) ->
    request.get "http://localhost:#{server.port}", ( err, res, body ) ->

      expect( res.statusCode ).to.equal 200
      expect( res.headers['content-length'] ).to.equal '215'
      expect( res.headers['content-type'] ).to.equal 'text/html; charset=UTF-8'
#      expect( res.statusMessage ).to.equal 'OK'

      client = fs.readFileSync 'public/client.html'
      expect( res.body.toString() ).to.equal client.toString()

      done()



request = require 'request'
fs = require 'fs'

chai = require 'chai'
chai.should()
expect = chai.expect


pathResolve = ( path ) ->
  require.resolve process.cwd(), path


describe "node-expressio-seed-mpe", ->

  server = null

  before ( done ) ->
    server = require pathResolve 'server'
    server.port = 7002
    server.init done

  after ( done ) ->
    server.proc.close()
    done()


  it "runs a Socket.IO enabled Express app", ( done ) ->

    expect( server.app ).to.be.an.object

    req = url: "http://localhost:#{server.port}/socket.io/socket.io.js"
    request.get req, ( err, res, body ) ->

      expect( !err )
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      done()

  it "redirects to HTML client", ( done ) ->
    req =
      url: "http://localhost:#{server.port}/"
      followRedirect: false
    request req, ( err, res, body ) ->

      expect( !err )
      expect( res.statusMessage ).to.equal 'Moved Temporarily'
      expect( res.statusCode ).to.equal 302

      done()

  it "serves a HTML client", ( done ) ->
    req = uri: "http://localhost:#{server.port}/"
    request.get req, ( err, res, body ) ->

      expect( !err )
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200

      expect( res.body.toString() ).to.contain '<!DOCTYPE html>'
      expect( res.body.toString() ).to.contain '<title>Loci</title>'
      done()



path = require 'path'
fs = require 'fs'
_ = require 'lodash'


read_file = ( filename ) ->
  data = fs.readFileSync filename
  lines = _.union data.toString().split '\n'
  _.map lines, ( line, idx ) ->
    if line
      id: idx
      url: line


module.exports = ( app, list ) ->

  be_file = list
  lines = read_file be_file

  app.io.route 'use', ( req ) ->
    be_file = req.data
    lines = read_file be_file


  app.get '/loci/data', ( req, res ) ->
    res.write JSON.stringify lines
    res.end()

  app.get '/loci/data/:id', ( req, res ) ->
    res.end()

  app.post '/loci/data', ( req, res ) ->
    res.end()

  app.put '/loci/data/:id', ( req, res ) ->
    res.end()

  app.delete '/loci/data/:id', ( req, res ) ->
    res.end()


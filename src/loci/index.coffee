fs = require 'fs'
_ = require 'lodash'
module.exports =
	default_settings: ( seed={} ) ->
		_.defaults seed,
			load_urls: 'urls.list'
	load_urls: ( file ) ->
		data = fs.readFileSync file
		lines = data.toString().split "\n"
		urls = []
		for line in lines
			if line and line.match and line.match '^[a-z0-9-]+\:\/\/[^/]+/.*$'
				[ url, params ] = line.split '#'
				urls.push url
		urls


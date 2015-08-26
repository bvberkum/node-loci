fs = require 'fs'
module.exports =
	load_urls: ( file ) ->
		data = fs.readFileSync file
		lines = data.toString().split "\n"
		urls = []
		for line in lines
			if line and line.match and line.match '^[a-z0-9-]+\:\/\/[^/]+/.*$'
				[ url, params ] = line.split '#'
				urls.push url
		urls


http = require "http"
parser = require "xml2json"
module.exports = (req, res)->
	output = 
		status: null
		message: null
		posts: []
	if req.query.id? || req.query.custom?
		tumblr = 
			host: null
			path: null
		if req.query.id?
			tumblr.host = "#{req.query.id}.tumblr.com"
		else
			tumblr.host = req.query.custom
		tumblr.path = "/api/read?type=photo"
		http.get tumblr, (stream)->
			tumblog = ""
			stream.on "data", (data)->
				tumblog += data
			stream.on "end", ->
				if tumblog.match("DOCTYPE html") isnt null
					output.status = "Error"
					output.message = "XML data is not found. Maybe miss id or domain."
				else 
					tumblog = JSON.parse parser.toJson(tumblog)
					if tumblog.posts is null
						output.status = "Error"
						output.message = "Post data is not found. Maybe blank tumblog."
					else
						for post in tumblog.tumblr.posts.post
							outpost =
								id: post.id
								photo_url: post["photo-url"][0]["$t"]
								reblog_key: post["reblog-key"]
							output.posts.push outpost
						output.status = "success"
				res.send JSON.stringify(output)
	else
		output.status = "Error"
		output.message = "ID or domain is not found"
		res.send JSON.stringify(output)
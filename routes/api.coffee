http = require "http"
parser = require "xml2json"

module.exports = (req, res)->
	self = this
	output = 
		status: null
		message: null
		posts: []
	
	if (req.query.id? and req.query.id isnt "") or (req.query.custom? and req.query.custom isnt "")
		tumblr = 
			host: null
			path: null

		if req.query.id?
			tumblr.host = "#{req.query.id}.tumblr.com"
		else
			tumblr.host = req.query.custom
		
		req.query.size = parseInt(req.query.size)
		req.query.size = 500 if req.query.size isnt 1280
		
		if req.query.random is "1"
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
						req.query.page = (Math.floor(Math.random() * (parseInt(tumblog.tumblr.posts.total))) - 20)
						getTumblog output, tumblr, req.query, (output)->
							res.send JSON.stringify(output)
				stream.on "error", (err)->
					console.log err
					output.status = "Error"
					output.message = "tumblog load error"
					res.send JSON.stringify(output)
		else
			getTumblog output, tumblr, req.query, (output)->
				res.send JSON.stringify(output)
	else
		output.status = "Error"
		output.message = "ID or domain is not found"
		res.send JSON.stringify(output)

	this

getTumblog = (output, tumblr, query, callback)->
	tumblr.path = "/api/read?type=photo&start=#{query.page}&num=20"
	http.get(tumblr, (stream)->
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
							photo_url: null
							reblog_key: post["reblog-key"]
						if query.size is 1280
							outpost.photo_url = post["photo-url"][0]["$t"]
						else
							outpost.photo_url = post["photo-url"][1]["$t"]
						output.posts.push outpost
					output.status = "success"
			callback output
	).on "error", (err)->
		console.log err
		output.status = "error"
		callback output

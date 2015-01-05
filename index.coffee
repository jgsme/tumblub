express = require 'express'
coffee  = require 'coffee-middleware'
stylus  = require('stylus').middleware
request = require 'request'

url = (id)-> "http://api.tumblr.com/v2/blog/#{id}/posts/photo?api_key=#{process.env.TUMBLR_API_KEY}"
crawl = (id, callback)-> request "#{url(id)}&limit=1", (err, res, body)->
  body = JSON.parse body
  if body.meta.status is 200
    total = parseInt body.response.total_posts
    if total > 20 then total -= 20
    request "#{url(id)}&offset=#{Math.floor(Math.random() * total)}", (err, res, body)->
      photos = JSON.parse(body).response.posts.map (post)-> {id: post.id, photos: post.photos}
      callback err, photos
  else
    if /\.tumblr\.com/.test id then callback new Error 'ID not found' else crawl "#{id}.tumblr.com", callback

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use coffee({ src: "#{__dirname}/public"})
app.use stylus({ src: "#{__dirname}/public" })
app.use express.static("#{__dirname}/public")
app.use (err, req, res, next)->
  console.log err
  res.send 500, 'Internal Serer Error!'

app.get '/', (req, res)-> res.render 'index'
app.get '/show', (req, res)-> res.render 'show'
app.get '/api/:id', (req, res)-> crawl req.params.id, (err, posts)-> if err? then res.status(404).send 'Not found' else res.json posts

server = app.listen app.get('port'), -> console.log "Listening port at: #{app.get('port')}"

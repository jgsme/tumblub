express = require 'express'
routes = require './routes'
coffee = require 'coffee-middleware'
stylus = require('stylus').middleware
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

app.get '/', routes.index
app.get '/show', routes.show
app.get '/api', routes.api

server = app.listen app.get('port'), -> console.log "Listening port at: #{app.get('port')}"

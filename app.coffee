http = require "http"
express = require "express"
routes = require "./routes"
path = require "path"
app = express()
server = http.createServer app

app.configure ->
	app.set "port", process.env.PORT || 3000
	app.set "views", __dirname + '/views'
	app.set "view engine", "jade"
	app.use express.logger "dev"
	app.use app.router
	app.use express.static(path.join __dirname, "public")

app.configure "development", ->
	app.use express.errorHandler()

app.get "/", routes.index

app.get "/show", routes.show

app.get "/api", routes.api

server.listen app.get("port"), ->
	console.log "Listening port at: #{app.get("port")}"

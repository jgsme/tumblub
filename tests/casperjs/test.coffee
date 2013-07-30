casper = require("casper").create()

casper.start "http://localhost:4545", ->
	@echo @getHTML()

casper.run()

# grut config
module.exports = (grunt)->
	grunt.initConfig
		pkg: "<json:package.json>"
		coffee:
			app:
				files:
					"app.js": "app.coffee"
				options:
					bare: true
			routes:
				files:
					"routes/index.js": "routes/index.coffee"
					"routes/show.js": "routes/show.coffee"
					"routes/api.js": "routes/api.coffee"
				options:
					bare: true
			client:
				files:
					"public/javascripts/viewer.js": "viewer.coffee"
				options:
					bare: true
		copy:
			javascripts:
				files:
					"public/javascripts/jquery.js": "bower_components/jquery/jquery.min.js"
					"public/javascripts/knockout.js": "bower_components/knockout/knockout.js"

		grunt.loadNpmTasks "grunt-contrib-coffee"
		
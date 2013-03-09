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
		watch:
			files: ["*.coffee"]
			tasks: "coffee"

		grunt.loadNpmTasks "grunt-contrib"

		grunt.registerTask "default", "watch"
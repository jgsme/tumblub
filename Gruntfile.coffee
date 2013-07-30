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
			tests:
				files:
					"tests/casperjs/test.js": "tests/casperjs/test.coffee"
				options:
					bare: true

		casperjs:
			files: ["tests/casperjs/*.js"]

		grunt.loadNpmTasks "grunt-contrib-coffee"
		grunt.loadNpmTasks "grunt-casperjs"

		grunt.registerTask "test", ["coffee", "casperjs"]
		
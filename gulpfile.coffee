gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
stylus = require 'gulp-stylus'

gulp.task 'browserify', ->
  browserify
    entries: ['./src/index.coffee']
    extensions: ['.coffee']
  .bundle()
  .pipe source 'index.js'
  .pipe gulp.dest 'public'

gulp.task 'stylus', ->
  gulp.src 'src/*.styl'
    .pipe stylus()
    .pipe gulp.dest 'public'

gulp.task 'default', ['browserify', 'stylus']

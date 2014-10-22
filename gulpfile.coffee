gulp = require 'gulp'
sass = require 'gulp-ruby-sass'
autoprefixer = require 'gulp-autoprefixer'
minifycss = require 'gulp-minify-css'
rename = require 'gulp-rename'

gulp.task 'express', ->
  express = require('express')
  app = express()
  app.use(require('connect-livereload')({port: 4002}))
  app.use(express.static(__dirname))
  app.listen(4000)

tinylr = require('tiny-lr')()
gulp.task 'livereload', ->
  tinylr.listen(4002)

notifyLiveReload = (event) ->
  fileName = require('path').relative(__dirname, event.path)

  tinylr.changed({
    body: {
      files: [fileName]
    }
  })

gulp.task 'styles', ->
  return gulp.src('sass/*.scss')
    .pipe(sass({ style: 'expanded' }))
    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1'))
    .pipe(gulp.dest('css'))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss())
    .pipe(gulp.dest('css'))

gulp.task 'watch', ->
  gulp.watch('sass/*.scss', ['styles'])
  gulp.watch('*.html', notifyLiveReload)
  gulp.watch('css/*.css', notifyLiveReload)

gulp.task 'default', ['styles', 'express', 'livereload', 'watch']

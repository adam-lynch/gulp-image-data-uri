gulp = require 'gulp'
$ = require('gulp-load-plugins')()

gulp.task 'default', ['compile']

gulp.task 'compile', ->
    gulp.src 'index.coffee'
        .pipe $.coffee
            bare: true
        .pipe gulp.dest './'

gulp.task 'test', ->
    gulp.src 'test/*.coffee'
        .pipe $.mocha
            reporter: 'spec'

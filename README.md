gulp-image-data-uri [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][depstat-image]][depstat-url]
=====================

Not ready yet 
===

A [Gulp](http://github.com/gulpjs/gulp) plugin for converting images to inline data-URIs. Intended to be a simple single-purpose wrapper for [heldr/datauri](https://github.com/heldr/datauri).

# Installation
```js
npm install gulp-image-data-uri
```

# Usage
```js
var gulp = require('gulp');
var imageDataURI = require('gulp-image-data-uri');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI()) 
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```

For example output, see [test/expected](test/expected). See [Examples](#examples) for more information. 

# Options

### customClass

An optional function. If not passed, the class added is just the file's basename.

The function is called with two arguments; the default class name and the [Vinyl](http://github.com/wearefractal/vinyl) file object. See [Examples](#examples) for more information.

The function must *return* the new class (string). 


# Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

# Examples

## Example output

For example output, see [test/expected](test/expected).

## Combining into one CSS file

Use [gulp-concat](https://github.com/wearefractal/gulp-concat);

```javascript   
var gulp = require('gulp');
var imageDataURI = require('gulp-image-data-uri');
var concat = require('concat');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI()) 
        .pipe(concat('inline-images.css')) 
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
``` 

## Custom classes

```javascript   
var gulp = require('gulp');
var imageDataURI = require('gulp-image-data-uri');
var path = require('path');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI({
            customClass: function(className, file){
                var customClass = 'icons-' + className; // add prefix

                // add suffix if the file is a GIF
                if(path.extname(file.path) === '.gif'){
                    customClass += '-gif';
                }
                         
                return customClass;
            }
        )) 
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```                     

## Only convert certain file types

Use [gulp-filter](https://github.com/sindresorhus/gulp-filter);

```javascript   
var gulp = require('gulp');
var imageDataURI = require('gulp-image-data-uri');
var filter = require('gulp-filter');

gulp.task('prepare', function() {
    var pngFilter = filter('*.png'); 

    gulp.src('./images/*')
        .pipe(pngFilter) 
        .pipe(imageDataURI()) 
        .pipe(gulp.dest('./css')) // put the CSS generated somewhere
        .pipe(pngFilter.restore()) 
        .pipe(gulp.dest('./dist')); // put the images somewhere else
});

gulp.task('default', ['prepare']);
``` 

## Custom CSS

This isn't possible right now because [heldr/datauri](https://github.com/heldr/datauri) doesn't support it. If you want this feature, comment on [heldr/datauri#6](https://github.com/heldr/datauri/issues/6).  

## Anything missing?

Create an [issue](https://github.com/adam-lynch/gulp-image-data-uri/issues) / [pull-request](https://github.com/adam-lynch/gulp-image-data-uri/pulls) :smiley:.

[npm-url]: https://npmjs.org/package/gulp-image-data-uri
[npm-image]: http://img.shields.io/npm/v/gulp-image-data-uri.svg?style=flat

[travis-url]: http://travis-ci.org/adam-lynch/gulp-image-data-uri
[travis-image]: http://img.shields.io/travis/adam-lynch/gulp-image-data-uri.svg?style=flat

[depstat-url]: https://david-dm.org/adam-lynch/gulp-image-data-uri
[depstat-image]: https://david-dm.org/adam-lynch/gulp-image-data-uri.svg?style=flat

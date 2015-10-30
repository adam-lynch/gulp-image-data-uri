gulp-image-data-uri 
==========

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Windows Build Status][appveyor-image]][appveyor-url] [![Dependency Status][depstat-image]][depstat-url] 

---

A [Gulp](http://github.com/gulpjs/gulp) plugin for converting images to inline data-URIs. Intended to be a simple single-purpose wrapper for [heldr/datauri](https://github.com/heldr/datauri) (well, [datauri.template](https://github.com/heldr/datauri.template)).

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

An optional function. If omitted, the class added is just the file's basename.

The function is called with two arguments; the default class name and the [Vinyl](http://github.com/wearefractal/vinyl) file object. It must *return* the new class (string). See [Examples](#examples) for more information.

### template

An optional object. See the [Custom CSS examples](#custom-CSS) below.

#### template.file

A string which is a path to a template file (note: this doesn't have to be a `.css` file). This must be given if you want to use a custom template. An example file:

```css
.{{className}} {
    background: url("{{dataURISchema}}");
}
```

The `className` and `dataURISchema` variables will always be passed to your template.

- `className` is the name of the file or if you use the `customClass` option then it's whatever your function returns.
- `dataURISchema` is the data URI.

### template.variables

An optional object of variable names to variables like this:

```javascript
{
    defaultMargin: '.1rem'
}
```

These will be passed to your template along with the `className` and `dataURISchema` variables this module gives you (these are reserved variables).

### template.engine

An optional function which accepts the data (as an object) as its only parameter and returns a string.

Consider lodash.template as example. If your favorite templating engine does support a compile + render shorthand, you just need to point the handler after a given template path, otherwise you will need to create a template adapter.

### template.adapter

An optional function which accepts which accepts the the template content (string) as its only parameter and returns a template function (or engine).

Some templating engines does not have a shorthand to compile + render at the same call. In this specific cases we can create a template wrapper as the example bellow:

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
var concat = require('gulp-concat');

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

## Including / excluding certain images

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
        .pipe(gulp.dest('./dist')); // also put all of the images somewhere else
});

gulp.task('default', ['prepare']);
``` 

## Custom CSS

These examples expand on the [Combining into one CSS file](#combining-into-one-css-file) example but you don't have to concatenate them if you like.

### Custom template

```javascript
var gulp = require('gulp');
var concat = require('gulp-concat');
var imageDataURI = require('gulp-image-data-uri');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI({
            template: {
                file: './other/data-uri-template.css'
            }
        }))
        .pipe(concat('inline-images.css'))
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```

Let's say 'data-uri-template.css' contains something like this:

```css
.{{className}} {
    background: url("{{dataURISchema}}");
}
```

Then the result would be something like:

```css
.image-flag {
    background: url("data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
}
```


### Custom template with variables

```javascript
var gulp = require('gulp');
var concat = require('gulp-concat');
var imageDataURI = require('gulp-image-data-uri');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI({
            template: {
                file: './other/data-uri-template.css',
                variables: {
                    defaultMargin: '10px'
                }
            }
        }))
        .pipe(concat('inline-images.css'))
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```

Let's say 'data-uri-template.css' contains something like this:

```css
.{{className}} {
    background: url("{{dataURISchema}}");
    margin: {{defaultMargin}};
}
```

Then the result would be something like:

```css
.image-flag {
    background: url("data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
    margin: 10px;
}
```

### Custom template and templating engine

In this example, [lodash](https://lodash.com/).template is used as the templating engine.

```javascript
var gulp = require('gulp');
var concat = require('gulp-concat');
var imageDataURI = require('gulp-image-data-uri');
var _ = require('lodash'); // or lodash.template for custom builds

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI({
            template: {
                file: './other/data-uri-template.css',
                engine: _.template
            }
        }))
        .pipe(concat('inline-images.css'))
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```

Let's say 'data-uri-template.css' contains something like this:

```css
.<%= className %> {
    background: url("<%= dataURISchema %>");
}
```

Then the result would be something like:

```css
.image-flag {
    background: url("data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
}
```

### Custom template and template adapter

In this example, [handlebars](http://handlebarsjs.com/) is used as the templating engine (via the `template.adapter` option).

```javascript
var gulp = require('gulp');
var concat = require('gulp-concat');
var imageDataURI = require('gulp-image-data-uri');
var handlebars = require('handlebars');

gulp.task('prepare', function() {
    gulp.src('./images/*')
        .pipe(imageDataURI({
            template: {
                file: './other/data-uri-template.css',
                adapter: function (templateContent) {
                     var tpl = handlebars.compile(templateContent);

                     // bind is used to ensure scope
                     return tpl.bind(handlebars);
                 }
            }
        }))
        .pipe(concat('inline-images.css'))
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['prepare']);
```

## Anything missing?

Create an [issue](https://github.com/adam-lynch/gulp-image-data-uri/issues) / [pull-request](https://github.com/adam-lynch/gulp-image-data-uri/pulls) :smiley:.

[npm-url]: https://npmjs.org/package/gulp-image-data-uri
[npm-image]: http://img.shields.io/npm/v/gulp-image-data-uri.svg?style=flat

[travis-url]: http://travis-ci.org/adam-lynch/gulp-image-data-uri
[travis-image]: http://img.shields.io/travis/adam-lynch/gulp-image-data-uri.svg?style=flat

[appveyor-url]: https://ci.appveyor.com/project/adam-lynch/gulp-image-data-uri/branch/master
[appveyor-image]: https://ci.appveyor.com/api/projects/status/f34nrrstjmctvuj0/branch/master?svg=true

[depstat-url]: https://david-dm.org/adam-lynch/gulp-image-data-uri
[depstat-image]: https://david-dm.org/adam-lynch/gulp-image-data-uri.svg?style=flat

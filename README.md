gulp-image-data-uri 
==========

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Windows Build Status][appveyor-image]][appveyor-url] [![Dependency Status][depstat-image]][depstat-url] 

---

A [Gulp](http://github.com/gulpjs/gulp) plugin for converting images to inline data-URIs. Intended to be a simple single-purpose wrapper for [heldr/datauri](https://github.com/heldr/datauri) (well, [datauri.template](https://github.com/heldr/datauri.template)).

# Installation
```js
npm install gulp-image-data-uri
```

# Usage for Gulp ^4.0.0
```js
const gulp = require('gulp'),
      imageDataURI = require('gulp-image-data-uri');

// path variables
var imgSrc = 'src/img/*',
    cssDist = 'dist/css/',

// the task
exports.datauri = function () {
    return src (imgSrc)
    .pipe(imageDataURI())
    .pipe(dest(cssDist))
}
```

# The Ol' fashion way
**Reminder:** The [`task()`](https://gulpjs.com/docs/en/api/task) API isn't the recommended pattern anymore - export your tasks as shown above.

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

An optional object. See the [Custom CSS template examples](#custom-css-templates) below.

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

Note: `classNameSuffix` is also reserved (by a module used underneath) but don't use it.

### template.variables

An optional object of variable names to variables like this:

```javascript
{
    defaultMargin: '.1rem'
}
```

These will be passed to your template along with the `className`, `dataURISchema` and `classNameSuffix` variables this module gives you (these are reserved variables).

### template.engine

An optional function which accepts the data (as an object) as its only parameter and returns a string.

Consider lodash.template as example. If your favorite templating engine does support a compile + render shorthand, you just need to point the handler after a given template path, otherwise you will need to create a template adapter.

### template.adapter

An optional function which accepts which accepts the the template content (string) as its only parameter and returns a template function (or engine).

Some templating engines does not have a shorthand to compile + render at the same call. In this specific cases we can create a template wrapper as the example bellow:


# Examples

For example output, see [test/expected](test/expected).

- [Combining into one CSS file](examples/combine-into-one-css-file.md)
- [Custom classes](examples/custom-classes.md)
- [Including / excluding certain images](examples/including-or-excluding-certain-images.md)

## Custom CSS templates

These examples expand on the [Combining into one CSS file](examples/combine-into-one-css-file.md) example but you don't have to concatenate them if you like.

- [Custom template](examples/custom-template.md)
- [Custom template with variables](examples/custom-template-with-variables.md)
- [Custom template and templating engine](examples/custom-template-and-templating-engine.md)
- [Custom template and template adapter](examples/custom-template-and-template-adapter.md)

# Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

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

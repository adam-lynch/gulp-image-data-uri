# Including / excluding certain images

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

---

[Back to readme](../readme)
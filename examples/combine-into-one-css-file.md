# Combining into one CSS file

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

---

[Back to readme](../readme)
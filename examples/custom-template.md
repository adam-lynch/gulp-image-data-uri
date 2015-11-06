# Custom template

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

---

[Back to readme](../readme)
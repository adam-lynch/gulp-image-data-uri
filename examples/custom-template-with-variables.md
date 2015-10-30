# Custom template with variables

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

---

[Back to readme](../readme)
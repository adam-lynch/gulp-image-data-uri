# Custom classes

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

---

[Back to readme](../readme)
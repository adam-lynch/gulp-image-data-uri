# Custom template and template adapter

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

---

[Back to readme](../readme)
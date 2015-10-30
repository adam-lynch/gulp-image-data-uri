through = require 'through2'
path = require 'path'
DataURI = require 'datauri.template'
gutil = require 'gulp-util'
PluginError = gutil.PluginError
pluginName = 'gulp-image-data-uri'

module.exports = (options) ->

    options = {} unless options?

    through.obj (file, enc, cb) ->
        # pass through null files
        if file.isNull()
            cb null, file
            return

        # don't support stream for now
        if file.isStream()
            cb new PluginError pluginName, 'Streaming not supported'
            return

        dataURI = new DataURI()
        dataURI.format path.basename(file.path), file.contents

        basename = path.basename file.path, path.extname file.path
        className = basename
        className = options.customClass className, file if options.customClass?

        file.contents = new Buffer dataURI.getCss className
        file.path = path.join path.dirname(file.path), basename + '.css'
        this.push file

        cb()
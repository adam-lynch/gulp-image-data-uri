through = require 'through2'
path = require 'path'
DataURI = require 'datauri'
gutil = require 'gulp-util'
PluginError = gutil.PluginError
pluginName = 'gulp-image-data-uri'

module.exports = (options) ->

    options = {} unless options?
    concatenated = ''
    firstFile = null

    each = (file, enc, cb) ->
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

        css = new Buffer dataURI.getCss className

        if options.concatFilename
            concatenated += css
            firstFile = file unless firstFile
        else
            file.contents = css
            file.path = path.join path.dirname(file.path), basename + '.css'
            this.push file

        cb()

    end = ->
        if options.concatFilename
            concatenatedFile = firstFile.clone
                contents: false
            concatenatedFile.path = path.join firstFile.base, options.concatFilename
            concatenatedFile.contents = new Buffer concatenated
            this.push concatenatedFile

        this.emit 'end'

    through.obj each, end
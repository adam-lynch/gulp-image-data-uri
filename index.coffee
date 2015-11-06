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
        if file.isNull() or !file.contents.toString().length
            cb null, file
            return

        # don't support stream for now
        if file.isStream()
            cb new PluginError pluginName, 'Streaming not supported'
            return

        dataURI = new DataURI()
        dataURI.format path.basename(file.path), file.contents

        basename = path.basename file.path, path.extname file.path

        # customClass option
        className = basename
        className = options.customClass className, file if options.customClass?

        # Handle custom CSS templates
        if options.template?.file?
            dataURI.templateAdapter = options.template.adapter if options.template.adapter?

            # This is awkward but needed because datauri.template takes weird optional arguments instead of an object
            dataURIArgs = [
                options.template.file
            ]

            # Only pass a custom engine if an adapter wasn't given
            dataURIArgs.push options.template.engine if !options.template.adapter? and options.template.engine?

            variables = options.template.variables ? {}
            variables.className = className
            dataURIArgs.push variables

            fileContents = dataURI.template.apply dataURI, dataURIArgs

        else
            # Use our default template if none is given
            fileContents = dataURI.template './template.css',
                className: className

        file.contents = new Buffer fileContents
        file.path = path.join path.dirname(file.path), basename + '.css'
        this.push file

        cb()
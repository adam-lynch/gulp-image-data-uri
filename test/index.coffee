chai = require 'chai'
expect = chai.expect
assert = chai.assert
eol = require 'eol'
fs = require 'fs'
path = require 'path'
globToVinyl = require 'glob-to-vinyl'
imageDataURI = require '../index.coffee'

normalizeLineEndings = -> eol.lf.apply this, arguments

describe 'gulp-platform-overrides', ->

    test = (lineEndings, done) ->
        normalizeLineEndings = -> eol[lineEndings].apply this, arguments

        stream = imageDataURI()

        globToVinyl ['./test/fixtures/*', '!**/empty.png'], (err, fixtures) ->
            throw err if err
            fixtures.forEach (fixture) ->
                stream.write fixture
            stream.end()

            numberOfResultFiles = 0

            stream.on 'data', (resultFile) ->
                basename = path.basename resultFile.path
                expect(path.extname resultFile.path).to.equal '.css'

                globToVinyl './test/expected/basic/' + basename, (err, expectedFiles) ->
                    throw err if err
                    assert.fail null, null, "'expected/basic/#{basename}' not found" unless expectedFiles.length
                    a = normalizeLineEndings(resultFile.contents.toString()) #.substr(0, 10)
                    b = normalizeLineEndings(expectedFiles[0].contents.toString()) #.substr(0, 10)

#                    console.log a
#                    console.log b

                    expect(a).to.equal b
                    numberOfResultFiles++
                    done() if numberOfResultFiles is fixtures.length

    it "auto", (done) -> test 'auto', done
    it "lf", (done) -> test 'lf', done
    it "crlf", (done) -> test 'crlf', done
    it "cr", (done) -> test 'cr', done
#    it 'a', ->
#        fs.writeFileSync './test/expected/basic/double_gulp.css', new Buffer eol.auto fs.readFileSync('./test/expected/basic/double_gulp.css').toString()


#    it "should convert images to data URI CSS, one output file per input", (done) ->
#
#        stream = imageDataURI()
#
#        globToVinyl ['./test/fixtures/*', '!**/empty.png'], (err, fixtures) ->
#            throw err if err
#            fixtures.forEach (fixture) ->
#                stream.write fixture
#            stream.end()
#
#            numberOfResultFiles = 0
#
#            stream.on 'data', (resultFile) ->
#                basename = path.basename resultFile.path
#                expect(path.extname resultFile.path).to.equal '.css'
#
#                globToVinyl './test/expected/basic/' + basename, (err, expectedFiles) ->
#                    throw err if err
#                    assert.fail null, null, "'expected/basic/#{basename}' not found" unless expectedFiles.length
#                    expect(normalizeLineEndings resultFile.contents.toString()).to.equal normalizeLineEndings expectedFiles[0].contents.toString()
#                    numberOfResultFiles++
#                    done() if numberOfResultFiles is fixtures.length


#    it "should skip empty files", (done) ->
#        stream = imageDataURI()
#
#        globToVinyl './test/fixtures/empty.png', (err, fixtures) ->
#            throw err if err
#            fixture = fixtures[0]
#            stream.write fixture
#            stream.end()
#
#            stream.on 'data', (resultFile) ->
#                expect(resultFile.path).to.equal fixture.path
#                expect(normalizeLineEndings resultFile.contents.toString()).to.equal normalizeLineEndings fixture.contents.toString()
#                done()
#
#
#    describe 'options.customClass', ->
#
#        it "should add custom class prefix", (done) ->
#            stream = imageDataURI
#                customClass: (className) -> 'prefix-' + className
#
#            globToVinyl ['./test/fixtures/*', '!**/empty.png'], (err, fixtures) ->
#                throw err if err
#                fixtures.forEach (fixture) ->
#                    stream.write fixture
#                stream.end()
#
#                numberOfResultFiles = 0
#
#                stream.on 'data', (resultFile) ->
#                    basename = path.basename resultFile.path
#                    expect(path.extname resultFile.path).to.equal '.css'
#
#                    globToVinyl './test/expected/customClass/' + basename, (err, expectedFiles) ->
#                        throw err if err
#                        assert.fail null, null, "'expected/customClass/#{basename}' not found" unless expectedFiles.length
#                        expect(normalizeLineEndings resultFile.contents.toString()).to.equal normalizeLineEndings expectedFiles[0].contents.toString()
#                        numberOfResultFiles++
#                        done() if numberOfResultFiles is fixtures.length
#
#
#        it "should pass the file as an argument", (done) ->
#            stream = imageDataURI
#                customClass: (className, file) ->
#                    expect(file).to.be.an 'object'
#                    expect(className).to.equal path.basename file.path, path.extname file.path
#                    inputFilePath = path.resolve './test/fixtures/' + path.basename file.path
#                    expect(file.path).to.equal path.resolve inputFilePath
#
#                    inputFileContents = fs.readFileSync(inputFilePath).toString()
#                    expect(normalizeLineEndings file.contents.toString()).to.equal normalizeLineEndings inputFileContents
#
#                    return 'prefix-' + className
#
#            globToVinyl './test/fixtures/*', (err, fixtures) ->
#                throw err if err
#                fixtures.forEach (fixture) ->
#                    stream.write fixture
#                stream.end()
#
#                numberOfResultFiles = 0
#
#                stream.on 'data', ->
#                    numberOfResultFiles++
#                    done() if numberOfResultFiles is fixtures.length
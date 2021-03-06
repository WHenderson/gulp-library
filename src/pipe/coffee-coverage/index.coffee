lib = require('../../lib')
config = require('../../config')
util = require('../../util')
fs = require('fs')
process = require('process')
path = require('path')

module.exports = util.fnOptionLazyPipe(
  (options) ->
    options = util.mergeOptions({ bare: config.coffeeScript?.bare }, config.coffeeCoverage)

    coverageInstrumentor = new lib.util.coffeeCoverage.CoverageInstrumentor(
      bare: options.bare
      instrumentor: options.instrumentor
    )

    if options.verbose
      coverageInstrumentor
      .on('instrumentingDirectory', (sourceDir, outDir) ->
        console.log("Instrumenting directory: #{stripLeadingDotOrSlash sourceDir} to #{stripLeadingDotOrSlash outDir}")
      ).on('instrumentingFile', (sourceFile, outFile) ->
        console.log("    #{stripLeadingDotOrSlash sourceFile} to #{stripLeadingDotOrSlash outFile}")
      )
      .on('skip', (file) ->
        console.log("    Skipping: #{stripLeadingDotOrSlash file}")
      )

    if options.initfile
      lib.util.mkdirp.sync(path.dirname(options.initfile))
      options.initFileStream = fs.createWriteStream(options.initfile)

    return () ->
      (
        lib.pipe.lazypipe()
        .pipe -> lib.pipe.through2Map(
          {
            objectMode: true
          }
          (file) ->
            covered = coverageInstrumentor.instrumentCoffee(file.path, file.contents.toString(), lib.util.extend({}, options, { fileName: file.relative }))
            file.contents = new Buffer(covered.init + covered.js)
            file.path = lib.util.gutil.replaceExtension(file.path, '.js')
            return file
        )
      )()
      .on('end', () ->
        options.initFileStream?.end()
      )
)
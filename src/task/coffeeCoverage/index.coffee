lib = require('../../lib')
config = require('../../config')
fs = require('fs')
process = require('process')
path = require('path')

module.exports = (src, dest, options) ->
  coverageInstrumentor = new lib.util.coffeeCoverage.CoverageInstrumentor(
    base: options.bare
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

  # Change initFile into a output stream
  if options.initfile
    lib.util.mkdirp.sync(options.initfile)
    options.initFileStream = fs.createWriteStream(options.initfile)

  options.basePath ?= process.cwd()
  options.basePath = path.resolve(options.basePath)

  result = coverageInstrumentor.instrument(options.src, options.dest, options)
  options.initFileStream?.end()

  if !result
    console.error("#{options.src} does not exist.")
  else
    console.log("Instrumented #{result.lines} lines.")

  return
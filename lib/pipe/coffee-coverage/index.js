var config, fs, lib, path, process, util;

lib = require('../../lib');

config = require('../../config');

util = require('../../util');

fs = require('fs');

process = require('process');

path = require('path');

module.exports = util.fnOptionLazyPipe(function(options) {
  var coverageInstrumentor, ref;
  options = util.mergeOptions({
    bare: (ref = config.coffeeScript) != null ? ref.bare : void 0
  }, config.coffeeCoverage);
  coverageInstrumentor = new lib.util.coffeeCoverage.CoverageInstrumentor({
    bare: options.bare,
    instrumentor: options.instrumentor
  });
  if (options.verbose) {
    coverageInstrumentor.on('instrumentingDirectory', function(sourceDir, outDir) {
      return console.log("Instrumenting directory: " + (stripLeadingDotOrSlash(sourceDir)) + " to " + (stripLeadingDotOrSlash(outDir)));
    }).on('instrumentingFile', function(sourceFile, outFile) {
      return console.log("    " + (stripLeadingDotOrSlash(sourceFile)) + " to " + (stripLeadingDotOrSlash(outFile)));
    }).on('skip', function(file) {
      return console.log("    Skipping: " + (stripLeadingDotOrSlash(file)));
    });
  }
  if (options.initfile) {
    lib.util.mkdirp.sync(path.dirname(options.initfile));
    options.initFileStream = fs.createWriteStream(options.initfile);
  }
  return function() {
    return (lib.pipe.lazypipe().pipe(function() {
      return lib.pipe.through2Map({
        objectMode: true
      }, function(file) {
        var covered;
        covered = coverageInstrumentor.instrumentCoffee(file.path, file.contents.toString(), lib.util.extend({}, options, {
          fileName: file.relative
        }));
        file.contents = new Buffer(covered.init + covered.js);
        file.path = lib.util.gutil.replaceExtension(file.path, '.js');
        return file;
      });
    }))().on('end', function() {
      var ref1;
      return (ref1 = options.initFileStream) != null ? ref1.end() : void 0;
    });
  };
});

var Collector, Report, fs, lib, path, util;

lib = require('../../lib');

util = require('../../util');

fs = require('fs');

path = require('path');

Report = require('istanbul').Report;

Collector = require('istanbul').Collector;

module.exports = util.fnOptionLazyPipe({
  base: void 0,
  cwd: void 0,
  path: 'coverage.json'
}, function(options) {
  var captureFile, captureFinish, collector;
  collector = new Collector();
  captureFile = function(file, enc, cb) {
    var coverage;
    if (file.isNull()) {
      cb();
      return;
    }
    if (file.isStream()) {
      this.emit('error', new lub.util.gutil.PluginError('combine-coverage', 'Streaming not supported'));
      cb();
      return;
    }
    coverage = JSON.parse(file.contents.toString());
    collector.add(coverage);
    cb();
  };
  captureFinish = function(cb) {
    var coverage, file;
    coverage = collector.getFinalCoverage();
    file = new lib.util.gutil.File({
      cwd: options.cwd,
      base: options.base,
      path: options.path,
      contents: new Buffer(JSON.stringify(coverage))
    });
    this.push(file);
    return cb();
  };
  return lib.pipe.lazypipe().pipe(function() {
    return lib.pipe.through2.obj(captureFile, captureFinish);
  });
});

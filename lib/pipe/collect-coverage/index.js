var combineCoverage, config, lib, path, pipeDone, util;

lib = require('../../lib');

pipeDone = require('../done');

config = require('../../config');

util = require('../../util');

combineCoverage = require('../combine-coverage');

path = require('path');

module.exports = util.fnOptionLazyPipe({
  istanbulReport: {
    reporters: ['text-summary', 'lcov', 'text', 'json']
  }
}, function(options) {
  return lib.pipe.lazypipe().pipe(function() {
    return pipeDone(function(done) {
      lib.gulp.src(path.join(config.output.base, config.output.coverage, 'parts', '*.json')).pipe(lib.test.istanbulReport(options.istanbulReport)).pipe(all.pipe.done.sync(function() {
        return done();
      }));
    });
  });
});

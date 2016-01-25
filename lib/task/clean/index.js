var config, lib, path, util,
  hasProp = {}.hasOwnProperty;

lib = require('../../lib');

config = require('../../config');

path = require('path');

util = require('../../util');

module.exports = util.fnOption({
  src: void 0,
  rimraf: {}
}, function(options) {
  var name, outputPath, src;
  src = options.src;
  if (src == null) {
    src = (function() {
      var ref, results;
      ref = config.output;
      results = [];
      for (name in ref) {
        if (!hasProp.call(ref, name)) continue;
        outputPath = ref[name];
        if (name !== 'base' && outputPath) {
          results.push(path.join(config.output.base, outputPath));
        }
      }
      return results;
    })();
  }
  return lib.gulp.src(src, {
    read: false
  }).pipe(lib.fs.rimraf(options.rimraf));
});

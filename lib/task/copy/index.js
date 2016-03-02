var config, lib, path,
  hasProp = {}.hasOwnProperty;

lib = require('../../lib');

config = require('../../config');

path = require('path');

module.exports = function(src, dest) {
  var ref, srcName, srcPath;
  switch ({}.toString.call(src)) {
    case '[object Object]':
      return (ref = lib.pipe).sequence.apply(ref, (function() {
        var results;
        results = [];
        for (srcName in src) {
          if (!hasProp.call(src, srcName)) continue;
          srcPath = src[srcName];
          results.push(module.exports(srcPath, path.join(dest, srcName)));
        }
        return results;
      })());
    default:
      return lib.gulp.src(src).pipe(dest);
  }
};

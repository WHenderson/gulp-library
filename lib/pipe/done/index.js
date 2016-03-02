var lib;

lib = require('../../lib');

module.exports = function(func) {
  return lib.pipe.through2.obj(function(file, enc, cb) {
    return cb(null, file);
  }, function(cb) {
    func(cb);
  });
};

module.exports.sync = function(func) {
  return lib.pipe.through2.obj(function(file, enc, cb) {
    return cb(null, file);
  }, function(cb) {
    func();
    cb();
  });
};

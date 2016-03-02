var lib,
  slice = [].slice;

lib = require('../lib');

module.exports = function() {
  var options, ref;
  options = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  return (ref = lib.util).extend.apply(ref, [true, {}].concat(slice.call(options)));
};

var mergeOptions,
  slice = [].slice;

mergeOptions = require('./merge-options');

module.exports = function() {
  var create, i, options;
  options = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), create = arguments[i++];
  return function() {
    var overrides;
    overrides = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return create(mergeOptions.apply(null, slice.call(options).concat(slice.call(overrides))));
  };
};

var mergeOptions,
  slice = [].slice;

mergeOptions = require('./merge-options');

module.exports = function() {
  var createLazy, i, options;
  options = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), createLazy = arguments[i++];
  return function() {
    var overrides;
    overrides = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return createLazy(mergeOptions.apply(null, slice.call(options).concat(slice.call(overrides))))();
  };
};

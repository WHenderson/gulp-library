var config, lib, util;

lib = require('../../lib');

config = require('../../config');

util = require('../../util');

module.exports = util.fnOptionLazyPipe({
  coffeeScript: {}
}, function(options) {
  options.coffeeScript = util.mergeOptions(config.lintCoffeeScript, options.coffeeScript);
  return lib.pipe.lazypipe().pipe(function() {
    return lib.pipe["if"](options.coffeeScript != null, lib.pipe["if"](config.glob.coffee, lib.lint.coffeeScript(options.coffeeScript)));
  }).pipe(function() {
    return lib.pipe["if"](options.coffeeScript != null, lib.pipe["if"](config.glob.coffee, lib.lint.coffeeScript.reporter()));
  });
});

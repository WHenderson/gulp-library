var coffeeCoverage, config, lib, util;

lib = require('../../lib');

config = require('../../config');

util = require('../../util');

coffeeCoverage = require('../coffee-coverage');

module.exports = util.fnOptionLazyPipe({
  jade: {
    data: {}
  }
}, {
  coffeeScript: config.coffeeScript,
  coffeeCoverage: config.coffeeCoverage,
  jade: config.jade,
  cson: config.cson
}, function(options) {
  var base, base1, base2, base3, ref;
  if (((ref = options.jade) != null ? ref.data : void 0) != null) {
    if ((base = options.jade.data).all == null) {
      base.all = {};
    }
    if ((base1 = options.jade.data.all).lib == null) {
      base1.lib = lib;
    }
    if ((base2 = options.jade.data.all).config == null) {
      base2.config = config;
    }
    if ((base3 = options.jade.data.all).util == null) {
      base3.util = util;
    }
  }
  return lib.pipe.lazypipe().pipe(function() {
    return lib.pipe["if"](options.cson != null, lib.pipe["if"](config.glob.cson, lib.transpile.cson(options.cson)));
  }).pipe(function() {
    return lib.pipe["if"](options.jade != null, lib.pipe["if"](config.glob.jade, lib.transpile.jade(options.jade)));
  }).pipe(function() {
    return lib.pipe["if"](options.coffeeScript != null, lib.pipe["if"](config.glob.coffeeScript, lib.transpile.coffeeScript(options.coffeeScript)));
  }).pipe(function() {
    return lib.pipe["if"](options.coffeeCoverage != null, lib.pipe["if"](config.glob.coffeeScript, coffeeCoverage(options.coffeeCoverage)));
  });
});

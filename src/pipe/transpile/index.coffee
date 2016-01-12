lib = require('../../lib')
config = require('../../config')
util = require('../../util')
coffeeCoverage = require('../coffeeCoverage')

module.exports = util.lazyTask(
  {
    jade: {
      data: {
        lib: lib
        config: config
        util: util
      }
    }
  }
  {
    coffeeScript: config.coffeeScript
    coffeeCoverage: config.coffeeCoverage
    jade: config.jade
    cson: config.cson
  }
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(options.cson?, lib.transpile.cson(options.cson))
    .pipe -> lib.pipe.if(options.jade?, lib.transpile.jade(options.jade))
    .pipe -> lib.pipe.if(options.coffeeScript?, lib.transpile.coffeeScript(options.coffeeScript))
    .pipe -> lib.pipe.if(options.coffeeCoverage?, coffeeCoverage(options.coffeeCoverage))

)
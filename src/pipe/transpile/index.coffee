lib = require('../../lib')
config = require('../../config')
util = require('../../util')
coffeeCoverage = require('../coffeeCoverage')

module.exports = util.fnOptionLazyPipe(
  {
    jade: {
      data: {}
    }
  }
  {
    coffeeScript: config.coffeeScript
    coffeeCoverage: config.coffeeCoverage
    jade: config.jade
    cson: config.cson
  }
  (options) ->
    if options.jade?.data?
      options.jade.data.all ?= {}
      options.jade.data.all.lib ?= lib
      options.jade.data.all.config ?= config
      options.jade.data.all.util ?= util

    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(options.cson?, lib.pipe.if(config.glob.cson, lib.transpile.cson(options.cson)))
    .pipe -> lib.pipe.if(options.jade?, lib.pipe.if(config.glob.jade, lib.transpile.jade(options.jade)))
    .pipe -> lib.pipe.if(options.coffeeScript?, lib.pipe.if(config.glob.coffeeScript, lib.transpile.coffeeScript(options.coffeeScript)))
    .pipe -> lib.pipe.if(options.coffeeCoverage?, lib.pipe.if(config.glob.coffeeScript, coffeeCoverage(options.coffeeCoverage)))

)
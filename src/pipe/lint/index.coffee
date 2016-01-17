lib = require('../../lib')
config = require('../../config')
util = require('../../util')

module.exports = util.fnOptionLazyPipe(
  {
    coffeeScript: {}
  },
  (options) ->
    options.coffeeScript = util.mergeOptions(config.lintCoffeeScript, options.coffeeScript)

    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(options.coffeeScript?, lib.pipe.if(config.glob.coffee, lib.lint.coffeeScript(options.coffeeScript)))
    .pipe -> lib.pipe.if(options.coffeeScript?, lib.pipe.if(config.glob.coffee, lib.lint.coffeeScript.reporter()))
)

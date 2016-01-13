lib = require('../../lib')
config = require('../../config')
util = require('../../util')

module.exports = util.lazyTask(
  config.lintCoffeeScript,
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(config.glob.coffee, lib.lint.coffeeScript(options))
    .pipe -> lib.lint.coffeeScript.reporter()
)

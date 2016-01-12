lib = require('../../lib')
config = require('../../config')
util = require('../../util')

module.exports = util.lazyTask(
  config.lintCoffeeScript,
  (options) ->
    lib.pipe.lazypipe()
    .pipe -> gif(config.glob.coffee, lib.lint.coffeeScript(options))
    .pipe -> lib.lint.coffeeScript.reporter()
)

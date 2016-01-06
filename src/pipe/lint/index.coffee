lib = require('../../lib')
config = require('../../config')

module.exports = lib.pipe.lazypipe()
.pipe -> gif('*.coffee', lib.lint.coffeeScript(config.lint.coffeeScript))
.pipe -> lib.lint.coffeeScript.reporter()


lib = require('../../lib')
config = require('../../config')

module.exports = lib.pipe.lazypipe()
.pipe -> lib.pipe.if(module.exports.coffeeScript, lib.transform.transpile.coffeeScript(config.transform.transpile.coffeeScript))
.pipe -> lib.pipe.if(module.exports.jade, lib.transform.transpile.jade(config.transform.transpile.jade))
.pipe -> lib.pipe.if(module.exports.cson, lib.transform.transpile.cson(config.transform.transpile.cson))

module.exports.coffeeScript = '*.coffee'
module.exports.jade = '*.jade'
module.exports.cson = '*.cson'
lib = require('../../lib')
config = require('../../config')

jadeConfig = (file) ->
  cfg = lib.util.extend({}, config.transform.transpile.jade)

  cfg.data = lib.util.extend(
    {}
    {
      lib: lib
      config: config
    }
    cfg.data
    file?.data
  )

  return cfg

module.exports = lib.pipe.lazypipe()
.pipe -> lib.pipe.if(module.exports.coffeeScript, lib.transform.transpile.coffeeScript(config.transform.transpile.coffeeScript))
.pipe -> lib.pipe.if(module.exports.cson, lib.transform.transpile.cson(config.transform.transpile.cson))
.pipe -> lib.pipe.if(module.exports.jade, lib.metadata.data((file) -> jadeConfig(file).data))
.pipe -> lib.pipe.if(module.exports.jade, lib.transform.transpile.jade(jadeConfig()))

module.exports.coffeeScript = '*.coffee'
module.exports.jade = '*.jade'
module.exports.cson = '*.cson'
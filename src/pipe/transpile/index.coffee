lib = require('../../lib')
config = require('../../config')
coffeeCoverage = require('../coffeeCoverage')

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

module.exports = (options) ->
  options = lib.util.extend(
    {
      coffeeScript: module.exports.coffeeScript
      jade: module.exports.jade
      cson: module.exports.cson
    }
    options
  )

  return (
    lib.pipe.lazypipe()
    .pipe -> lib.pipe.if(
      options.coffeeScript,
      lib.pipe.if(
        options.coffeeCoverage
        coffeeCoverage(options.coffeeCoverage)
        lib.transform.transpile.coffeeScript(config.transform.transpile.coffeeScript)
      )
    )
    .pipe -> lib.pipe.if(options.cson, lib.transform.transpile.cson(config.transform.transpile.cson))
    .pipe -> lib.pipe.if(options.jade, lib.metadata.data((file) -> jadeConfig(file).data))
    .pipe -> lib.pipe.if(options.jade, lib.transform.transpile.jade(jadeConfig()))
  )()

module.exports.coffeeScript = '*.coffee'
module.exports.jade = '*.jade'
module.exports.cson = '*.cson'
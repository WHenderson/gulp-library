lib = require('../../lib')
config = require('../../config')
util = require('../../util')
YAML = require('yamljs')
fs = require('fs')
path = require('path')

module.exports = util.fnOption(
  {
    spec: 'test/coverage.coffee'
    mocha: {}
  }
  (options) ->
    options.mocha = util.mergeOptions(config.mocha, options.mocha)

    if options.mocha?.istanbul == true
      options.mocha?.istanbul = {}

    if options.mocha?.istanbul and options.mocha.istanbul.config == undefined
      configPath = path.join(config.output.base, config.output.istanbulConfig)
      fs.writeFileSync(configPath, YAML.stringify(config.istanbulConfig, 2))
      options.mocha.istanbul.config = configPath

    lib.gulp
    .src(options.spec, { read: false })
    .pipe(lib.test.mocha(options.mocha))
)

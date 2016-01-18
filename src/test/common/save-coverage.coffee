config = require('../../config')
fs = require('fs')
path = require('path')
process = require('process')
mkdirp = require('mkdirp')

module.exports = (name='coverage', reason) ->
  coverage = global[config.coffeeCoverage.coverageVar]
  coverageBase = path.resolve(config.output.base, config.output.coverage, 'parts')
  coveragePath = path.resolve(coverageBase, name + '.json')

  try
    mkdirp.sync(coverageBase)
    fs.writeFileSync(coveragePath, JSON.stringify(coverage))
    console.log('Saved coverage:', coveragePath)
  catch ex
    console.log('Error saving coverage:', ex)

  return

module.exports.register = (name) ->
  process.on('exit', module.exports.bind(null, name, 'exit'))
  process.on('SIGINT', module.exports.bind(null, name, 'SIGINT'))
  process.on('uncaughtException', module.exports.bind(null, name, 'uncaughtException'))
  return

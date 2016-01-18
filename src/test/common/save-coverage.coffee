config = require('../../config')
fs = require('fs')
path = require('path')
process = require('process')

module.exports = (name) ->
  coverage = global[config.coffeeCoverage.coverageVar]
  coveragePath = path.resolve(config.output.base, config.output.coverage, 'coverage.json')

  try
    fs.writeFileSync(coveragePath, JSON.stringify(coverage))
    console.log('Saved coverage:', coveragePath)
  catch ex
    console.log('Error saving coverage:', ex)

  return

module.exports.register = () ->
  process.on('exit', module.exports.bind(null, 'exit'))
  process.on('SIGINT', module.exports.bind(null, 'SIGINT'))
  process.on('uncaughtException', module.exports.bind(null, 'uncaughtException'))
  return

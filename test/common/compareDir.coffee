dirCompare = require('dir-compare')
fc = require('dir-compare/filecompare')
fs = require('fs')
assert = require('chai').assert
path = require('path')
padd = require('./padd')

exDiscardLeadingPath = /("|')(?:[^"']+)(?:\\\\|\/)(?:gulp-library)(?:\\\\|\/)([^"']+)\1/gi

compareFile = (path1, stat1, path2, stat2, options) ->
  if not path1.match(/\.coverage\.[^.]+\.js$/) or not stat1? or not stat2?
    return (stat1.size == stat2.size) and fc.compareSync(path1, path2)
  else
    str1 = fs.readFileSync(path1, 'utf8').replace(exDiscardLeadingPath, (full, p1,p2) -> p1 + p2.replace(/\\\\/g, '/') + p1)
    str2 = fs.readFileSync(path2, 'utf8').replace(exDiscardLeadingPath, (full, p1,p2) -> p1 + p2.replace(/\\\\/g, '/') + p1)

    return str1 == str2

module.exports = (path1, path2, options, compareFileCallback, resultBuilderCallback) ->
  options ?= {}
  options.compareSize ?= true
  options.compareContent ?= true
  options.skipSubdirs ?= false
  options.ignoreCase ?= false
  compareFileCallback ?= compareFile

  return dirCompare.compareSync(path1, path2, options, compareFileCallback, resultBuilderCallback)

module.exports.assert = (actual, expected) ->
  compared = module.exports(
    actual
    expected
    {
      compareSize: true
      compareContent: true
      skipSubdirs: false
      ignoreCase: false
    }
    compareFile
  )

  output = [
    'Discrepancies during comparison:'
    "Actual   : #{path.resolve(actual)}"
    "Expected : #{path.resolve(expected)}"
  ]
  for diff in compared.diffSet when diff.state != 'equal'
    pathName = (filePath, fileName) ->
      if filePath? and fileName?
        return path.resolve(path.join(filePath, fileName))
      else
        return '<none>'

    output.push("[#{padd(diff.state,8)}] [#{padd(diff.type1,9)}] #{pathName(diff.path1, diff.name1)}")
    output.push("#{padd('',10)} #{padd('',11)} #{pathName(diff.path2, diff.name2)}")

  output.push('')

  return assert(compared.same, output.join('\n'))
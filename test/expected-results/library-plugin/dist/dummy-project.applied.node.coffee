ko = require('knockout')
isAn = require('is-an')
x = 1

if x == 1
  y = 1
else if x == 2
  y = 2
else
  y = -1

dummyProject = (ko) ->
  results = []
  results.push('index.begin.coffee')

  results.push('inner/index.coffee')
  results.push('inner/a.coffee')
  results.push('inner/z.coffee')
  results.push('index.end.coffee')
  return results
module.exports = dummyProject(ko)
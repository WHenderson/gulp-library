lib = require('../../lib')

rename = (name) ->
  return name.replace(
    /([a-z0-9])([A-Z])/g
    (match, p1, p2) ->
      p1 + '-' + p2.toLowerCase()
  )

module.exports = (tasks, prefix) ->
  prefix = if prefix? then prefix + '_' else ''
  index = 0
  dep = []
  for own name, task of tasks when name[0] != '_'
    name = rename(name)
    discreteName = "#{prefix}discrete-#{index}-#{name}"
    chainedName = "#{prefix}chained-#{index}-#{name}"
    lib.gulp.task(discreteName, task)
    lib.gulp.task(chainedName, dep, task)
    dep = [discreteName]
    ++index

  return

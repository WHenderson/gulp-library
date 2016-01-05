lib = require('../../lib')

module.exports = (tasks, prefix) ->
  prefix = if prefix? then prefix + '_' else ''
  index = 0
  dep = []
  for own name, task of tasks when name[0] != '_'
    discreteName = "#{prefix}discrete-#{index}-#{name}"
    chainedName = "#{prefix}chained-#{index}-#{name}"
    lib.gulp.task(discreteName, task)
    lib.gulp.task(chainedName, dep, task)
    dep = [discreteName]

  return

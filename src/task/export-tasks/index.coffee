lib = require('../../lib')

formatName = (name) ->
  return name.replace(
    /([a-z0-9])([A-Z])/g
    (match, p1, p2) ->
      p1 + '-' + p2.toLowerCase()
  )

module.exports = (tasks, { includes, number, chained = 'chained', discrete = 'discrete' } = {}) ->
  includes ?= (k for k in Object.keys(tasks) when k[0] != '_')

  chained = if chained then chained + '-' else ''
  discrete = if discrete then discrete + '-' else ''

  number ?= !!chained

  dep = []
  iname = 0

  for name in includes
    taskName = if number then "#{iname}-" else ''
    taskName += formatName(name)

    if discrete
      lib.gulp.task(discrete + taskName, tasks[name])
    if chained
      lib.gulp.task(chained + taskName, dep, tasks[name])
      dep = [chained + taskName]

    ++iname

  return

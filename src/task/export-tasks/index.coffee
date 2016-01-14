lib = require('../../lib')

formatName = (name) ->
  return name.replace(
    /([a-z0-9])([A-Z])/g
    (match, p1, p2) ->
      p1 + '-' + p2.toLowerCase()
  )

module.exports = {
  discrete: (tasks, { includes, prefix, number, chain = false }) ->
    includes ?= (k for k in Object.keys(tasks) when k[0] != '_')
    prefix = if prefix? then prefix + '-' else if chain then 'chained' else ''
    number ?= chain

    dep = []
    for name in includes
      taskName = prefix
      if number
        taskName += "#{number}-"
      taskName += formatName(name)

      lib.gulp.task(taskName, dep, tasks[name])
      if chain
        dep = [taskName]

    return
}

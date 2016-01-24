lib = require('../../lib')
config = require('../../config')
path = require('path')

formatName = (name) ->
  return name.replace(
    /([a-z0-9])([A-Z])/g
    (match, p1, p2) ->
      p1 + '-' + p2.toLowerCase()
  )

hasPrefix = (name, prefix) ->
  if name.slice(0, prefix.length) != prefix
    return false
  if name.charAt(prefix.length).match(/^[a-z]/)
    return false
  return true

lpadd = (str, len, padding='00000000000000') ->
  while str.length < len
    str = (str + padding).slice(0, len)
  return str

module.exports = (tasks, { includes, excludes } = {}) ->
  excludes ?= []
  includes ?= (k for k in Object.keys(tasks) when k[0] != '_' and excludes.indexOf(k) == -1)

  state = {
    'discrete': {
      index: 0
    }
    'chained': {
      index: 0
      dep: []
      skip: ['dist']
    }
    'test': {
      index: 0
      prefix: 'test'
      dep: []
    }
    'build': {
      index: 0
      prefix: 'build'
      dep: []
    }
    'dist': {
      index: 0
      prefix: 'dist'
      dep: []
    }
  }

  for name in includes
    for own group, groupDetails of state
      if groupDetails.skip?.some?((prefix) -> hasPrefix(name, prefix))
        continue

      taskName = ''
      if groupDetails.dep?
        taskName += 'chained-'
      else
        taskName += 'discrete-'
      if groupDetails.prefix?
        if not hasPrefix(name, groupDetails.prefix)
          continue
        taskName += groupDetails.prefix + '-'
      if groupDetails.index?
        taskName += lpadd(groupDetails.index.toString(), if includes.length < 10 then 1 else 2) + '-'
        ++groupDetails.index
      taskName += formatName(name)

      if groupDetails.dep
        lib.gulp.task(taskName, groupDetails.dep, tasks[name])
        groupDetails.dep = [taskName]
      else
        lib.gulp.task(taskName, tasks[name])

  noted = {
    'chained': 'default'
    'test': 'test'
    'build': 'build'
    'dist': 'dist'
  }

  for own from, to of noted
    if state[from]?.dep?.length > 0
      lib.gulp.task(to, state[from].dep, () -> return)
    else
      noted[from] = null

  if noted['chained']?
    lib.gulp.task('watch', state['chained'].dep, () ->
      lib.gulp.watch('src/**/*.{js,coffee}', [noted['chained']])
    )
  if noted['build']?
    lib.gulp.task('watch-build', state['build'].dep, () ->
      lib.gulp.watch('src/**/*.{js,coffee}', [noted['build']])
    )
  if noted['test']?
    lib.gulp.task('watch-test', state['test'].dep, () ->
      lib.gulp.watch(path.join(config.output.base, config.output.dist, '**/*'), [noted['test']])
    )

  return

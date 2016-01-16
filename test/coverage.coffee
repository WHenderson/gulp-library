assert = require('chai').assert
process = require('process')
path = require('path')
dirCompare = require('dir-compare')

assert.deepEqual()

padd = (str, count, padding = '                        ') ->
  while str.length < count
    str = (str + padding).slice(0, count)
  return str

assert.compareDir = (actual, expected) ->
  compared = dirCompare.compareSync(
    actual
    expected
    {
      compareSize: true
      compareContent: true
      skipSubdirs: false
      ignoreCase: false
    }
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



suite('coverage', () ->

  configOriginal = undefined
  configReset = () ->
    reset = (lhs, rhs) ->
      if typeof lhs != typeof rhs
        if typeof rhs == 'object'
          rhs = all.lib.util.extend(true, {}, rhs)
        return rhs

      if typeof lhs == 'object'
        lhsKeys = Object.keys(lhs)
        rhsKeys = Object.keys(rhs)

        tmp = {}
        for key in Object.keys(lhs)
          if {}.hasOwnProperty.call(rhs, key)
            tmp[key] = lhs[key]
          delete tmp[key]

        for key in Object.keys(rhs)
          lhs[key] = reset(tmp[key], rhs[key])

        return lhs

      return rhs

    reset(global.all.config, configOriginal)

  setup(() ->
    @timeout(25*1000)
    global.all = require('../src')
    configOriginal = all.lib.util.extend(true, {}, all.config)
  )

  base = path.join(__dirname, 'dummy-project')
  cwdOriginal = process.cwd()
  setup(() ->
    process.chdir(base)
  )
  teardown(() ->
    process.chdir(cwdOriginal)
  )

  test('library', (cb) ->
    @timeout(25*1000)

    configReset()
    all.config.output.base = '../../build/test/library'

    all.task.library({
      isPlugin: false
      base: base
    })
    .on('end', () ->
      assert.compareDir(
          path.join(__dirname, 'expected-results/library')
          path.join(all.config.output.base)
      )

      configReset()
      all.config.output.base = '../../build/test/library-plugin'

      all.task.library({
        isPlugin: true
        base: base
        dependencies: [
          {
            param: 'ko'
            name: 'knockout'
          }
          {
            param: 'isAn'
            name: 'is-an'
          }
        ]
      })
      .on('end', () ->
        assert.compareDir(
          path.join(__dirname, 'expected-results/library-plugin')
          path.join(all.config.output.base)
        )

        cb()
      )
    )

    return
  )
 )
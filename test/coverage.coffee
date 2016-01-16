assert = require('chai').assert
process = require('process')
path = require('path')

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
    for key, val of all.config.output
      all.config.output[key] = path.join('../../build/test/library', val)

    all.task.library({
      isPlugin: false
      base: base
    })
    .on('end', () ->
      configReset()
      for key, val of all.config.output
        all.config.output[key] = path.join('../../build/test/library-plugin', val)

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
        cb()
      )
    )

    return
  )
 )
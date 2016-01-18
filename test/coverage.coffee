assert = require('chai').assert
process = require('process')
path = require('path')
dirCompare = require('dir-compare')
async = require('async')
resetDeep = require('./common/resetDeep')
fs = require('fs')

assert.compareDir = require('./common/compareDir').assert

suite('coverage', () ->

  configOriginal = undefined
  configReset = () -> resetDeep(global.all.config, configOriginal)

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

  test('library', (doneTest) ->
    libraryPath = @test.title

    async.series([
      (done) ->
        console.log('build')

        configReset()
        all.config.output.base = path.join('../../build/test', libraryPath)

        all.task.library({
          isPlugin: false
          base: base
        })
        .on('end', () -> done())

      (done) ->
        console.log('validate')

        assert.compareDir(
          path.join(all.config.output.base)
          path.join(__dirname, 'expected-results', libraryPath)
        )

        done()
        return

      (done) ->
        done()
        doneTest()
        return
    ])
  )

  test('library-plugin', (doneTest) ->
    libraryPath = @test.title

    async.series([
      (done) ->
        console.log('build')

        configReset()
        all.config.output.base = path.join('../../build/test', libraryPath)

        all.task.library({
          isPlugin: true
          base: base
          dependencies: [
            {
              name: 'knockout'
              param: 'ko'
            }
            {
              name: 'is-an'
              param: 'isAn'
            }
          ]
        })
        .on('end', () -> done())

      (done) ->
        console.log('validate')

        assert.compareDir(
          path.join(all.config.output.base)
          path.join(__dirname, 'expected-results', libraryPath)
        )

        done()
        return

      (done) ->
        console.log('clean')

        all.task.clean({ rimraf: { force: true } }) # outside working directory, so we need to force
        .on('finish', () -> done()) # not sure why 'end' doesn't work here

        return

      (done) ->
        console.log('validate')

        for name, filePath of all.config.output when name != 'base'
          assert.isFalse(fs.existsSync(path.join(all.config.output.base, filePath)))

        done()
        return

      (done) ->
        done()
        doneTest()
        return
    ])
  )


  test.only('coverage', (doneTest) ->
    @timeout(20*1000)

    async.series([
      (done) ->
        all.task.test.coverage({
          mocha: {
            compilers: 'coffee:coffee-script/register'
            istanbul: false
          }
        })
        .on('end', () -> done())

      (done) ->
        done()
        doneTest()
        return
    ])
  )

  test('dummy', () ->
  )

 )
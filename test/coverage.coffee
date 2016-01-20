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
    # building coverage takes time
    @timeout(30*1000)

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

  suite('build', () ->
    test('clean', (doneTest) ->
      @timeout(10*1000)
      testTitle = @test.title

      async.series([
        (done) ->
          console.log('clean')

          all.task.clean()
          .pipe(all.pipe.done.sync(() ->
            done()
          ))
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

    test('library-plugin', (doneTest) ->
      @timeout(100*1000)
      testTitle = @test.title

      async.series([
        (done) ->
          console.log('build')

          configReset()

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
          .on('end', () ->
            done()
          )
          return

        (done) ->
          console.log('validate')

          assert.compareDir(
            path.resolve(all.config.output.base, all.config.output.dist)
            path.join(__dirname, 'expected-results', testTitle, all.config.output.dist)
          )

          done()
          return

        (done) ->
          console.log('clean')

          all.task.clean()
          .pipe(all.pipe.done.sync(() ->
            done()
          ))

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

    test('library', (doneTest) ->
      @timeout(30*1000)
      testTitle = @test.title

      async.series([
        (done) ->
          console.log('build')

          configReset()

          all.task.library({
            isPlugin: false
            base: base
          })
          .on('end', () ->
            done()
          )
          return

        (done) ->
          console.log('validate')

          assert.compareDir(
            path.resolve(all.config.output.base, all.config.output.dist)
            path.join(__dirname, 'expected-results', testTitle, all.config.output.dist)
          )

          done()
          return

        (done) ->
          done()
          doneTest()
          return
      ])
    )
  )

  suite('test', () ->
    test('test node', (doneTest) ->
      @timeout(30*1000)

      async.series([
        (done) ->
          all.task.test.node({
          })
          .pipe(all.lib.pipe.through2.obj(
            (file) -> file
            (cb) ->
              console.log('hmm')
              cb()
          ))
          .pipe(all.pipe.done.sync(() ->
            done()
          ))
          return

        (done) ->
          done()
          doneTest()
          return
      ])
    )

    test.only('test client', (doneTest) ->
      @timeout(30*1000)

      async.series([
        (done) ->
          all.task.test.client({
            globals: {
              dummyProject: '../dist/dummy-project.coverage.web.js'
            }
          })
          .pipe(all.pipe.done.sync(() ->
            done()
          ))
          return

        (done) ->
          done()
          doneTest()
          return
      ])
    )

    test('dummy', () ->
    )
  )


 )
process = require('process')
path = require('path')

suite('coverage', () ->
  setup(() ->
    @timeout(25*1000)

    global.all = require('../src')
    #process.chdir('test/dummy-project')
  )

  teardown(() ->
    #process.chdir('../')
  )

  test('dummy', (cb) ->
    all.task.library({
      library: {
        isPlugin: true
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
      }
      base: path.join(__dirname, 'dummy-project')
    })
    .on('end', () ->
      ###
      all.task.library({
        isPlugin: true
        base: path.join(__dirname, 'dummy-project')
      })
      .on('end', () -> cb())

      ###
      cb()
    )

  )
)
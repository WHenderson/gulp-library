suite('coverage', () ->
  setup((cb) ->
    @timeout(25*1000)

    global.all = require('../src')

    cb()
  )

  test('dummy', () ->
    console.log(all.util.findPackageRoot())
  )
)
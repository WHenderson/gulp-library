lib = require('../../lib')

module.exports = (func) ->
  lib.pipe.through2.obj(
    (file, enc, cb) ->
      cb(null, file)
    (cb) ->
      func(cb)
      return
  )

module.exports.sync = (func) ->
  lib.pipe.through2.obj(
    (file, enc, cb) ->
      cb(null, file)
    (cb) ->
      func()
      cb()
      return
  )

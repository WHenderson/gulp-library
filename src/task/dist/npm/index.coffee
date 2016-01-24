async = require('async')
spawn = require('child_process').spawn
path = require('path')
config = require('../../../config')
util = require('../../../util')

module.exports = () ->

  exec = (cmd, args, cbDone, cbError) ->
    isDone = false

    spawn(cmd, args, { stdio: 'inherit' })
    .on('error', (err) ->
      err = new Error(err)
      cbError?(err)
      if not isDone
        isDone = true
        cbDone(err)
    )
    .on('exit', (code) ->
      if code != 0
        err = new Error("#{cmd} exited with non-zero code #{code}")
      if err?
        cbError?(code)
      if not isDone
        isDone = true
        cbDone(err)
    )

  (doneAll) ->
    cfgNpm = util.loadPackageJson()

    async.series([
      (done) ->
        exec('git', ['add', 'bower.json'], done)
        return

      (done) ->
        exec('git', ['add', '-f', path.join(config.output.base, config.output.dist)], done)
        return

      (done) ->
        exec('git', ['checkout', 'head'], done)
        return

      (done) ->
        exec('git', ['commit', '-m', "Version #{cfgNpm.version} for distribution"], done)
        return

      (done) ->
        exec('git', ['tag', '-a', "v#{cfgNpm.version}", '-m', "Add tag #{cfgNpm.version}"], done)
        return

      (done) ->
        exec('npm', ['publish'], done)
        return

      (done) ->
        exec('git', ['checkout', 'master'], done)
        return

      (done) ->
        exec('git', ['push', 'origin', '--tags'], done)
        return


    ], doneAll)
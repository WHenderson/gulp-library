async = require('async')
spawn = require('child_process').spawn
process = require('process')
path = require('path')
config = require('../../../config')
util = require('../../../util')

module.exports = util.fnOption(
  {
    output: {}
    extras: [
      'bower.json'
    ]
  }
  (options) ->
    options.output = util.mergeOptions(config.output, options.output)

    exec = (cmd, args, options, cbDone, cbError) ->
      if typeof options != object
        cbError = cbDone
        cbDone = options
        options = {}

      options = util.mergeOptions({ stdio: 'inherit' }, options)

      err = undefined

      escapeArg = (arg) ->
        if not arg.match(/\\|"/g) and arg.match(/\s/g)
          return '"' + arg + '"'
        else
          return arg.replace(/\\|\s|"/g, '\\$0')

      console.log("> #{cmd} #{args.map(escapeArg).join(' ')}")

      child = spawn(cmd, args, options)

      child.on('error', (err) ->
        err = new Error(err)

        if not child.pid?
          if cbError?
            cbError(
              err,
              (err) ->
                cbDone(err)
                return
            )
          else
            cbDone(err)

        return
      )
      .on('exit', (code) ->
        if code != 0
          err = new Error("#{cmd} exited with non-zero code #{code}")
          err.innerError = err

        if err? and cbError?
          cbError(
            err,
            (err) ->
              cbDone(err)
              return
          )
        else
          cbDone(err)
      )

      return child

    (doneAll) ->
      cfgNpm = util.loadPackageJson()

      async.series([
        (done) ->
          # Ensure no changes
          abort = false
          exec('git', ['status', '--porcelain'], { stdio: [process.stdin, 'pipe', process.stderr] }, (err) ->
            if not err? and abort
              err = new Error('Changes detected. Please ensure the staging area is clean before running')
            if err?
              console.error(err)
            done(err)
            return
          )
          .on('data', (data) ->
            abort = true
            process.stdout.write(data)
            return
          )

          return

        (done) ->
          # Ensure we are committing the master
          name = ''
          exec('git', ['status', '--porcelain'], { stdio: [process.stdin, 'pipe', process.stderr] }, (err) ->
            if not err? and name != 'master'
              err = new Error('Current branch is not master. Please only distribute from master.')
            if err?
              console.error(err)
            done(err)
            return
          )
          .on('data', (data) ->
            name += data.toString()
            process.stdout.write(data)
            return
          )

          return

        (done) ->
          if options.extras.length != 0
            exec('git', ['add'].concat(options.extras), done)
          else
            done()
          return

        (done) ->
          if options.output.dist?
            exec('git', ['add', '-f', path.join(options.output.base, options.output.dist)], done)
          else
            done()
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
          exec('npm', ['publish'], (err, done) ->
            if err?
              console.error(err)
              console.error('RESETTING')
              exec('git', ['reset'], () -> done(err))
            else
              done(err)
          )
          return

        (done) ->
          exec('git', ['checkout', 'master'], done)
          return

        (done) ->
          exec('git', ['push', 'origin', '--tags'], done)
          return


      ], doneAll)
)
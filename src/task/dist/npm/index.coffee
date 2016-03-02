async = require('async')
spawn = require('child_process').spawn
process = require('process')
path = require('path')
config = require('../../../config')
util = require('../../../util')

module.exports = util.fnOption(
  {
    output: {
      version: 'patch'
      message: 'Version %s for distribution'
    }
    extras: [
      'bower.json'
    ]
  }
  (options) ->
    # ToDo: add option for bumping major/minor/patch (using npm commands?)
    # ToDo: mirror attributes from package.json to bower.json
    # ToDo: Uncomment check for "changed files" for final version

    options.output = util.mergeOptions(config.output, options.output)

    exec = (cmd, args, options, cbDone, cbError) ->
      if typeof options != 'object'
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
          done()
          return
          abort = false
          child = exec('git', ['status', '--porcelain'], { stdio: [process.stdin, 'pipe', process.stderr] }, (err) ->
            if not err? and abort
              err = new Error('Changes detected. Please ensure the staging area is clean before running')
            if err?
              console.error(err)
            done(err)
            return
          )
          child.stdout.on('data', (data) ->
            abort = true
            process.stdout.write(data)
            return
          )

          return

        (done) ->
          # Ensure we are committing the master
          name = ''
          child = exec('git', ['rev-parse', '--abbrev-ref', 'HEAD'], { stdio: [process.stdin, 'pipe', process.stderr] }, (err) ->
            name = name.replace(/\r\n|\r|\n/, '')
            if not err? and name != 'master'
              console.log("[#{name}]")
              err = new Error('Current branch is not master. Please only distribute from master.')
            if err?
              console.error(err)
            done(err)
            return
          )

          child.stdout.on('data', (data) ->
            name += data.toString()
            process.stdout.write(data)
            return
          )

          return

        (done) ->
          # Add extras
          if options.extras.length != 0
            exec('git', ['add', '-f'].concat(options.extras), done)
          else
            done()
          return

        (done) ->
          # Add dist folder
          if options.output.dist?
            exec('git', ['add', '-f', path.join(options.output.base, options.output.dist)], done)
          else
            done()
          return

        (done) ->
          # create temp branch
          exec('git', ['checkout', 'head'], done)
          return

        (done) ->
          # Bump version
          exec('npm', ['version', options.version, '-m', options.message], done)
          return

        (done) ->
          # Publish to npm
          exec('npm', ['publish'], (err) ->
            if err?
              console.error(err)
              console.error('RESETTING')
              async.series([
                (cb) ->
                  exec('git', ['checkout', 'master'], cb)
                  return
              ], () -> done(err))
            else
              done(err)

            return
          )
          return

        (done) ->
          # Revert to master branch
          exec('git', ['checkout', 'master'], done)
          return

        (done) ->
          # push changes
          exec('git', ['push', 'origin', '--tags'], done)
          return


      ], doneAll)
)
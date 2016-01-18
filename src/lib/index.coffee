module.exports = {
  # gulp
  gulp: require('gulp')

  # object metadata
  metadata: {
    rename: require('gulp-rename')

    data: require('gulp-data')
  }

  # debugging tools
  debug: {
    debug: require('gulp-debug')
  }

  # file system
  fs: {
    rimraf: require('gulp-rimraf')
  }

  # flow control
  pipe: {
    if: require('gulp-if')

    sequence: require('gulp-sequence')

    ignore: require('gulp-ignore')

    lazypipe: require('lazypipe')

    mirror: require('gulp-mirror')

    through2Map: require('through2-map')

    sort: require('gulp-sort')

    concat: require('gulp-concat')

    through: require('through')

    through2: require('through2')
  }

  # lint
  lint: {
    coffeeScript: require('gulp-coffeelint')
  }

  # transform
  transform: {
    sourceMaps: require('gulp-sourcemaps')

    umd: require('gulp-umd')

    insert: require('gulp-insert')

    uglify: require('gulp-uglify')
  }

  # transpile
  transpile: {
    coffeeScript: require('gulp-coffee')

    jade: require('gulp-jade')

    cson: require('gulp-cson/index.coffee')
  }

  # utilities
  util: {
    extend: require('extend')

    cson: require('cson')

    chai: require('chai')

    glob: require('glob')

    bower: require('bower')

    coffeeCoverage: require('coffee-coverage')

    mkdirp: require('mkdirp')

    gutil: require('gulp-util')
  }

  test: {
    mocha: require('gulp-spawn-mocha')

    mochaPhantomJs: require('gulp-mocha-phantomjs')

    istanbul: require('gulp-istanbul')

    istanbulReport: require('gulp-istanbul-report')
  }
}
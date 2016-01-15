lib = require('../../lib')
config = require('../../config')
path = require('path')

bits = (p) ->
  dirname = path.dirname(p)
  basename = path.basename(p)
  extname = path.extname(basename)
  name = path.basename(basename, extname)

  return {
    path: p
    dirname: dirname
    basename: basename
    extname: extname
    name: name
  }

isSameOrChild = (parent, sameOrChild) ->
  parent = path.normalize(parent).split(path.sep)
  sameOrChild = path.normalize(sameOrChild).split(path.sep).slice(0, parent.length)

  return parent.join(path.sep) == sameOrChild.join(path.sep)

module.exports = () ->
  lib.pipe.sort({
    comparator: (lhs, rhs) ->
      lhs = bits(lhs.path)
      rhs = bits(rhs.path)

      if (((lhs.name == 'index' or lhs.name == 'index.begin') and isSameOrChild(lhs.dirname, rhs.dirname)) or
          ((rhs.name == 'index.end') and isSameOrChild(rhs.dirname, lhs.dirname)))
        return -1

      if (((rhs.name == 'index' or rhs.name == 'index.begin') and isSameOrChild(rhs.dirname, lhs.dirname)) or
          ((lhs.name == 'index.end') and isSameOrChild(lhs.dirname, rhs.dirname)))
        return 1

      if lhs.path < rhs.path
        return -1
      if lhs.path > rhs.path
        return 1

      return 0
  })

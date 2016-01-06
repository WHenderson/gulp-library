glob = require('glob')
path = require('path')

files = glob.sync('C:/Code/OwnGitHub/ko-type-restricted/src/**/*.coffee')

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

isSubpath = (parent, sameOrChild) ->
  path.join(parent,'a') == path.join(sameOrChild.slice(0, parent.length + 1), 'a')

compare = (lhs, rhs) ->
  lhs = bits(lhs)
  rhs = bits(rhs)

  if (((lhs.name == 'index' or lhs.name == 'index.begin') and isSubpath(lhs.dirname, rhs.dirname)) or
      ((rhs.name == 'index.end') and isSubpath(rhs.dirname, lhs.dirname)))
    return -1

  if (((rhs.name == 'index' or rhs.name == 'index.begin') and isSubpath(rhs.dirname, lhs.dirname)) or
      ((lhs.name == 'index.end') and isSubpath(lhs.dirname, rhs.dirname)))
    return 1

  if lhs.path < rhs.path
    return -1
  if lhs.path > rhs.path
    return 1

  return 0

files.sort(compare)

for file in files
  console.log(file)

do ->
  lhs = 'C:/Code/OwnGitHub/ko-type-restricted/src/apply.coffee'
  rhs = 'C:/Code/OwnGitHub/ko-type-restricted/src/index.begin.coffee'

  console.log(bits(lhs))
  console.log(bits(rhs))

  console.log(compare(
    lhs
    rhs
  ))
  console.log(compare(
    lhs
    lhs
  ))
  console.log(compare(
    rhs
    rhs
  ))
  console.log(compare(
    rhs
    lhs
  ))

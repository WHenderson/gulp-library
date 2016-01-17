module.exports = (lhs, rhs) ->
  if typeof lhs != typeof rhs
    if typeof rhs == 'object'
      rhs = all.lib.util.extend(true, {}, rhs)
    return rhs

  if typeof lhs == 'object'
    lhsKeys = Object.keys(lhs)
    rhsKeys = Object.keys(rhs)

    tmp = {}
    for key in Object.keys(lhs)
      if {}.hasOwnProperty.call(rhs, key)
        tmp[key] = lhs[key]
      delete tmp[key]

    for key in Object.keys(rhs)
      lhs[key] = module.exports(tmp[key], rhs[key])

    return lhs

  return rhs

module.exports = (str, count, padding = '                        ') ->
  while str.length < count
    str = (str + padding).slice(0, count)
  return str
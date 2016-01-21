x = 1

if x == 1
  y = 1
else if x == 2
  y = 2
else
  y = -1

dummyProject = (ko, test) ->
  if test == 'node'
    return 'nodeTest'
  else if test == 'client'
    return 'clientTest'

  results = []
  results.push('index.begin.coffee')

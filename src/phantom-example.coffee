page = require('webpage').create()
args = require('system').args

page.onCallback = (data) ->
  if typeof data == 'string'
    data = { message: data }

  if data.message?
    console.log("MESSAGE: #{data.message}")

  if typeof data.exit == 'number'
    phantom.exit(data.exit)
  else if data.exit != false
    phantom.exit()

  return

page.onConsoleMessage = (msg, lineNum, sourceId) ->
  if lineNum? or sourceId?
    lineNum ?= 'unknown'
    sourceId ?= 'sourceId'
    loc = " (#{lineNum}:#{sourceId})"
  else
    loc = ''

  console.log("CONSOLE: #{msg}#{loc}")
  return

page.open(args[1], (status) ->
  if (status != 'success')
    console.error("Failed to open #{args[1]}")
    phantom.exit()
)
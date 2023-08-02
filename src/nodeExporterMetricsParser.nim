import strutils, parseutils

type
  Key* = string
  Value* = string
  MetricsLine* = object
    key*: Key
    value*: Value
    params*: seq[(Key, Value)]


proc parseParams(params: string): seq[(Key, Value)] =
  ## Parse the params (between `{}`)
  if params.len == 0: return
  var pos = 0
  while pos < params.len:
    var key = ""
    var val = ""
    pos += parseUntil(params, key, '=', pos)
    pos.inc # skip '='
    # param value is enclosed in '"' is it always??
    pos.inc # skip '"'
    pos += parseUntil(params, val, '"', pos)
    pos.inc # skip '"'
    pos.inc # skip ','
    result.add((key, val))


proc parseMetricsLine*(line: string): MetricsLine =
  ## Parse one line of the metrics
  var key: Key
  var value: Value
  var params: string
  var pos = 0
  pos += parseUntil(line, key, {' ', '{'}, pos)
  if line[pos] == '{':
    pos.inc # skip "{"
    pos += parseUntil(line, params, {'}'}, pos)
    pos.inc # skip "}"
    pos += skipWhitespace(line, pos)
    value = line[pos .. ^1]
  elif line[pos] == ' ':
    pos.inc # skip " "
    value = line[pos .. ^1]
  return MetricsLine(key: key, value: value, params: parseParams(params))


iterator parseMetrics*(str: string): MetricsLine =
  ## parses all metrics.
  for lineRaw in str.splitLines():
    if lineRaw.len == 0: continue
    if lineRaw.startsWith("#"): continue
    let line = lineRaw.strip(leading = true, trailing = false)
    if line.len == 0: continue
    yield parseMetricsLine(line)



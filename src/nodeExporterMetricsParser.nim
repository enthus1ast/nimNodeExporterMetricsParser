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


when isMainModule:

  let t = """
# HELP node_filesystem_size_bytes Filesystem size in bytes.
# TYPE node_filesystem_size_bytes gauge
node_filesystem_size_bytes{device="/dev/nvme0n1p2",fstype="vfat",mountpoint="/boot/efi"} 1.00663296e+08
node_filesystem_size_bytes{device="/dev/nvme0n1p6",fstype="ext4",mountpoint="/"} 9.43515758592e+11
node_filesystem_size_bytes{device="gvfsd-fuse",fstype="fuse.gvfsd-fuse",mountpoint="/run/user/1000/gvfs"} 0
node_filesystem_size_bytes{device="simulide",fstype="fuse.simulide",mountpoint="/tmp/.mount_simuli9L9R9r"} 0
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run"} 6.709481472e+09
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/lock"} 5.24288e+06
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/qemu"} 3.3547390976e+10
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/user/1000"} 6.709477376e+09
node_scrape_collector_duration_seconds{collector="filesystem"} 0.000490838
node_scrape_collector_success{collector="filesystem"} 1
node_sockstat_FRAG6_inuse 0
# HELP node_sockstat_FRAG_inuse Number of FRAG sockets in state inuse.
# TYPE node_sockstat_FRAG_inuse gauge
node_sockstat_FRAG_inuse 0
# HELP node_sockstat_RAW6_inuse Number of RAW6 sockets in state inuse.
# TYPE node_sockstat_RAW6_inuse gauge
node_sockstat_RAW6_inuse 1
# HELP node_sockstat_RAW_inuse Number of RAW sockets in state inuse.
# TYPE node_sockstat_RAW_inuse gauge
node_sockstat_RAW_inuse 0
  """


  # for metricsLine in parseMetrics(readFile("/tmp/stats")):
  for metricsLine in parseMetrics(t):
    echo metricsLine

import nodeExporterMetricsParser

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

for metricsLine in parseMetrics(t):
  echo metricsLine


#!/bin/bash -xe

# reset build/mainfs contents
rsync -av --delete build/mainfs.orig/ build/mainfs/

# Binary patch /bin/openrg

# replace: '(fw_br0_in\n            (description())\n            (type(2))\n            (output(0))\n            (rule\n              (0\n                (enabled(1))'
#    with: '(fw_br0_in\n            (description())\n            (type(2))\n            (output(0))\n            (rule\n              (0\n                (enabled(0))'

xxd -p < build/mainfs/bin/openrg | tr -d '\n' | \
  sed 's/\(2866775f6272305f696e0a202020202020202020202020286465736372697074696f6e2829290a2020202020202020202020202874797065283229290a202020202020202020202020286f7574707574283029290a2020202020202020202020202872756c650a202020202020202020202020202028300a2020202020202020202020202020202028656e61626c6564\)28312929/\128302929/' | \
  xxd -p -r > build/mainfs/bin/openrg.tmp && cp build/mainfs/bin/openrg.tmp build/mainfs/bin/openrg && rm build/mainfs/bin/openrg.tmp

# replace: '(fw_br1_in\n            (description())\n            (type(2))\n            (output(0))\n            (rule\n              (0\n                (enabled(1))'
#    with: '(fw_br1_in\n            (description())\n            (type(2))\n            (output(0))\n            (rule\n              (0\n                (enabled(0))'

#xxd -p < build/mainfs/bin/openrg | tr -d '\n' | \
#  sed 's/\(2866775f6272315f696e0a202020202020202020202020286465736372697074696f6e2829290a2020202020202020202020202874797065283229290a202020202020202020202020286f7574707574283029290a2020202020202020202020202872756c650a202020202020202020202020202028300a2020202020202020202020202020202028656e61626c6564\)28312929/\128302929/' | \
#  xxd -p -r > build/mainfs/bin/openrg.tmp && cp build/mainfs/bin/openrg.tmp build/mainfs/bin/openrg && rm build/mainfs/bin/openrg.tmp


# replace: '(permissions\n          (mgt(1))\n          (fs(1))\n        )'
#    with: '(permissions\n          (mgt(1))\n          (fs(1))\n(ssh(1)))'

xxd -p < build/mainfs/bin/openrg | tr -d '\n' | \
  sed 's/\(287065726d697373696f6e730a20202020202020202020286d6774283129290a20202020202020202020286673283129290a\)202020202020202029/\1287373682831292929/' | \
  xxd -p -r > build/mainfs/bin/openrg.tmp && cp build/mainfs/bin/openrg.tmp build/mainfs/bin/openrg && rm build/mainfs/bin/openrg.tmp

# replace: '))\n    )\n    (remote_access(1))\n    '
#    with: '))\n)\n(enabled(1))(remote_access(1))\n'

xxd -p < build/mainfs/bin/openrg | tr -d '\n' | \
  sed 's/29290a20202020290a202020202872656d6f74655f616363657373283129290a20202020/29290a290a28656e61626c6564283129292872656d6f74655f616363657373283129290a/' | \
  xxd -p -r > build/mainfs/bin/openrg.tmp && cp build/mainfs/bin/openrg.tmp build/mainfs/bin/openrg && rm build/mainfs/bin/openrg.tmp

# bin/openrg and lib/libssh.so - use /bin/sh as shell instead of ssh_cli for SSH connections (optional)

# replace: '/bin/ssh_cli'
#    with: '/bin/sh     '

xxd -p < build/mainfs/bin/openrg | tr -d '\n' | \
  sed 's/2f62696e2f7373685f636c69/2f62696e2f73680000000000/' | \
  xxd -p -r > build/mainfs/bin/openrg.tmp && cp build/mainfs/bin/openrg.tmp build/mainfs/bin/openrg && rm build/mainfs/bin/openrg.tmp

xxd -p < build/mainfs/lib/libssh.so | tr -d '\n' | \
  sed 's/2f62696e2f7373685f636c69/2f62696e2f73680000000000/' | \
  xxd -p -r > build/mainfs/lib/libssh.so.tmp && cp build/mainfs/lib/libssh.so.tmp build/mainfs/lib/libssh.so && rm build/mainfs/lib/libssh.so.tmp


# Copy autostart script, replace bin/pluto binary with symlink to autostart

cp files/autostart build/mainfs
rm build/mainfs/bin/pluto
ln -s ../autostart build/mainfs/bin/pluto

# Make room for OpenWrt busybox by removing some binaries
rm build/mainfs/bin/bgpd
rm build/mainfs/bin/ospfd
rm build/mainfs/bin/zebra

# Copy OpenWrt busybox, create wget symlink

cp build/rootfs-openwrt/squashfs-root/bin/busybox build/mainfs/bin/busybox.openwrt
ln -s busybox.openwrt build/mainfs/bin/wget

# netcat shell
#cp files/netcat files/netcat-shell build/mainfs

# misc
#cp files/disable-services build/mainfs

#!/bin/bash -xe

[[ -d dl ]] || mkdir dl

# Download OpenWRT Backfire 10.03.1 mips image (for busybox binary)

if ! [[ -f dl/openwrt-lantiq-danube-NONE-squashfs.image.squashfs ]]; then

  curl https://archive.openwrt.org/backfire/10.03.1/lantiq_danube/openwrt-lantiq-danube-NONE-squashfs.image \
    -o dl/openwrt-lantiq-danube-NONE-squashfs.image.tmp

  [[ $(shasum -a 256 dl/openwrt-lantiq-danube-NONE-squashfs.image.tmp | cut -d' ' -f1) == \
    "8a5f5f201e77a5f933599e666f86f627e440960d173db61f3faaef61a6c1ce94" ]] && \
      mv dl/openwrt-lantiq-danube-NONE-squashfs.image.tmp \
        dl/openwrt-lantiq-danube-NONE-squashfs.image

  # $ binwalk dl/openwrt-lantiq-danube-NONE-squashfs.image
  #
  # DECIMAL       HEXADECIMAL     DESCRIPTION
  # --------------------------------------------------------------------------------
  # 0             0x0             uImage header, header size: 64 bytes, header CRC: 0xC289462F, created: 2011-12-21 07:05:28, image size: 898609 bytes, Data Address: 0x80002000, Entry Point: 0x80002000, data CRC: 0x9C139830, OS: Linux, CPU: MIPS, image type: OS Kernel Image, compression type: lzma, image name: "MIPS OpenWrt Linux-2.6.32.33"
  # 64            0x40            LZMA compressed data, properties: 0x5D, dictionary size: 8388608 bytes, uncompressed size: 2779300 bytes
  # 898673        0xDB671         Squashfs filesystem, little endian, version 4.0, compression:lzma, size: 1434698 bytes, 913 inodes, blocksize: 131072 bytes, created: 2011-12-21 07:06:08
  #

  dd bs=898673 skip=1 \
    if=dl/openwrt-lantiq-danube-NONE-squashfs.image \
    of=dl/openwrt-lantiq-danube-NONE-squashfs.image.squashfs

fi

echo "Success!"

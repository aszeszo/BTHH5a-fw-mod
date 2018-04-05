#!/bin/bash -xe

[[ -d build/rootfs-openwrt ]] && rm -rf build/rootfs-openwrt

mkdir -p build/rootfs-openwrt

pushd build/rootfs-openwrt

unsquashfs ../../dl/openwrt-lantiq-danube-NONE-squashfs.image.squashfs

popd

echo "Success!"

#!/bin/bash -xe

. 0-vars

# remove OpenRG header (640 bytes), decrypt the file, remove uImage header (64 bytes)

#dd if=dl/bt_prod_sec.enc.rms-${fw_version} bs=640 skip=1 | \
#  openssl enc -d -aes-256-cbc -K 3E4CA8114D15BFC653B2BF9519EF2B94200E30345503B125C1D0BE776698B950 -iv 00000000000000000000000000000000 -nopad | \
#  cat > build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma.u-boot

dd if=dl/bt_prod_sec.enc.rms-${fw_version} bs=640 skip=1 | \
  openssl enc -d -aes-256-cbc -K 3E4CA8114D15BFC653B2BF9519EF2B94200E30345503B125C1D0BE776698B950 -iv 00000000000000000000000000000000 -nopad | \
  dd bs=64 skip=1 \
  > build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma.tmp

# trim last 8 bytes

dd if=build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma.tmp \
  bs=$(($(stat -c %s build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma.tmp)-8)) \
  > build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma

rm build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma.tmp

# unlzma

lzma_alone d build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma \
  build/openrg-kernel+initramfs+mainfs+modfs.orig

rm build/openrg-kernel+initramfs+mainfs+modfs.orig.lzma

# $ binwalk build/openrg-kernel+initramfs+mainfs+modfs.orig
#
# DECIMAL       HEXADECIMAL     DESCRIPTION
# --------------------------------------------------------------------------------
# ...
# 4845568       0x49F000        gzip compressed data, maximum compression, from Unix, last modified: 2017-04-11 12:24:39
# 4861952       0x4A3000        CramFS filesystem, little endian, size: 9568256 version 2 sorted_dirs CRC 0x7664E22F, edition 0, 880 blocks, 583 files
# 14430208      0xDC3000        CramFS filesystem, little endian, size: 1376256 version 2 sorted_dirs CRC 0x57413A5E, edition 0, 89 blocks, 43 files

# kernel, minus embedded initramfs, mainfs and modfs images
dd if=build/openrg-kernel+initramfs+mainfs+modfs.orig bs=${pos1} count=1 of=build/openrg-kernel.orig

# initramfs - contains mostly symlinks to files in /mnt/cramfs
dd if=build/openrg-kernel+initramfs+mainfs+modfs.orig bs=${pos1} skip=1 of=build/openrg-initramfs.orig.tmp
dd if=build/openrg-initramfs.orig.tmp bs=$((pos2-pos1)) count=1 of=build/openrg-initramfs.orig
rm build/openrg-initramfs.orig.tmp

# cramfs_mainfs - mounted at /mnt/cramfs at runtime
dd if=build/openrg-kernel+initramfs+mainfs+modfs.orig bs=${pos2} skip=1 of=build/openrg-mainfs.orig.tmp
dd bs=$((pos3-pos2)) count=1 if=build/openrg-mainfs.orig.tmp of=build/openrg-mainfs.orig
rm build/openrg-mainfs.orig.tmp

# cramfs_modfs - contains most of the kernel modules, mounted at /mnt/modfs at boot time, unmounted after the modules are loaded
dd if=build/openrg-kernel+initramfs+mainfs+modfs.orig bs=${pos3} skip=1 of=build/openrg-modfs.orig

# extract mainfs
[[ -d build/mainfs.orig ]] && rm -rf build/mainfs.orig

build/lzma-uncramfs/lzma-uncramfs build/mainfs.orig build/openrg-mainfs.orig

echo "Success!"

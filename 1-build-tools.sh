#!/bin/bash -xe

[[ -d build ]] || mkdir build

# Build lzma-uncramfs

[[ -d build/lzma-uncramfs ]] || \
  git clone https://github.com/digiampietro/lzma-uncramfs.git build/lzma-uncramfs

[[ -x build/lzma-uncramfs/lzma-uncramfs ]] || \
  (cd build/lzma-uncramfs; make)

# Build mkcramfs-lzma

[[ -d build/mkcramfs-lzma ]] || \
  git clone https://github.com/appleorange1/mkcramfs-lzma.git build/mkcramfs-lzma

[[ -x build/mkcramfs-lzma/mkcramfs-lzma ]] || \
  (cd build/mkcramfs-lzma; make)

echo "Success!"

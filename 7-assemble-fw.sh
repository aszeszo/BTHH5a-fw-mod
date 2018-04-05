#!/bin/bash -ex

#T=100; (for i in `seq 1 $T`; do echo -n x; sleep 0.5; done) | pv -s $T -w 80 -F "%p" > /dev/null &

. 0-vars

# Ganerate CramFS image

fakeroot build/mkcramfs-lzma/mkcramfs-lzma -b 65536 -c lzma build/mainfs build/openrg-mainfs

[[ $(stat -c %s build/openrg-mainfs) -gt $(stat -c %s build/openrg-mainfs.orig) ]] && \
  echo CramFS image is too big. Aborting. && exit 1


# pad the image

bs=$(($(stat -c %s build/openrg-mainfs.orig)-$(stat -c %s build/openrg-mainfs)))

[[ $bs -gt 0 ]] && \
  dd if=/dev/zero bs=$bs count=1 >> build/openrg-mainfs

[[ -d image ]] || mkdir image

cat build/openrg-kernel.orig \
    build/openrg-initramfs.orig \
    build/openrg-mainfs \
    build/openrg-modfs.orig \
  > image/OpenRG-modified.bin.tmp

#mkimage \
#  -A mips -O linux -T kernel -C none -a 0x80002000 -e ${entry_point} -n 'OpenRG (modified)' \
#  -d image/OpenRG-modified.bin.tmp \
#  image/OpenRG-modified.bin

# lzma compressed variant
lzma_alone e \
  -lc1 -lp2 -pb2 \
  image/OpenRG-modified.bin.tmp \
  image/OpenRG-modified.bin.tmp.lzma

mkimage \
  -A mips -O linux -T kernel -C lzma -a 0x80002000 -e ${entry_point} -n 'OpenRG (modified)' \
  -d image/OpenRG-modified.bin.tmp.lzma \
  image/OpenRG-modified.bin.lzma

rm image/OpenRG-modified.bin.tmp.lzma 

rm image/OpenRG-modified.bin.tmp

#kill $! 2> /dev/null; trap 'kill $! 2>/dev/null' SIGTERM

./http-server.sh

#!/bin/bash

#echo 'cd /tmp && /mnt/cramfs/bin/wget http://192.168.1.10:8000/OpenRG-modified.bin      && ubiupdatevol /dev/ubi0_1 -t; ubiupdatevol /dev/ubi0_1 OpenRG-modified.bin      && echo system reboot | ssh_cli'
echo 'cd /tmp && /mnt/cramfs/bin/wget http://192.168.1.10:8000/OpenRG-modified.bin.lzma && ubiupdatevol /dev/ubi0_1 -t; ubiupdatevol /dev/ubi0_1 OpenRG-modified.bin.lzma && echo system reboot | ssh_cli'

cd image

python -m SimpleHTTPServer

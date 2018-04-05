#!/bin/bash -xe

. 0-vars

[[ -d dl ]] || mkdir dl

# Download stock firmware

if ! [[ -f dl/bt_prod_sec.enc.rms-${fw_version} ]]; then

  curl ${fw_url} \
    -o dl/bt_prod_sec.enc.rms-${fw_version}.tmp

  [[ $(shasum -a 256 dl/bt_prod_sec.enc.rms-${fw_version}.tmp | cut -d' ' -f1) == \
    "${fw_sum}" ]] && \
      mv dl/bt_prod_sec.enc.rms-${fw_version}.tmp \
        dl/bt_prod_sec.enc.rms-${fw_version}

fi

echo "Success!"

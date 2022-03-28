#!/bin/bash

# Script to emulate a PipeLine (these commands can be migrated later to AWS or any other Cloud)

echo Build started on `date`
SBC_ROOT_HASH_PASSWORD=$(openssl passwd -6 -salt $(tr -dc A-Za-z0-9 </dev/urandom | head -c 8) nucPassw0rd)

sed -i "s#THE_PASSWORD#$SBC_ROOT_HASH_PASSWORD#g" user-data

./isogen.sh NucProv ubuntu-20.04.3-live-server-amd64.iso
./genauto.sh NucProv user-data NUC-net-$(date +%Y%m%d%H%m).iso

mv NUC-net-$(date +%Y%m%d%H%m).iso NUC-net-latest.iso 
mv NUC-auto-$(date +%Y%m%d%H%m).iso NUC-auto-latest.iso

ls -lah


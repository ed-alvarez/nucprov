#!/bin/bash

SBC_ROOT_HASH_PASSWORD=$(openssl passwd -6 -salt $(tr -dc A-Za-z0-9 </dev/urandom | head -c 8) nucPassw0rd)
sed -i "s#THE_PASSWORD#$SBC_ROOT_HASH_PASSWORD#g" user-data

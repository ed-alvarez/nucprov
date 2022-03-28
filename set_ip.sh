#!/bin/bash

# First parameter: Client name
# Second parameter: Unique VPN Address

if [[ "$#" -ne 2 ]] ; then
  echo "ERROR: Wrong number of parameters"
  echo 
  echo "Usage: ./set_ip.sh DeviceName VPN-IP"
  echo 
  exit 1
fi

echo "ifconfig-push $2 255.255.0.0" > /etc/openvpn/ccd/$1

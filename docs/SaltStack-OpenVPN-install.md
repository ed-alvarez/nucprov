## Steps to install SaltStack and OpenVPN on Ubuntu 20.04

Please follow these instructions:

* SaltStack: 

https://docs.saltproject.io/en/latest/topics/installation/ubuntu.html

* OpenVPN: 

https://serverspace.io/support/help/install-openvpn-server-on-ubuntu-20-04/

After you finished (the script is straight forward), please edit `/etc/openvpn/server.conf`, locate this line and comment it out with a ";"

`;push "redirect-gateway def1 bypass-dhcp"`

Next, add this line

`client-to-client`

Then restart the OpenVPN server by issuing

`systemctl restart openvpn@server.service`

### All the mentioned scripts and credentials are inside /root

To create user credentials or profiles, run again the script `./openvpn-install.sh` and follow the instructions

To assign a fixed IP inside the VPN for a node, run the command `set_ip.sh` this way.

./set_ip.sh $NODE_NAME $IP_ON_VPN

Where NODE_NAME is the unique client name you used to create the credentials (please assign values from 10.8.0.16 and up, please also keep a record of the assigned IPs to avoid assigning them twice)


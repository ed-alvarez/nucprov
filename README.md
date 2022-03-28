# Scripts to generate a custom, provisioned, auto-installer ISO

- The generated ISO will have installed (via ansible) all the dependecies needed to run
  the NUC/SBC related applications, it will also carry the "last stage" playbooks with 
  the minimal human intervention.

- This script have two parameters, the first one is the folder to uncompress the original
  image file, the second one is the ISO file to customize (if the file does not exist in
  the given path, it will download Ubuntu 20.04 from the official URL)

  Example: ./isogen.sh folder iso-file

  It will generate a resultant file called "NUC-net-YYMMHHMM.iso" on the current folder, 
  that image should be copied to `NUC-net-latest.iso`, which is ready to use on PXE with 
  the respective `user-data` file available

- In the second optional step to generate an autoinstall image we shold use `genauto.sh` 
  which takes three parameters, first the folder to uncompress the resultant `.iso` file 
  (third parameter) from `isogen.sh`, the second one is the `user-data` file to inject, 
  it will generate a new image file called `NUC-auto-YYMMHHMM.iso`"

  Example: ./genauto.sh folder user-data-file NUC-net-YYMHHMM.iso

  Please note the resultant image from `genauto.sh` is suitable only for image based setups 
  and SHOULD NOT be used on PXE, for that case we need to use `NUC-net-latest.iso`

# Playbooks inside this repo are for:

- PXE Server
- Base image customization
- Last stage  provisioning steps
- Final configuration to go Production 

Once the device is provisioned on the first stage, we need to enter via console with the given 
credentials and run the second provisioning stage.

```
sudo -i
cd /root/provision
ansible-playbook stage-two-yaml
reboot
```

On next boot you will see on the GUI the Broadsign Player asking for registration (in full screen), the resultant provisioned image could be cloned, but bare in mind that a set of manual customization should be needed, such as OpenVPN client profile and `salt-minion` id.

Now you should go to a SaltStack Master and register the minion, which should have a name similar to `nprov-aabbccddeeff` listed as `Unaccepted Keys`:, where "aabbccddeeff" is the device MAC Address related to the Ethernet interface.

Inside the SaltMaster console as root, you shoud issue this set of commands.
```
# salt-key
Accepted Keys:
Denied Keys:
Unaccepted Keys:
nprov-nprov-aabbccddeeff
Rejected Keys:
```

Then proceed to register the "unaccepted" minion_id
```
# salt-key -a nprov-aabbccddeeff
The following keys are going to be accepted:
Unaccepted Keys:
nprov-aabbccddeeff
Proceed? [n/Y] y
Key for minion nprov-aabbccddeeff accepted.
```

Test if the minion is connected

```
# salt 'nprov-aabbccddeeff' test.ping
nprov-aabbccddeeff:
    True
# salt-key
Accepted Keys:
nprov-aabbccddeeff
Denied Keys:
Unaccepted Keys:
Rejected Keys:

```

Now you can upload the OpenVPN profile for the client generated on the OpenVPN server
(it could be a good idea to setup on the same server which is running SaltMaster on 
behalf of simplicity) and reboot

```
# salt-cp nprov-aabbccddeeff nuc-node-name.ovpn /etc/openvpn/client.conf
# salt 'nprov-aabbccddeeff' cmd.run reboot
```

# Under /docs we will find some more detailed documentation about all related provisioning steps.


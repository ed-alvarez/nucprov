# Scripts to generate a custom, provisioned, auto-installer ISO

- The generated ISO will install (via ansible) all the dependencies needed to run
  the NUC/SBC software. It will also carry "last stage" playbooks with minimal 
  human intervention.

- This script has two parameters. The first one is the folder to uncompress the original
  image file into. The second parameter is the ISO file to customize (if the file does not exist in
  the given path, it will download Ubuntu 20.04.03 from the official URL). Example:

  ```
  $ cd nucprov
  $ mkdir temporal-folder
  $ ./isogen.sh ./temporal-folder ubuntu-image.iso
  ```

  After the script is done, an image named "NUC-net-YYMMHHMM.iso" will be generated in the root of the
  current folder (nucprov).

  **NOTE: The generated image should be renamed to `NUC-net-latest.iso` in order to be automatically
  picked up by the PXE setup scripts located under the folder `pxe-playbooks`.**

<br />

## (Optional) Generate an autoinstall image for "PXE-less" setups

We can also generate an autoinstall image for setups that do not require a PXE
server and want to be used in virtual or temporal environments (installed via USBs, virtualized, etc).

To achieve this, we can use the script `genauto.sh`. This script takes three parameters.
The first one is the folder to uncompress a temporal Ubuntu image ISO into for further
customization. The second one is a `user-data` file to inject (You can find an example file under
the root of this folder (nucprov) or a generated one after creating the PXE server in the `pxe-playbooks` folder). 
The third parameter is the image generated with the `isogen.sh` script. Example:

**NOTE: You can only use ./genauto.sh after creating a PXE server. For further details refer to the document `docs/Steps-to-create-and-configure-PXE-with-EFI`.**

```
$ cd nucprov
$ mkdir temporal-folder
$ ./genauto.sh ./temporal-folder ./pxe-playbooks/user-data ./NUC-net-YYMHHMM.iso
```

**Please note the resultant image from `genauto.sh` is suitable only for image-based setups 
and SHOULD NOT be used on PXE servers. For PXE server setups we need to use the image generated with the `isogen.sh`
only.**

<br />

# Playbooks inside this repo are for:

- PXE server creation
- Base image customization
- Last stage provisioning steps
- Final configuration to go to production

Once the device is provisioned on the first stage, we need to access said device via console with the given 
credentials and run the second provisioning stage.

```
$ sudo -i
# cd /root/provision
# ansible-playbook stage-two.yaml
```

**After the `stage-two.yaml` playbook finishes running. We need to reboot the device:**

```
# reboot
```

After rebooting, you will see Ubuntu Desktop has been installed and after 5 to 10 seconds, Broadsign Control Player will
open. Proceed with the registration of the device requested by Broadsign:

<center>
  <img src="https://docs.broadsign.com/broadsign-control/14-0/Resources/Images/quick-start-player-registration-v14.png" />
</center>

# Setting up further "control" services

In order to control our device remotely without intrusion, we need to set up an OpenVPN client and a salt-minion id. A salt-minion is already configured
by our Ansible playbooks into the NUC device and has the following name/format: `nprov-aabbccddeeff`. "aabbccddeeff" is the device MAC address related to the Ethernet interface.

After our device has finished rebooting for the first time after applying the `stage-two.yml` playbook, the SaltStack minion automatically
provisioned by our scripts, will request our SaltMaster to be approved.

Go to your SaltStack Master and register the minion, which should have a name similar to `nprov-aabbccddeeff` listed as `Unaccepted Keys`. Run the following
commands:

```
# salt-key
Accepted Keys:
Denied Keys:
Unaccepted Keys:
nprov-aabbccddeeff
Rejected Keys:
```

Here we can see our minion requesting to be registered.

Proceed to register the "unaccepted" minion by running the following command:

```
# salt-key -a nprov-aabbccddeeff
The following keys are going to be accepted:
Unaccepted Keys:
nprov-aabbccddeeff
Proceed? [n/Y] y
Key for minion nprov-aabbccddeeff accepted.
```

**(Optional)** Check if the minion is listed as registered by running:

```
# salt-key
Accepted Keys:
nprov-aabbccddeeff
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

You should see our minion in the `Accepted Keys` section.

Test the connection to the minion:

```
# salt 'nprov-aabbccddeeff' test.ping
nprov-aabbccddeeff:
    True
```

After our minion is set, we need to set up our OpenVPN server and upload our 
OpenVPN profile to our registered minion:

```
$ sudo ./openvpn-install.sh
$ sudo ./set_ip.sh DeviceName VPN_IP
```

The set of commands above will install an OpenVPN server and generate an OpenVPN profile.

**NOTE: Newly generated OpenVPN profiles will be saved into the root of your home folder.**

**NOTE 2: You can use the `openvpn-install.sh` script and select the first option to generate new OpenVPN profiles:**

> ```
> $ sudo ./openvpn-install.sh
> Welcome to OpenVPN-install!
>The git repository is available at: https://github.com/angristan/openvpn-install
>
>It looks like OpenVPN is already installed.
>
>What do you want to do?
>   1) Add a new user
>   2) Revoke existing user
>   3) Remove OpenVPN
>   4) Exit
>Select an option [1-4]: 1
>```

Now we need to upload said generated profile to our registered minion:

```
$ sudo salt-cp "nprov-aabbccddeeff" $HOME/DeviceName.ovpn /etc/openvpn/client.conf
$ sudo salt "nprov-aabbccddeeff" cmd.run reboot
```

To access from a personal computer, that computer must also have an OpenVPN profile. Create one using the same method as above 
and transfer the OpenVPN profile to the personal computer! 178.62.43.104 is the IP of the Digital Ocean "droplet"

```
scp root@178.62.43.104:/root/DeviceName.ovpn ~/Downloads
```

Finally, test your OpenVPN connection. You can access VidiReports via the following URL:

```
https://10.8.0.$IP_ON_VPN:9443
```

<br />

# Under the /docs folder you will find more detailed documentation about all related provisioning steps.

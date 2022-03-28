

### This setup is minded to be done in a device TWO ethernet cards, the main one (`enp3s0`) facing internet, and the other one (`eno1`) is where the provisioning clients would be connected to. (Please note network interface names could change on certain hardware)

** Using network interfaces on different order will lead to errors, you must determine that at the Ubuntu installer, please keep `eno1` disconnected while installing. (Please note network interface names could change on certain hardware)

** For more details you can inspect the ansible playbooks and files inside `pxe-playbooks` 

#### Download the official Ubuntu Server 20.04 LTS from [here](https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso) and burn it using [Balena Etcher](https://www.balena.io/etcher/), then proceed to do a normal install.

* IMPORTANT NOTE: Please ensure you check "Install OpenSSH Server" (SSH Setup step) after finishing "Profile Setup", DO NOT select any application at the step "Featured Server Snaps".

### After the Ubuntu Server 20.04 LTS setup, enter the console with the user's credentials you created during installation and install the required packages.
```
sudo apt update && sudo apt -y install aptitude ansible git git-lfs
```

### Clone repository locally (Please ensure $YOUR-KEY-AT-GITHUB is accessible, the better way is by uploading it to the PXE server via SCP)
```
eval $(ssh-agent -s)
ssh-add $YOUR-KEY-AT-GITHUB
git clone git@github.com:EWCHRG/nucprov.git
```

### Create base image
```
sudo su
cd nucprov
./buildcommands.sh
```

### Please be patient, the first time this proccess could take around 10 minutes or more, depending on your internet speed.

## PLEASE READ THIS BEFORE CONTINUE !!!

** IMPORTANT NOTE: Edit `pxe-playbooks/00-installer-config.yaml` to match your interface names
Ubuntu give names to interfaces based on vendors, and in the case of USB adapters such as USB to Ethernet and LTE dongles, it use a naming convention like
`enx00e04c70e286` where `00e04c70e286` is the device mac address.

Same way you need to edit the file `pxe-playbooks/final-commands.yaml` to replace `enp3s0` to match the internet facing interface name

Please ensure secondary network interface (`eno1` in this case), is connected to the provisioning switch before running the `pxe-playbooks/create-pxe.yaml` playbook, that is needed to avoid failures on the execution on the "Forwarding Masquerade and Restart Services" task.

### Then get into the pxe-playbooks folder, and execute the required playbook to create the whole environment. 
```
cd pxe-playbooks
./set-pass.sh
ansible-playbook create-pxe.yaml
reboot
```
### After boot, you should be able to provision any NUC (or similar hardware) by connecting it to the "serving/secondary" interface.

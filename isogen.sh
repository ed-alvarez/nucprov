#!/bin/bash

# Check if all parameters are present
# $1 - Folder to extract the ISO
# $2 - ISO to install de software dep.

IMAGE_FILE=$2

if [[ "$#" -ne 2 ]] ; then
  echo "ERROR: Wrong number of parameters"
  echo
  echo "Usage ./isogen.sh folder iso-file"  
  echo
  exit 1
fi

# Download the image (optional)
if [[ ! -f $2 ]] ; then
  echo "Image file not found, downloading Ubuntu Server 20.04 Live Server"
  echo 
  wget https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso
  IMAGE_FILE="ubuntu-20.04.3-live-server-amd64.iso"
fi

# Install all needed tools
 apt update
 apt install -y xorriso p7zip-full fakeroot binutils isolinux squashfs-tools

 rm -rf $1 && mkdir -p $1

xorriso -osirrox on -indev "$IMAGE_FILE" -extract / $1
chmod -R +w $1

cd $1
unsquashfs casper/filesystem.squashfs
mount --bind /dev/ squashfs-root/dev

# Inject playbooks and assets
cp -ax ../provision squashfs-root/root
cp -ax ../bsqv-setup squashfs-root/root
cp ../assets.tar.gz squashfs-root/root

chroot squashfs-root/<<_Provision_
mount -t proc none /proc
mount -t sysfs none /sys 
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
dbus-uuidgen > /var/lib/machine_id && dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
rm /etc/resolv.conf && echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt update && apt -y install aptitude ansible
ansible-galaxy collection install community.general
cd /root/provision && ansible-playbook stage-one.yaml && cd
apt clean
truncate -s 0 /etc/machine-id
rm /etc/resolv.conf && cd /etc && ln -s ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
umount /proc 
umount /sys
umount /dev/pts
echo "Chroot finished!"
cat /dev/null > ~/.bash_history
_Provision_

echo "Doing clean up"

# Clean up and recreate the ISO
 rm casper/filesystem.squashfs
 mksquashfs squashfs-root casper/filesystem.squashfs
 umount squashfs-root/dev
 rm -rf squashfs-root/

cd ../
mv $1/ubuntu .
(cd $1; find '!' -name "md5sum.txt" '!' -path "./isolinux/*" -follow -type f -exec "$(which md5sum)" {} \; > ../md5sum.txt)
mv md5sum.txt $1/
mv ubuntu $1

xorriso -as mkisofs -r -V NUCSBC -o "NUC-net-$(date +%Y%m%d%H%m).iso" -J \
-l -b isolinux/isolinux.bin -c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot  \
-isohybrid-gpt-basdat -isohybrid-apm-hfsplus  \
-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin $1/boot $1

rm -rf $1


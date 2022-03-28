#!/bin/bash
#
# Script to generate an auto installer version of  
# custom ISO already provisioned  

# Check if all parameters are present
# $1 - Folder to extract the ISO
# $2 - File to instert as "user-data"
# $3 - ISO to convert into autoinstall


if [[ "$#" -ne 3 ]] ; then
  echo "ERROR: Wrong number of parameters"
  echo
  echo "Usage ./genauto.sh folder user-data iso-file"  
  echo
  exit 1
fi

if [[ ! -f $3 ]] ; then
  echo "ERROR: Image file not found"
  exit 1
fi

if [[ ! -f $2 ]] ; then
  echo "ERROR: user-data file not found"
  exit 1  
fi

# Extract the ISO for customization
rm -rf $1
mkdir -p $1/nocloud/

xorriso -osirrox on -indev "$(basename $3)" -extract / $1 && chmod -R +w $1

# Create empty meta-data file:
touch $1/nocloud/meta-data

# Copy the auto install file into respective folder
cp $2 $1/nocloud/user-data

# Set flags at GRUB to make autoinstall possible
sed -i 's|---|autoinstall ds=nocloud\\\;s=/cdrom/nocloud/ ---|g' $1/boot/grub/grub.cfg
sed -i 's|---|autoinstall ds=nocloud;s=/cdrom/nocloud/ ---|g' $1/isolinux/txt.cfg

# Recreate the checksum
mv $1/ubuntu .
(cd $1; find '!' -name "md5sum.txt" '!' -path "./isolinux/*" -follow -type f -exec "$(which md5sum)" {} \; > ../md5sum.txt)
mv md5sum.txt $1/
mv ubuntu $1

xorriso -as mkisofs -r \
  -V NUCSBC \
  -o "NUC-auto-$(date +%Y%m%d%H%m).iso" \
  -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
  -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin  \
  $1/boot $1

rm -rf $1


#!/bin/sh
IMGDIR=$1
dd if=/dev/zero of=$IMGDIR/usb-installer.img bs=512 count=100000 2>&1 > /dev/null
echo "o\nn\np\n1\n\n\na\n1\nw\n" | fdisk $IMGDIR/usb-installer.img 2>&1 > /dev/null
dd if=$IMGDIR/mbr.bin of=$IMGDIR/usb-installer.img conv=notrunc 2>&1

MP=$IMGDIR/mnt
mkdir $MP

sudo kpartx -av $IMGDIR/usb-installer.img
sudo mkfs.ext4 /dev/mapper/loop0p1
sudo mount /dev/mapper/loop0p1 $MP
sudo extlinux -i $MP
sudo cp $IMGDIR/bzImage board/etf/puc/syslinux.cfg $MP
sudo cp $IMGDIR/rootfs.cpio.bz2 $MP/rootfs
# TODO - copy rootfs to install into image
sudo cp $IMGDIR/rootfs.tar.bz2 $MP/
sudo umount $MP
sudo kpartx -d $IMGDIR/usb-installer.img
rmdir $MP

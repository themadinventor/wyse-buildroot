#!/bin/sh
# kongo 140601

install ()
{
	echo Formatting flash disk
	echo -e "o\nn\np\n1\n\n\na\n1\nw\n" | fdisk /dev/sda 2>/dev/null >/dev/null
	mkfs.ext4 /dev/sda1 2>/dev/null > /dev/null

	echo Mounting file systems
	mkdir -p /mnt/target
	mount /dev/sda1 /mnt/target
	mkdir -p /mnt/usb
	mount /dev/sdb1 /mnt/usb

	echo Unpacking root file system
	cd /mnt/target
	bzcat /mnt/usb/rootfs.tar.bz2 | tar xf -

	echo Installing bootloader
	cat /usr/share/syslinux/mbr.bin > /dev/sda
	mkdir /mnt/target/boot
	extlinux -i /mnt/target/boot/ 2>/dev/null >/dev/null

	echo Unmounting file systems
	cd /
	umount /mnt/target
	umount /mnt/usb

	if [ -e /usr/sbin/puc-flash ]; then
		puc-flash
	fi

	echo
	echo The installer is done\; you may now kiss the bride.
	echo
	echo Remove your USB drive and press Enter to reboot into
	echo your new system, or hit Ctrl-C to return to the menu
	echo and start a shell.
	echo
	read
	reboot
}

reset
echo Welcome to the ETF PUC installer
echo

while true ; do
	echo
	echo
	echo PUC Installer Menu:
	echo 1. Install
	echo 2. Shell
	echo 3. Reboot
	echo
	read opt

	if [ "$opt" = "3" ]; then
		reboot
		echo Good bye.
		read
	elif [ "$opt" = "2" ]; then
		echo
		echo Leave the shell to return to this menu.
		echo
		ash
	elif [ "$opt" = "1" ]; then
		echo
		echo -e "WARNING:\tThis will erase all contents on the internal"
		echo -e "\t\tflash drive. Press Enter to continue or Ctrl-C to"
		echo -e "\t\tabort."
		echo
		read
		install
	else
		echo "Bad option '$opt'. Try again :)"
		echo
	fi
done

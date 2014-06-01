#!/bin/sh
TARGETDIR=$1
cp board/etf/puc/S10printk $TARGETDIR/etc/init.d/
cp board/etf/puc/installer.sh $TARGETDIR/usr/sbin/puc-installer
#echo "console::respawn:/sbin/getty -L -n -l /usr/sbin/puc-installer console 115200 vt100" >> $TARGETDIR/etc/inittab
sed -i -e '/# GENERIC_SERIAL$/s~^.*#~console::respawn:/sbin/getty -L -n -l /usr/sbin/puc-installer console 115200 vt100 #~' \
	$TARGETDIR/etc/inittab

if [ -e board/etf/puc/puc.rom ]; then
	mkdir $TARGETDIR/usr/share/puc
	cp board/etf/puc/puc.rom $TARGETDIR/usr/share/puc/
	cp board/etf/puc/flash-upgrade.sh $TARGETDIR/usr/sbin/puc-flash
fi

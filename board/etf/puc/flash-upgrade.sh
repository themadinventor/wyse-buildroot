#!/bin/sh
# kongo 140601

echo Checking BIOS version...
dd if=/dev/mem bs=1024 skip=960 count=64 of=/tmp/current.bin 2>/dev/null >/dev/null
dd if=/usr/share/puc/puc.rom bs=1024 skip=192 count=64 of=/tmp/available.bin 2>/dev/null >/dev/null

if cmp -s /tmp/current.bin /tmp/available.bin ; then
	echo Reflashing BIOS, do NOT turn off!
	flashrom --programmer internal:laptop=this_is_not_a_laptop -w /usr/share/puc/puc.rom 2>/dev/null >/dev/null
	echo Done
else
	echo Current version already installed.
fi

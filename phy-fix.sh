#!/bin/bash
# tary, 2018-05-23

# set -x

BASE_URL=https://raw.githubusercontent.com/turmary/bbg-phy-fix/master
MLO_BK=/opt/backup/uboot/MLO
SOC=/boot/SOC.sh
VERSION=
FILES="MLO u-boot.img"
TMP=/tmp

uboot_ver_get() {
	local ver
	local uboot_ver
	local YEAR

	ver=201603
	if [ ! -f $MLO_BK ]; then
		echo $ver
		return 0
	fi
	uboot_ver=$(strings $MLO_BK | egrep "U-Boot SPL")
	YEAR=( $( echo $uboot_ver | sed -re 's/U-Boot SPL ([0-9]+)\.([0-9]+).*/\1 \2/g') )
	if [ "${YEAR[0]}" -ge "2017" ]; then
		ver=201803
	fi
	echo $ver
	return 0
}

boot_device_get() {
	local fields
	local line
	local TMPFILE

	TMPFILE=`mktemp`
	mount > $TMPFILE
	while read line; do
		fields=( $line )
		if [ "${fields[2]}" == "/" ]; then
			break
		fi
	done < $TMPFILE
	echo ${fields[0]} | sed -re 's/p[0-9]+//g'
	return 0;
}

file_download() {
	url=$BASE_URL/$VERSION/$1
	wget -O $TMP/$1 $url
	if [ "$?" -ne 0 ]; then
		echo Download file $url error >&2
		return 1
	fi
	return 0;
}

burn_MLO() {
	dd if=$TMP/MLO of=$BOOT_DEV bs=$dd_spl_uboot_bs seek=$dd_spl_uboot_seek count=$dd_spl_uboot_count conv=$dd_spl_uboot_conf
}

burn_UBOOT() {
	dd if=$TMP/u-boot.img of=$BOOT_DEV bs=$dd_uboot_bs seek=$dd_uboot_seek count=$dd_uboot_count conv=$dd_uboot_conf
}

VERSION=$(uboot_ver_get)
BOOT_DEV=$(boot_device_get)

echo U-BOOT Version $VERSION
echo BOOT   Device  $BOOT_DEV

if ! source $SOC; then
	dd_spl_uboot_count=1
	dd_spl_uboot_seek=1
	dd_spl_uboot_conf=notrunc
	dd_spl_uboot_bs=128k

	dd_uboot_count=2
	dd_uboot_seek=1
	dd_uboot_conf=notrunc
	dd_uboot_bs=384k
fi

for f in $FILES; do
	if ! file_download $f; then
		exit 1
	fi
	if [ "$f" == "MLO" ]; then
		burn_MLO
	elif [ "$f" == "u-boot.img" ]; then
		burn_UBOOT
	fi
done

sync
sleep 1
sync

echo "Update U-boot with $VERSION phy fixed successful"
echo "Please reboot your device!"


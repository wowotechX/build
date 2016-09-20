#!/bin/bash

## Get the environment and some variable.
source ./build_env.sh

## Define image type in there
TYPE_INITRAMDISK=ramdisk
TYPE_INITRAMFS=initramfs

## Print the type information
echo "Will generate rootfs image!"
echo "ROOTFS_IMAGE_TYPE is $ROOTFS_IMAGE_TYPE"

## mkdir the out directories for rootfs image.
echo $ROOTFS_OUT_DIR
mkdir -p $ROOTFS_OUT_DIR


## Rootfs need some subdir. So need mkdir in there.
ROOTFS_SUBDIR=(bin dev etc lib proc sbin sys usr mnt tmp var usr/bin usr/lib usr/sbin lib/modules)
for SUBDIR in ${ROOTFS_SUBDIR[*]}
do
	if [ ! -d ${ROOTFS_DIR}/${SUBDIR} ]; then
		mkdir ${ROOTFS_DIR}/${SUBDIR}
	fi
done
cd  ${ROOTFS_DIR};ln -s /sbin/init init


## Generate ramdisk image for rootfs.
if [ "$ROOTFS_IMAGE_TYPE" = "$TYPE_INITRAMDISK" ]; then
	genext2fs -b 4096 -d ${ROOTFS_DIR} ${ROOTFS_OUT_DIR}/${TYPE_INITRAMDISK}
	gzip -9 -f ${ROOTFS_OUT_DIR}/${TYPE_INITRAMDISK}
	${UBOOT_OUT_DIR}/tools/mkimage -n ${BOARD_NAME} -A ${BOARD_ARCH} -O linux -T ramdisk -C gzip -d ${ROOTFS_OUT_DIR}/${TYPE_INITRAMDISK}.gz ${ROOTFS_OUT_DIR}/${TYPE_INITRAMDISK}.img
fi

## Generate cpio initramfs image for rootfs.
if [ "$ROOTFS_IMAGE_TYPE" = "$TYPE_INITRAMFS" ]; then
	cd ${ROOTFS_DIR}; find . | cpio -H newc -o > ${ROOTFS_OUT_DIR}/${TYPE_INITRAMFS}
	gzip ${ROOTFS_OUT_DIR}/${TYPE_INITRAMFS}
fi

## Print it is finish that generate rootfs image.
echo "Generate rootfs image finish."

#!/bin/bash

## Get the environment and some variable.
source ./build_env.sh

## Define image type in there
TYPE_RAMDISK=ramdisk

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


## Generate ramdisk image for rootfs.
if [ "$ROOTFS_IMAGE_TYPE" = "$TYPE_RAMDISK" ]; then
	genext2fs -b 4096 -d ${ROOTFS_DIR} ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}
	gzip -9 -f ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}
	${UBOOT_OUT_DIR}/tools/mkimage -n ${BOARD_NAME} -A ${BOARD_ARCH} -O linux -T ramdisk -C gzip -d ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}.gz ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}.img
fi

## Print it is finish that generate rootfs image.
echo "Generate rootfs image finish."

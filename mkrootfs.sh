#!/bin/bash

BUILD_DIR=$(pwd)

TOOLS_DIR=$BUILD_DIR/../tools
ROOTFS_DIR=$TOOLS_DIR/common/rootfs

OUT_DIR=$BUILD_DIR/out
ROOTFS_OUT_DIR=$OUT_DIR/rootfs
UBOOT_OUT_DIR=$OUT_DIR/u-boot

## Define image type in there
TYPE_RAMDISK=ramdisk

## Get the argv.
## argv[1] is target image type.
## argv[2] is board name.
## argv[3] is arch type. 
## usage example: ./mkrootfs.sh tiny210 arm
ROOTFS_IMAGE_TYPE=$1
BOARD_NAME=$2
BOARD_ARCH=$3

## Print the type information
echo "Will generate rootfs image!"
echo "ROOTFS_IMAGE_TYPE is $ROOTFS_IMAGE_TYPE"

## mkdir the out directories for rootfs image.
echo $ROOTFS_OUT_DIR
mkdir -p $ROOTFS_OUT_DIR

## Generate ramdisk image for rootfs.
if [ "$ROOTFS_IMAGE_TYPE" = "$TYPE_RAMDISK" ]; then
	genext2fs -b 4096 -d ${ROOTFS_DIR} ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}
	gzip -9 -f ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}
	${UBOOT_OUT_DIR}/tools/mkimage -n ${BOARD_NAME} -A ${BOARD_ARCH} -O linux -T ramdisk -C gzip -d ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}.gz ${ROOTFS_OUT_DIR}/${TYPE_RAMDISK}.img
fi

## Print it is finish that generate rootfs image.
echo "Generate rootfs image finish."

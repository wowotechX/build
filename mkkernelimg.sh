#!/bin/bash

BUILD_DIR=$(pwd)

KERNEL_DIR=$BUILD_DIR/../linux

OUT_DIR=$BUILD_DIR/out
UBOOT_OUT_DIR=$OUT_DIR/u-boot
KERNEL_OUT_DIR=$OUT_DIR/linux


## Define image type in there
TYPE_FIT=fit_uimage
TYPE_LEGACY=legacy_uimage


## Get the argv.
## argv[1] is target image type.
## argv[2] is board name.
## argv[3] is arch type. 
## usage example: ./mkkernelimg.sh tiny210 
KERNEL_IMAGE_TYPE=$1
BOARD_NAME=$2
BOARD_ARCH=$3

if [ "$KERNEL_IMAGE_TYPE" = "$TYPE_FIT" ]; then
	echo "Start generate FIT kernel image!!!"
	UIMAGE_ITS_FILE=${BUILD_DIR}/its/fit_uImage_${BOARD_NAME}.its
	UIMAGE_ITB_FILE=${OUT_DIR}/xprj_uImage.itb
	mkdir -p ${OUT_DIR}
	${UBOOT_OUT_DIR}/tools/mkimage -f ${UIMAGE_ITS_FILE} ${UIMAGE_ITB_FILE}
	echo "Finish generate FIT kernel image!!!"

elif [ "$KERNEL_IMAGE_TYPE" = "$TYPE_LEGACY" ]; then
	echo $#
	if [ $# -lt 6 ]; then
		echo "The arg quantity is to little!!!"
		echo "When you want to generate legacy should have 6 argc!!"
		echo "Example:"
		echo "./mkkernelimg.sh KERNEL_IMAGE_TYPE BOARD_NAME BOARD_ARCH CROSS_COMPILE UIMAGE_LOADADDR UIMAGE_ENTRYADDR" 
		echo "Exit error!!!"
		exit
	fi
	echo "Start generate lagacy kernel uimage!!!"
	CROSS_COMPILE=$4
	UIMAGE_LOADADDR=$5
	UIMAGE_ENTRYADDR=$6
	echo ${KERNEL_DIR}
	#make -C ${KERNEL_DIR} CROSS_COMPILE=${CROSS_COMPILE} KBUILD_OUTPUT=${KERNEL_OUT_DIR} ARCH=${BOARD_ARCH} zImage
	make -C ${KERNEL_DIR} CROSS_COMPILE=${CROSS_COMPILE} KBUILD_OUTPUT=${KERNEL_OUT_DIR} ARCH=${BOARD_ARCH} \
		LOADADDR=${UIMAGE_LOADADDR} ENTRYADDR=${UIMAGE_ENTRYADDR} uImage
	echo "Finish generate lagacy kernel uimage!!!"

else
	echo "The KERNEL_IMAGE_TYPE is error!!!"
	echo "Plese set right KERNEL_IMAGE_TYPE in config.mk!!!"
	echo "Example: " 
	echo "      KERNEL_IMAGE_TYPE="${TYPE_FIT}
	echo "      KERNEL_IMAGE_TYPE="${TYPE_LEGACY}
fi

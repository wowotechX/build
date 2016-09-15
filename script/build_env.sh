#!/bin/bash

BUILD_DIR=$(pwd)/..
OUT_DIR=$BUILD_DIR/out

ROOTFS_OUT_DIR=$OUT_DIR/rootfs
UBOOT_OUT_DIR=$OUT_DIR/u-boot
KERNEL_OUT_DIR=$OUT_DIR/linux

TOOLS_DIR=${BUILD_DIR}/../tools
ROOTFS_DIR=${TOOLS_DIR}/common/rootfs
KERNEL_DIR=$BUILD_DIR/../linux


## 
## generate its config from config.mk
##
CONFIG_MK=${BUILD_DIR}/config.mk
CONFIG_FILE=./config.sh
sed '/^$/d;/^#/d' ${CONFIG_MK} > ${CONFIG_FILE}
source ${CONFIG_FILE}

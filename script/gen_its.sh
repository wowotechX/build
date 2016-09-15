#!/bin/bash

## Get the environment and some variable.
source ./build_env.sh

ECHO="echo -e"


ARM_KERNEL_IMAGE_DIR="${KERNEL_OUT_DIR}/arch/arm/boot"
ARM64_KERNEL_IMAGE_DIR="${KERNEL_OUT_DIR}/arch/arm64/boot"
if [ "${BOARD_ARCH}" = "arm" ]; then
	KERNEL_IMAGE=${ARM_KERNEL_IMAGE_DIR}/zImage
	FDT_IMAGE=${ARM_KERNEL_IMAGE_DIR}/dts/${DTB_NAME}
elif [ "${BOARD_ARCH}" = "arm64" ];then
	KERNEL_IMAGE=${ARM64_KERNEL_IMAGE_DIR}/Image
	FDT_IMAGE=${ARM64_KERNEL_IMAGE_DIR}/dts/${DTB_NAME}
fi	

RAMDISK_IMAGE=${ROOTFS_OUT_DIR}/ramdisk.gz

function print_note()
{
	$ECHO "/*"
	$ECHO " * U-Boot uImage source file for \"X project\""
	$ECHO " */\n"
}

function print_entry()
{
	$ECHO "/dts-v1/;\n"
	$ECHO "/ {"
	$ECHO "\tdescription = \"U-Boot uImage source file for X project\";"
	$ECHO "\t#address-cells = <1>;\n"
}

function print_end()
{
	$ECHO "};"
}

function print_kernel_node()
{
	$ECHO "\t\tkernel@${BOARD_NAME} {"
	$ECHO "\t\t\tdescription = \"Unify(TODO) Linux kernel for project-x\";"
	$ECHO "\t\t\tdata = /incbin/(\"${KERNEL_IMAGE}\");"
	$ECHO "\t\t\ttype = \"kernel\";"
	$ECHO "\t\t\tarch = \"${BOARD_ARCH}\";"
	$ECHO "\t\t\tos = \"linux\";"
	$ECHO "\t\t\tcompression = \"none\";"
	$ECHO "\t\t\tload = <${UIMAGE_LOADADDR}>;"
	$ECHO "\t\t\tentry = <${UIMAGE_LOADADDR}>;"
	$ECHO "\t\t};"
}

function print_fdt_node()
{
    $ECHO "\t\tfdt@${BOARD_NAME} {"
	$ECHO "\t\t\tdescription = \"Flattened Device Tree blob for project-x\";"
	$ECHO "\t\t\tdata = /incbin/(\"${FDT_IMAGE}\");"
	$ECHO "\t\t\ttype = \"flat_dt\";"
	$ECHO "\t\t\tarch = \"${BOARD_ARCH}\";"
	$ECHO "\t\t\tcompression = \"none\";"
	$ECHO "\t\t};"
}

function print_ramdisk_node()
{
    $ECHO "\t\tramdisk@${BOARD_NAME} {"
	$ECHO "\t\t\tdescription = \"Ramdisk for project-x\";"
    $ECHO "\t\t\tdata = /incbin/(\"${RAMDISK_IMAGE}\");"
    $ECHO "\t\t\ttype = \"ramdisk\";"
    $ECHO "\t\t\tarch = \"${BOARD_ARCH}\";"
    $ECHO "\t\t\tos = \"linux\";"
    $ECHO "\t\t\tcompression = \"gzip\";"
    $ECHO "\t\t};"
}

function print_images_node()
{
	$ECHO "\timages {"
	print_kernel_node
	if [ -f "${FDT_IMAGE}" ]; then
		print_fdt_node
	fi
	if [ -f "${RAMDISK_IMAGE}" ]; then
		print_ramdisk_node
	fi
	$ECHO "\t};\n"
}

function print_conf_node()
{
    $ECHO "\tconfigurations {"
	$ECHO "\t\tdefault = \"conf@${BOARD_NAME}\";"
    $ECHO "\t\tconf@${BOARD_NAME} {"
    $ECHO "\t\t\tdescription = \"Boot Linux kernel with FDT blob\";"
    $ECHO "\t\t\tkernel = \"kernel@${BOARD_NAME}\";"
	if [ -f "${FDT_IMAGE}" ]; then
		$ECHO "\t\t\tfdt = \"fdt@${BOARD_NAME}\";"
	fi
	if [ -f "${RAMDISK_IMAGE}" ]; then
		$ECHO "\t\t\tramdisk = \"ramdisk@${BOARD_NAME}\";"
	fi
	$ECHO "\t\t};"
    $ECHO "\t};"
}

function gen_its()
{
	print_note>${ITS_FILE}
	print_entry>>${ITS_FILE}
	print_images_node>>${ITS_FILE}
	print_conf_node>>${ITS_FILE}
	print_end>>${ITS_FILE}
}

# generate its config from config.mk
mkdir -p ${FIT_OUT_DIR}
gen_its

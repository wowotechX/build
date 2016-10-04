#
# General configure file of X project's build system.
#
# (C) Copyright 2016 wowotech
#
# wowo<wowo@wowotech.net>
#

#
# Board information
#
BOARD_NAME=bubblegum
BOARD_ARCH=arm64

BOARD_VENDOR=actions

#
# Memory usage information
#
DDR_BASE=0x0
DDR_SIZE=0x3FFFFFFF

SPL_BASE=0xe406b200

UBOOT_BASE=0x11000000

FIT_UIMAGE_BASE=0x6400000

#
# Linux Kernel information
#
KERNEL_LOAD_ADDR=0x00080000
KERNEL_ENTRY_ADDR=0x00080000

#
# DTB information
#
DTB_ENABLE=1

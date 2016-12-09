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
BOARD_NAME=tiny210
BOARD_ARCH=arm

#
# Linux Kernel information
#
KERNEL_LOAD_ADDR=0x20008000
KERNEL_ENTRY_ADDR=0x20008040

#
# DTB information
#
DTB_ENABLE=1

#
# Ramdisk information
#
INITRAMFS_ENABLE=1

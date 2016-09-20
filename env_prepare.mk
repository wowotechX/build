#
# X project's genernal build system.
#
# (C) Copyright 2016 wowotech
#
# wowo<wowo@wowotech.net>
#
# SPDX-License-Identifier:	GPL-2.0+
#

BIT32_64=$(shell getconf LONG_BIT)

ifeq ($(BOARD_NAME), bubblegum)
ifeq ($(BIT32_64), 64)
COMPILE_URL=https://github.com/wowotechX/gcc-linaro-4.9-2015.02-3-x86_64_aarch64-linux-gnu.git
CROSS_COMPILE=$(shell pwd)/gcc-linaro-4.9-2015.02-3-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
else
COMPILE_URL=https://github.com/wowotechX/gcc-linaro-aarch64-linux-gnu-4.8-2013.12_linux.git
CROSS_COMPILE=$(shell pwd)/gcc-linaro-aarch64-linux-gnu-4.8-2013.12_linux/bin/aarch64-linux-gnu-
endif
endif

ifeq ($(BOARD_NAME), tiny210)
#use arm-linux-gcc-4.8.3 to build uboot and uboot-spl.
COMPILE_URL=https://github.com/ooonebook/arm-none-linux-gnueabi-4.8.git
CROSS_COMPILE=$(shell pwd)/arm-none-linux-gnueabi-4.8/bin/arm-none-linux-gnueabi-
endif

env_prepare:
	git clone $(COMPILE_URL)

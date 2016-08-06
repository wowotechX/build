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

env_prepare:
	git clone $(COMPILE_URL)

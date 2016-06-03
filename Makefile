#
# X project's genernal build system.
#
# (C) Copyright 2016 wowotech
#
# wowo<wowo@wowotech.net>
#
# SPDX-License-Identifier:	GPL-2.0+
#

include config.mk

BIT32_64=$(shell getconf LONG_BIT)

BUILD_DIR=$(shell pwd)

TOOLS_DIR=$(BUILD_DIR)/../tools
LIBUSB_DIR=$(TOOLS_DIR)/common/libusb-1.0.20
DFU_DIR=$(TOOLS_DIR)/dfu
UBOOT_DIR=$(BUILD_DIR)/../u-boot

ifeq ($(BIT32_64), 64)
CROSS_COMPILE=$(TOOLS_DIR)/common/gcc-linaro-4.9-2015.02-3-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
else
CROSS_COMPILE=$(TOOLS_DIR)/common/gcc-linaro-aarch64-linux-gnu-4.8-2013.12_linux/bin/aarch64-linux-gnu-
endif

OUT_DIR=$(BUILD_DIR)/out
UBOOT_OUT_DIR=$(OUT_DIR)/u-boot

all: libusb dfu dfu-clean uboot-config uboot uboot-clean

libusb:
	cd $(LIBUSB_DIR) && ./configure && make && cd $(BUILD_DIR)

dfu:
	make -C $(DFU_DIR)

dfu-clean:
	make -C $(DFU_DIR) clean

#
# Be careful: the xxx_defconf file of your board will be overrided
#	after you running 'make uboot-config'.
#
uboot-config:
	mkdir -p $(UBOOT_OUT_DIR)
	cp -f $(UBOOT_DIR)/configs/$(BOARD_NAME)_defconfig $(UBOOT_OUT_DIR)/.config
	make -C $(UBOOT_DIR) KBUILD_OUTPUT=$(UBOOT_OUT_DIR) menuconfig
	cp -f $(UBOOT_OUT_DIR)/.config $(UBOOT_DIR)/configs/$(BOARD_NAME)_defconfig

uboot:
	mkdir -p $(UBOOT_OUT_DIR)
	make -C $(UBOOT_DIR) CROSS_COMPILE=$(CROSS_COMPILE) KBUILD_OUTPUT=$(UBOOT_OUT_DIR) $(BOARD_NAME)_defconfig
	make -C $(UBOOT_DIR) CROSS_COMPILE=$(CROSS_COMPILE) KBUILD_OUTPUT=$(UBOOT_OUT_DIR)

uboot-clean:
	rm $(UBOOT_OUT_DIR) -rf

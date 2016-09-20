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
include env_prepare.mk

BUILD_DIR=$(shell pwd)

TOOLS_DIR=$(BUILD_DIR)/../tools
LIBUSB_DIR=$(TOOLS_DIR)/common/libusb-1.0.20
DFU_DIR=$(TOOLS_DIR)/dfu
UBOOT_DIR=$(BUILD_DIR)/../u-boot
KERNEL_DIR=$(BUILD_DIR)/../linux
SCRIPT_DIR=$(BUILD_DIR)/script

OUT_DIR=$(BUILD_DIR)/out
UBOOT_OUT_DIR=$(OUT_DIR)/u-boot
KERNEL_OUT_DIR=$(OUT_DIR)/linux

ifeq ($(BOARD_ARCH), arm64)
KERNEL_DEFCONFIG=xprj_defconfig
KERNEL_TARGET=Image dtbs
else ifeq ($(BOARD_ARCH), arm)
KERNEL_DEFCONFIG=$(BOARD_NAME)_defconfig
KERNEL_TARGET=Image dtbs zImage
endif

UIMAGE_ITS_FILE=$(SCRIPT_DIR)/fit_uImage_$(BOARD_NAME).its
UIMAGE_ITB_FILE=$(OUT_DIR)/xprj_uImage_$(BOARD_NAME).itb

all: uboot kernel uImage

clean: dfu-clean uboot-clean kernel-clean


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

#
# Be careful: the xxx_defconf file of your board will be overrided
#	after you running 'make kernel-config'.
#
kernel-config:
	mkdir -p $(KERNEL_OUT_DIR)
	cp -f $(KERNEL_DIR)/arch/$(BOARD_ARCH)/configs/$(KERNEL_DEFCONFIG) $(KERNEL_OUT_DIR)/.config
	make -C $(KERNEL_DIR) KBUILD_OUTPUT=$(KERNEL_OUT_DIR) ARCH=$(BOARD_ARCH) menuconfig
	cp -f $(KERNEL_OUT_DIR)/.config $(KERNEL_DIR)/arch/$(BOARD_ARCH)/configs/$(KERNEL_DEFCONFIG)

kernel:
	mkdir -p $(KERNEL_OUT_DIR)
	make -C $(KERNEL_DIR) CROSS_COMPILE=$(CROSS_COMPILE) KBUILD_OUTPUT=$(KERNEL_OUT_DIR) ARCH=$(BOARD_ARCH) $(KERNEL_DEFCONFIG)
	make -C $(KERNEL_DIR) CROSS_COMPILE=$(CROSS_COMPILE) KBUILD_OUTPUT=$(KERNEL_OUT_DIR) ARCH=$(BOARD_ARCH) $(KERNEL_TARGET)

kernel-clean:
	rm $(KERNEL_OUT_DIR) -rf

uImage:
	mkdir -p $(OUT_DIR)
	$(UBOOT_OUT_DIR)/tools/mkimage -f $(UIMAGE_ITS_FILE) $(UIMAGE_ITB_FILE)

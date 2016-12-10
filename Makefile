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

DFU_DIR=$(TOOLS_DIR)/dfu
LIBUSB_DIR=$(TOOLS_DIR)/common/libusb-1.0.20
BUSYBOX_DIR=$(TOOLS_DIR)/common/busybox-1.25.1

UBOOT_DIR=$(BUILD_DIR)/../u-boot
KERNEL_DIR=$(BUILD_DIR)/../linux

OUT_DIR=$(BUILD_DIR)/out
UBOOT_OUT_DIR=$(OUT_DIR)/u-boot
KERNEL_OUT_DIR=$(OUT_DIR)/linux
BUSYBOX_OUT_DIR=$(OUT_DIR)/busybox
ROOTFS_OUT_DIR=$(OUT_DIR)/rootfs

ifeq ($(BOARD_ARCH), arm64)
KERNEL_DEFCONFIG=xprj_defconfig
KERNEL_TARGET=Image dtbs
else ifeq ($(BOARD_ARCH), arm)
KERNEL_DEFCONFIG=$(BOARD_NAME)_defconfig
KERNEL_TARGET=Image dtbs zImage
endif

BUSYBOX_DEFCONFIG=xprj_defconfig

UIMAGE_CFG_FILE=$(ITS_DIR)/xprj_config.h
UIMAGE_ITS_FILE=$(ITS_DIR)/fit_uImage_$(BOARD_NAME).its
UIMAGE_ITB_FILE=$(OUT_DIR)/xprj_uImage_$(BOARD_NAME).itb

# first target
_all: all

env_prepare:
	git clone $(COMPILE_URL)

all: libusb dfu uboot kernel busybox initramfs uImage

clean: libusb-clean dfu-clean uboot-clean kernel-clean busybox-clean
	rm -rf $(OUT_DIR) $(UIMAGE_CFG_FILE)

libusb:
	cd $(LIBUSB_DIR) && ./configure && make && cd $(BUILD_DIR)

libusb-clean:
	cd $(LIBUSB_DIR) && make distclean && cd $(BUILD_DIR)

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

busybox-config:
	mkdir -p $(BUSYBOX_OUT_DIR)
	cp -f $(BUSYBOX_DIR)/configs/$(BUSYBOX_DEFCONFIG) $(BUSYBOX_OUT_DIR)/.config
	make -C $(BUSYBOX_DIR) O=$(BUSYBOX_OUT_DIR) menuconfig
	cp -f $(BUSYBOX_OUT_DIR)/.config $(BUSYBOX_DIR)/configs/$(BUSYBOX_DEFCONFIG)

busybox:
	mkdir -p $(BUSYBOX_OUT_DIR) $(ROOTFS_OUT_DIR)
	make -C $(BUSYBOX_DIR) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUSYBOX_OUT_DIR) $(BUSYBOX_DEFCONFIG)
	make -C $(BUSYBOX_DIR) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUSYBOX_OUT_DIR)
	make -C $(BUSYBOX_DIR) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUSYBOX_OUT_DIR) CONFIG_PREFIX=$(ROOTFS_OUT_DIR) install

busybox-clean:
	rm $(BUSYBOX_OUT_DIR) -rf

rootfs_copy:
	mkdir -p ${ROOTFS_OUT_DIR}
	cp -rf ${SCRIPT_DIR}/rootfs/* ${ROOTFS_OUT_DIR}/

initramfs: rootfs_copy
	mkdir -p $(OUT_DIR)
	cd ${ROOTFS_OUT_DIR}; find . | cpio -H newc -o | gzip -9 -n > ${OUT_DIR}/initramfs.gz

uImage: config-gen
	mkdir -p $(OUT_DIR)
	@echo "Preprocessor the .dts file ..."
	cpp -nostdinc -I include -undef -x assembler-with-cpp $(UIMAGE_ITS_FILE) > $(UIMAGE_ITS_FILE).tmp
	$(UBOOT_OUT_DIR)/tools/mkimage -f $(UIMAGE_ITS_FILE).tmp $(UIMAGE_ITB_FILE)
	@rm -f $(UIMAGE_ITS_FILE).tmp

config-gen:
	$(SCRIPT_DIR)/config_gen.sh $(CONFIGS_DIR)/config_$(BOARD_NAME).mk $(UIMAGE_CFG_FILE)

#
# some help commands
#
spl-run:
	sudo $(DFU_DIR)/dfu $(BOARD_NAME) $(SPL_BASE) $(TOOLS_DIR)/$(BOARD_VENDOR)/splboot.bin 1

uimage-load:
	sudo $(DFU_DIR)/dfu $(BOARD_NAME) $(FIT_UIMAGE_BASE) $(UIMAGE_ITB_FILE) 0

uboot-run:
	sudo $(DFU_DIR)/dfu $(BOARD_NAME) $(UBOOT_BASE) $(OUT_DIR)/u-boot/u-boot-dtb.bin 1

kernel-run: uimage-load uboot-run

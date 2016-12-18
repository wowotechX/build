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

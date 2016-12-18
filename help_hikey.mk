#
# some help commands
#

img-loader=$(TOOLS_DIR)/$(BOARD_VENDOR)/img_loader.bin
uboot-spl-bin=$(UBOOT_OUT_DIR)/spl/u-boot-spl.bin

gen-loader=$(TOOLS_DIR)/$(BOARD_VENDOR)/gen_loader.py

hisi-idt=$(TOOLS_DIR)/$(BOARD_VENDOR)/hisi-idt.py

spl-run:
	# generate SPL image
	sudo python $(gen-loader) -o spl.img --img_loader=$(img-loader) --img_bl1=$(uboot-spl-bin)
	sudo python $(hisi-idt) --img1=spl.img -d /dev/ttyUSB0
	rm -f spl.img

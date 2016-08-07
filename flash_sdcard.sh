#flash_sdcard.sh is used to flash spl.bin and uboot.bin to sdcard.
#But you should check which /dev/sdX sdcard creat by "sudo fdisk -l".
#example:
#    ./flash_sdcard.sh tiny210

if [ "$1" = "tiny210" ];then
#In there, sdcard creat /dev/sdb, so dd bin file to /dev/sdb
OUT_UBOOT_DIR=./out/u-boot
sudo dd iflag=dsync oflag=dsync if=$OUT_UBOOT_DIR/spl/tiny210-spl.bin of=/dev/sdb seek=1
sudo dd iflag=dsync oflag=dsync if=$OUT_UBOOT_DIR/u-boot.bin of=/dev/sdb  seek=49
fi

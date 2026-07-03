#!/bin/sh
mkimage -A arm -O linux -T kernel -C none -a 0x42000000 -e 0x42000000 -d vmlinuz-lts uImage
mkimage -A arm -O linux -T ramdisk -C gzip -d initramfs-lts uInitrd
rm vmlinuz-lts
rm initramfs-lts

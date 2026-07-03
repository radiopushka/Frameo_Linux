# Frameo_Linux

## To get a Frameo from Walmart based on the A33 Allwinner SOC to run Alpine Linux
### This makes sense if you got one for free or as a gift, and you do not know how to use it. What even is the purpose of a picture frame?

### The current configuration was tested on the A33-SWM0810-V1.1 board variant of the Frameo device.
## Device Support Summary:
- SD card controller -> fully functional
- USB-C port -> not working
- USB 2.0 port -> fully functional (supports plug-in Wi-Fi or Ethernet adapters)
- Sound Device -> recognized by kernel, but no sound
- LCD -> not working (my board power cycles with the ribbon cable connected)
- Touch Pad -> not sure
- On Board wifi -> not working

# full boot directory: https://disk.yandex.ru/d/UgxIxaLW5-Ncgg
# Github does not let me upload files over 25MB

## How to setup:
1. Find an empty sdcard (the large variant)
2. Format the SD card as a DOS layout
3. Create the boot partition in fdisk -> 300MB type 0c toggled flag a
4. Create the rootfs partition -> the remaining disk space with default options
5. Create the boot file system mkfs.vfat -F 32 /dev/sda1
6. Create the root file system mkfs.f2fs /dev/sda2
7. flash the uboot code: dd if=u-boot-sunxi-with-spl.bin of=/dev/sda bs=1024 seek=8
  - make sure you are not writing to a partition: it cannot be /dev/sda1 it must be /dev/sda. You will not overwrite anything.
8. copy the contents of the tar file from "full boot directory" to /dev/sda1
9. change the boot.cmd script and get rid of everything after rootfs in the console cmd line, you will add it later.

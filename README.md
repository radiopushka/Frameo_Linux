# Frameo_Linux

Turn a Walmart Frameo digital picture frame (Allwinner A33 SoC) into a functional Alpine Linux mini‑computer.  
Perfect if you got one for free, as a gift, or if you’ve ever wondered what the real purpose of a picture frame is.

Tested on the **A33‑SWM0810‑V1.1** board revision.

## Device support summary

| Component              | Status                                        |
|------------------------|-----------------------------------------------|
| SD card controller     | ✅ Fully functional                            |
| USB‑C port             | ❌ Not working                                |
| USB 2.0 port           | ✅ Fully functional (supports Wi‑Fi / Ethernet adapters) |
| Sound device           | ⚠️ Recognised by kernel, but no audio output   |
| LCD                    | ❌ Not working (board power‑cycles with ribbon cable connected) |
| Touch panel (GSL1680)  | ⚠️ Not fully tested                           |
| On‑board Wi‑Fi (XR819) | ❌ Not working                                |

## Full boot directory

Because GitHub won’t accept files over 25 MB, the complete boot image (kernel, initramfs, DTB, boot script) is stored at:

➡️ **[Download from Yandex Disk](https://disk.yandex.ru/d/UgxIxaLW5-Ncgg)**

## How to set up

Follow these steps to create a bootable SD card and install Alpine Linux on the Frameo.

### 1. Prepare the SD card
- Use a **full‑size** SD card (the large variant).
- Partition it with a DOS partition table (`fdisk` / `cfdisk`).

Create two partitions:

| Partition | Size        | Type | Boot flag |
|-----------|-------------|------|-----------|
| 1         | ~300 MB     | 0c   | yes (`a`) |
| 2         | Remaining space | default | no |

- Format them:
  ```sh
  mkfs.vfat -F 32 /dev/sda1
  mkfs.f2fs /dev/sda2
  ```
### 2. Flash U‑Boot
```sh
dd if=u-boot-sunxi-with-spl.bin of=/dev/sda bs=1024 seek=8
```
  - make sure you are not writing to a partition: it cannot be /dev/sda1, it must be /dev/sda. You will not overwrite anything.
8. copy the contents of the tar file from "full boot directory" to /dev/sda1
9. change the boot.cmd script and get rid of everything after rootfs in the console cmd line, you will add it later.
10. in that same directory launch the boot_script.sh
11. download the generic u-boot image from alpine linux, untar it, copy the apk directory to /dev/sda2.
12. unmount everything and plug the sdcard into the sdcard slot on the board.
13. on the board find two circular pads labeled "RX" and "TX", and solder wires to them. Connect them to a USB to UART device.
14. Before plugging in the board connect to the USB to UART device via picocom.
15. Plug in the board, if everything is done correctly, you should start to see prints from u-boot and the Linux kernel booting.
16. remount the 2nd partition and copy/create the directories that are present in / ignoring those that appear when you run mount
17. add the rootfs back to the console cmd line, replacing the UUID with the UUID of your second partition.
18. run the boot_script.sh again
19. reboot and then finish setting up the system, you will need to add all the boot services for alpine back to their corresponding runlevels and remount the / directory as rw. Then add the entry for the / directory in fstab.
20. your done!
    


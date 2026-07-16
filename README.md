# Frameo Linux

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

You can solder a USB hub controller to the USB connector on the board and expand the number of USB slots you have available. Then you can 3d print a case encapsulating everything. 

## Full boot directory
From the Kernel Boot Directory release, download the bootimage.tar.xz

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
### 3. Install the boot files
1. Download the archive from the [Full boot directory](#full-boot-directory) link above.
2. Mount `/dev/sda1` and copy the entire contents of the archive into it.
3. Edit the `boot.cmd` script on the boot partition:
   - Remove everything after `rootfs` in the kernel command line (you’ll add it back later).
4. Run the `make_script.sh` script (inside the boot directory) to compile `boot.scr`.

### 4. Add the Alpine Linux root filesystem
1. Download the **generic Alpine Linux ARMv7 u‑boot image** from [alpinelinux.org](https://alpinelinux.org/downloads/).
2. Extract it and copy the `apk` directory (from the Alpine image) to `/dev/sda2`.
   - You’ll end up with a basic Alpine filesystem on the second partition.

### 5. First boot
1. Unmount everything and insert the SD card into the frame’s slot.
2. Solder wires to the two circular pads labeled **RX** and **TX** on the board.
3. Connect them to a USB‑to‑UART adapter (3.3 V).
4. Open a serial terminal (e.g., `picocom -b 115200 /dev/ttyUSB0`).
5. Power up the board. You should see U‑Boot and Linux kernel messages.

### 6. Complete the installation
- Mount the second partition (`/dev/mmcblk0p2`) and create the directories that exist in `/` except those that appear when you run `mount`.
- Restore the kernel command line to mount the correct root partition:
  1. Edit `boot.cmd` and replace the rootfs part with `root=UUID=<your‑UUID> rootfstype=f2fs rw`.
  2. Run `make_script.sh` again to regenerate `boot.scr`.
- Reboot.

After the system comes up:
- Remount the root filesystem as read‑write: `mount -o remount,rw /`
- Add the root entry to `/etc/fstab`.
- Restore all essential OpenRC services like local.d to their runlevels with `rc-update`.
- Commit your changes (e.g., `lbu commit` if using diskless mode).
- Create a script in /etc/local.d/ that enables fast networking. By default, the CPU is set to ondemand, which makes network operations slow; you have to set it to performance.
- ` sunxi:~$ cat /etc/local.d/cpu_governor.start `
  
```shell
#!/bin/sh
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

## Done!
Your Frameo picture frame is now a pocket‑sized Alpine Linux machine. Use the USB 2.0 port for Wi‑Fi, Ethernet, or storage – the internal display, touch, and Wi‑Fi are still works in progress. Contributions and improvements welcome!

## Notes
- USB‑C does **not** work; use the standard USB 2.0 port.
- The LCD ribbon cable may cause power cycling – if you want to experiment, disconnect it before booting.
- Sound is recognised by the kernel but currently silent (driver/DTS routing issue).
- On‑board Wi‑Fi (XR819) requires further device‑tree and module work.

Enjoy your (unintended) Linux box!


setenv console ttyS5,115200

fatload mmc 0:1 0x42000000 uImage
fatload mmc 0:1 0x44000000 uInitrd
fatload mmc 0:1 0x43000000 frameo.dtb


setenv bootargs console=ttyS0,115200 root=UUID=8cd18ac1-fe43-4f8f-afc9-b34d15944155 rootfstype=f2fs rw 

bootm 0x42000000 0x44000000 0x43000000


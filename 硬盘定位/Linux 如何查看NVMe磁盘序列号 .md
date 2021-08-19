Linux 如何查看NVMe磁盘序列号
===

磁盘：/dev/sda是做RAID1的SSD。/dev/nvme1n1、/dev/nvme0n1是NVMe磁盘，没有做RAID。

方法一 lsblk
---

因为/dev/sda逻辑盘，SERIAL应该只是系统生产的一个ID。
```
[root@my-host-1 tmp]# lsblk -o name,type,serial /dev/sda
NAME TYPE SERIAL
sda disk 600508b1001c53f4be54e7bb874d7171
└─data-data lvm
```

lsblk也是可以看到NVMe磁盘的信息的
```
[root@my-host-1 tmp]# lsblk -o name,type,serial /dev/nvme0n1 
NAME TYPE SERIAL
nvme0n1 disk T090FRRV1
```

方法二 smartctl
---
```
[root@my-host-1 ~]# smartctl --all /dev/sda
smartctl 7.0 2018-12-30 r4883 [x86_64-linux-3.10.0-1127.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor: UN
Product: LOGICAL VOLUME
Revision: 2.30
Compliance: SPC-3
User Capacity: 1,920,326,787,072 bytes [1.92 TB]
Logical block size: 512 bytes
Physical block size: 4096 bytes
Rotation Rate: Solid State Device
Logical Unit id: 0x600508b1001c53f4be54e7bb874d7171
Serial number: 
Device type: disk
Local Time is: Wed Jan 6 16:04:23 2021 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
Temperature Warning: Disabled or Not Supported

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK
Current Drive Temperature: 0 C
Drive Trip Temperature: 0 C

Error Counter logging not supported

Device does not support Self Test logging
```

smartctl获取/dev/nvme1n1信息
```
[root@my-host-1 ~]# smartctl --all /dev/nvme1n1
smartctl 7.0 2018-12-30 r4883 [x86_64-linux-3.10.0-1127.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Number: P50D7040B160
Serial Number: T090FRRR6
Firmware Version: 001008N1
PCI Vendor/Subsystem ID: 0x1c5f
IEEE OUI Identifier: 0x00e0cf
Total NVM Capacity: 4,000,787,030,016 [4.00 TB]
Unallocated NVM Capacity: 0
Controller ID: 1
Number of Namespaces: 1
Namespace 1 Size/Capacity: 4,000,787,030,016 [4.00 TB]
Namespace 1 Formatted LBA Size: 512
Local Time is: Wed Jan 6 15:17:13 2021 CST
Firmware Updates (0x07): 3 Slots, Slot 1 R/O
Optional Admin Commands (0x000e): Format Frmw_DL NS_Mngmt
Optional NVM Commands (0x0014): DS_Mngmt Sav/Sel_Feat
Maximum Data Transfer Size: 32 Pages
Warning Comp. Temp. Threshold: 70 Celsius
Critical Comp. Temp. Threshold: 80 Celsius

Supported Power States
St Op Max Active Idle RL RT WL WT Ent_Lat Ex_Lat
0 + 25.00W - - 0 0 0 0 100 100
1 + 20.00W - - 1 1 1 1 200 200
2 + 15.00W - - 2 2 2 2 300 300

Supported LBA Sizes (NSID 0x1)
Id Fmt Data Metadt Rel_Perf
0 + 512 0 2
1 - 4096 0 0
2 - 512 0 2
3 - 4096 0 0

=== START OF SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART/Health Information (NVMe Log 0x02)
Critical Warning: 0x00
Temperature: 36 Celsius
Available Spare: 100%
Available Spare Threshold: 5%
Percentage Used: 0%
Data Units Read: 3,547,572 [1.81 TB]
Data Units Written: 3,482,861 [1.78 TB]
Host Read Commands: 13,877,453
Host Write Commands: 13,604,929

Controller Busy Time: 71
Power Cycles: 550
Power On Hours: 6,573
Unsafe Shutdowns: 512
Media and Data Integrity Errors: 0
Error Information Log Entries: 0
Warning Comp. Temperature Time: 0
Critical Comp. Temperature Time: 0
Temperature Sensor 1: 39 Celsius
Temperature Sensor 2: 36 Celsius
Temperature Sensor 3: 30 Celsius
Temperature Sensor 4: 29 Celsius

Error Information (NVMe Log 0x01, max 63 entries)
No Errors Logged
```

方法三 nvme client工具#
---

nvme工具提供用于获取NVME设备信息的选项
```
[root@my-host-1 ~]# wget https://mirrors.aliyun.com/centos/7.9.2009/os/x86_64/Packages/nvme-cli-1.8.1-3.el7.x86_64.rpm --no-check-certificate
[root@my-host-1 ~]# rpm -ivh nvme-cli-1.8.1-3.el7.x86_64.rpm
```

nvme工具帮助信息
```
[root@my-host-1 ~]# nvme help
nvme-1.8.1
usage: nvme <command> [<device>] [<args>]

The '<device>' may be either an NVMe character device (ex: /dev/nvme0) or an
nvme block device (ex: /dev/nvme0n1).

The following are all implemented sub-commands:
list List all NVMe devices and namespaces on machine
list-subsys List nvme subsystems
id-ctrl Send NVMe Identify Controller
id-ns Send NVMe Identify Namespace, display structure
list-ns Send NVMe Identify List, display structure
ns-descs Send NVMe Namespace Descriptor List, display structure
id-nvmset Send NVMe Identify NVM Set List, display structure
create-ns Creates a namespace with the provided parameters
delete-ns Deletes a namespace from the controller
attach-ns Attaches a namespace to requested controller(s)
detach-ns Detaches a namespace from requested controller(s)
list-ctrl Send NVMe Identify Controller List, display structure
get-ns-id Retrieve the namespace ID of opened block device
get-log Generic NVMe get log, returns log in raw format
telemetry-log Retrieve FW Telemetry log write to file
fw-log Retrieve FW Log, show it
changed-ns-list-log Retrieve Changed Namespace List, show it
smart-log Retrieve SMART Log, show it
ana-log Retrieve ANA Log, show it
error-log Retrieve Error Log, show it
effects-log Retrieve Command Effects Log, show it
endurance-log Retrieve Endurance Group Log, show it
get-feature Get feature and show the resulting value
device-self-test Perform the necessary tests to observe the performance
self-test-log Retrieve the SELF-TEST Log, show it
set-feature Set a feature and show the resulting value
set-property Set a property and show the resulting value
get-property Get a property and show the resulting value
format Format namespace with new block format
fw-commit Verify and commit firmware to a specific slot (fw-activate in old version < 1.2)
fw-download Download new firmware
admin-passthru Submit an arbitrary admin command, return results
io-passthru Submit an arbitrary IO command, return results
security-send Submit a Security Send command, return results
security-recv Submit a Security Receive command, return results
resv-acquire Submit a Reservation Acquire, return results
resv-register Submit a Reservation Register, return results
resv-release Submit a Reservation Release, return results
resv-report Submit a Reservation Report, return results
dsm Submit a Data Set Management command, return results
flush Submit a Flush command, return results
compare Submit a Compare command, return results
read Submit a read command, return results
write Submit a write command, return results
write-zeroes Submit a write zeroes command, return results
write-uncor Submit a write uncorrectable command, return results
sanitize Submit a sanitize command
sanitize-log Retrieve sanitize log, show it
reset Resets the controller
subsystem-reset Resets the subsystem
ns-rescan Rescans the NVME namespaces
show-regs Shows the controller registers or properties. Requires character device
discover Discover NVMeoF subsystems
connect-all Discover and Connect to NVMeoF subsystems
connect Connect to NVMeoF subsystem
disconnect Disconnect from NVMeoF subsystem
disconnect-all Disconnect from all connected NVMeoF subsystems
gen-hostnqn Generate NVMeoF host NQN
dir-receive Submit a Directive Receive command, return results
dir-send Submit a Directive Send command, return results
virt-mgmt Manage Flexible Resources between Primary and Secondary Controller 
version Shows the program version
help Display this help

See 'nvme help <command>' for more information on a specific command

The following are all installed plugin extensions:
intel Intel vendor specific extensions
lnvm LightNVM specific extensions
memblaze Memblaze vendor specific extensions
wdc Western Digital vendor specific extensions
huawei Huawei vendor specific extensions
netapp NetApp vendor specific extensions
toshiba Toshiba NVME plugin
micron Micron vendor specific extensions
seagate Seagate vendor specific extensions

See 'nvme <plugin> help' for more information on a plugin
```

nvme list 获取NVMe磁盘信息
```
[root@my-host-1 ~]# nvme list
Node SN Model Namespace Usage Format FW Rev 
---------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1 T090FRRV1 P50D7040B160 1 4.00 TB / 4.00 TB 512 B + 0 B 001008N1
/dev/nvme1n1 T090FRRR6 P50D7040B160 1 4.00 TB / 4.00 TB 512 B + 0 B 001008N1
```
总结：我的环境NVMe磁盘没有做RAID，在做RAID的情况下，系统看到的是逻辑盘，未必可以获取物理磁盘的信息。

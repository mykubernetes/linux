一、简单说明
===
在云平台主机安装Centos7.x系统时，云平台封装的镜像是20G的系统盘，这里导致我们在一些特定的场景下，需要对根分区文件系统进行扩容。而不是直接挂载一块数据盘到一个目录下。

二、具体配置
===

1、查看当前系统目录分区信息
```
[root@k8s001 ~]# df -h
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 3.9G     0  3.9G   0% /dev
tmpfs                    3.9G  4.0K  3.9G   1% /dev/shm
tmpfs                    3.9G   17M  3.9G   1% /run
tmpfs                    3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/mapper/centos-root  18G   7.5G  10.5G  42% /
/dev/vda1                497M  172M  326M   35% /boot
tmpfs                    798M     0  798M   0% /run/user/0

[root@k8s001 ~]# lsblk
NAME                                                                                        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0                                                                                          11:0    1 1024M  0 rom
vda                                                                                         252:0    0  200G  0 disk
├─vda1                                                                                      252:1    0  500M  0 part /boot
└─vda2                                                                                      252:2    0 19.5G  0 part
  ├─centos-root                                                                             253:0    0 17.5G  0 lvm  /
  └─centos-swap                                                                             253:1    0    2G  0 lvm  [SWAP]
```
- 这里我们可以看出根文件系统目录大小为18G，系统盘大小为200G。
- 这里我们需要将系统盘剩余分区全部扩展到根分区使用。

2、添加磁盘分区
```
[root@localhost ~]# fdisk /dev/vda
Welcome to fdisk (util-linux 2.23.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.
Command (m for help): n
# 1.下一步选择p 
# 2.下一步默认
# 3.下一步默认
# 4.下一步默认
# 5.下一步输入t（这里是修改分区类型）
# 6.下一步输入3
# 7.下一步分输入8e（分区格式）
# 8.下一步输入w保存当前修改
```

3、加载分区信息
使用fdisk工具只是将分区信息写到磁盘，如果需要mkfs磁盘分区则需要重启系统，而使用partprobe则可以使kernel重新读取分区信息，从而避免重启系统。
```
[root@k8s001 ~]# partprobe
```

4、将建立好的分区创建物理卷
```
[root@k8s001 ~]# pvcreate /dev/vda3
```

5、查看创建的物理卷
```
[root@k8s001 ~]# pvdisplay
```

6、将物理卷加入到根分区所在的卷

查看卷组名称可以使用vgdisplay 获取VG Name名称，记录下来，例如这里我们当前系统的卷组为：centos
```
[root@k8s001 ~]# vgdisplay
  --- Volume group ---
  VG Name               centos
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <19.51 GiB
  PE Size               4.00 MiB
  Total PE              4994
  Alloc PE / Size       4984 / <19.47 GiB
  Free  PE / Size       10 / 40.00 MiB
  VG UUID               dNdjU8-x3mX-y2bK-7PtF-nUDs-v0a2-dG3FGL
```

将当前创建的物理卷加入到根分区所在的卷
```
[root@k8s001 ~]# vgextend centos /dev/sda3
```

7、将卷组剩余空间添加到逻辑卷/dev/centos/root

这里使用lvdisplay获取lvpath
```
[root@k8s001 ~]# lvdisplay
  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                MJDQsP-W7Vs-A9rd-xygc-1fr0-QCHi-cQFPTP
  LV Write Access        read/write
  LV Creation host, time localhost, 2018-12-17 15:34:15 +0800
  LV Status              available
  # open                 1
  LV Size                <17.47 GiB
  Current LE             4472
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                6SC28L-BwvH-s1vK-Q5Wp-YF7Q-f6Sl-SiE5uj
  LV Write Access        read/write
  LV Creation host, time localhost, 2018-12-17 15:34:16 +0800
  LV Status              available
  # open                 2
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:1
```
由上面可知，我们需要将/dev/centos/root逻辑卷进行扩容
```
[root@k8s001 ~]# lvextend -l +100%FREE /dev/centos/root
```

8、使用xfs_growfs命令在线调整xfs格式文件系统大小
```
[root@k8s001 ~]# xfs_growfs /dev/centos/root
```

9、查看扩容结果
```
[root@k8s001 ~]# lsblk
NAME                                                                                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sr0                                                                                           11:0    1  1024M  0 rom
vda                                                                                          252:0    0   200G  0 disk
├─vda2                                                                                       252:2    0  19.5G  0 part
│ ├─centos-swap                                                                              253:1    0     2G  0 lvm
│ └─centos-root                                                                              253:0    0 197.5G  0 lvm  /
├─vda3                                                                                       252:3    0   180G  0 part
│ └─centos-root                                                                              253:0    0 197.5G  0 lvm  /
└─vda1                                                                                       252:1    0   500M  0 part /boot
```
至此，系统根分区扩容完毕。

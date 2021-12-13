作用：
```
规划大小超过2T的分区，也可用于小分区的规划。
```
用法：
```
parted [选项]... [设备 [命令 [参数]...]...]
```
帮助选项：  
```
-h, --help                    显示此求助信息 
-l, --list                    列出所有设别的分区信息
-i, --interactive             在必要时，提示用户 
-s, --script                  从不提示用户 
-v, --version                 显示版本
```
操作命令：
```
cp [FROM-DEVICE] FROM-MINOR TO-MINOR           #将文件系统复制到另一个分区 
help [COMMAND]                                 #打印通用求助信息，或关于 COMMAND 的信息 
mklabel 标签类型                                #改变磁盘的文件类型 ；
mkfs MINOR 文件系统类型                         #在 MINOR 创建类型为“文件系统类型”的文件系统 
mkpart 分区类型 [文件系统类型] 起始点 终止点      #创建一个分区 
mkpartfs 分区类型 文件系统类型 起始点 终止点      #创建一个带有文件系统的分区 
move MINOR 起始点 终止点                        #移动编号为 MINOR 的分区 
name MINOR 名称                                #将编号为 MINOR 的分区命名为“名称” 
print/p [MINOR]                                #打印分区表，或者分区 
quit/q                                         #保存退出程序 
rescue 起始点 终止点                            #挽救临近“起始点”、“终止点”的遗失的分区 
resize MINOR 起始点 终止点                      #改变位于编号为 MINOR 的分区中文件系统的大小 
rm MINOR                                       #删除编号为 MINOR 的分区 
select 设备                                     #选择要编辑的设备 
set MINOR 标志 状态                             #改变编号为 MINOR 的分区的标志
```

交互式
```
parted /dev/sdb              # select /dev/sdb
mklabel gpt                  # 设置分区类型为gpt
unit mb                      # 设置单位mb
mkpart primary 0% 100% 或者  mkpart primary 0 -1  //整块磁盘分为一个区
mkpart primary 0 10240       # 建立从0M开始的10g的分区
mkpart primary 0 200M        # 建立从0M开始的200M的分区,指定单位的
mkpart primary 10240 -1      # 建立从10g开始，剩下所有的空间都建立分区
print
quit
mkfs.xfs -f /dev/sdb1
```

非交互
```
# parted -s /dev/sdb mklabel gpt
# parted -s /dev/sdb mkpart primary 0% 20%
# parted -s /dev/sdb mkpart primary 21% 40%
# parted -s /dev/sdb mkpart primary 41% 60%
# parted -s /dev/sdb mkpart primary 61% 80%
# parted -s /dev/sdb mkpart primary 81% 100%
```


# 操作实例  

## 1、选择分区硬盘
```
首先类似fdisk一样，先选择要分区的硬盘，此处为/dev/vdb： ((parted)表示在parted中输入的命令，其他为自动打印的信息)

[root@node1 ~]# parted /dev/vdb
GNU Parted 3.1
使用 /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) help        # 看一下常用命令
  align-check TYPE N                        check partition N    for TYPE(min|opt) alignment
  help [COMMAND]                           print general help, or help on COMMAND
  mklabel,mktable LABEL-TYPE               create a new disklabel (partition table)
  mkpart PART-TYPE [FS-TYPE] START END     make a partition
  name NUMBER NAME                         name partition NUMBER as NAME
  print [devices|free|list,all|NUMBER]     display the partition table, available devices, free space, all found partitions, or a particular partition
  quit                                     exit program
  rescue START END                         rescue a lost partition near START and END
  rm NUMBER                                delete partition NUMBER
  select DEVICE                            choose the device to edit
  disk_set FLAG STATE                      change the FLAG on selected device
  disk_toggle [FLAG]                       toggle the state of FLAG on selected device
  set NUMBER FLAG STATE                    change the FLAG on partition NUMBER
  toggle [NUMBER [FLAG]]                   toggle the state of FLAG on partition NUMBER
  unit UNIT                                set the default unit to UNIT
  version                                  display the version number and copyright information of GNU Parted
```

## 2、创建分区
```
选择了/dev/hdd作为我们操作的磁盘，接下来需要创建一个分区表(在parted中可以使用help命令打印帮助信息)：

(parted) mklabel
新的磁盘标签类型？ gpt  # (我们要正确分区大于2TB的磁盘，应该使用gpt方式的分区表，输入gpt后回车)
```

## 3、完成分区操作
```
创建好分区表以后，接下来就可以进行分区操作了，执行mkpart命令，分别输入分区名称，文件系统和分区 的起止位置：

(parted) mkpart
分区名称？  []? partb
文件系统类型？  [ext2]? ext4
起始点？ 1    # 1表示从最开始分区，也可以用百分比表示，比如Start? 0% , End? 50%；
结束点？ -1   # -1表示到磁盘末尾；也可以分成多个磁盘，写要分配的大小；
```

## 4、验证分区信息
```
分好区后可以使用print命令打印分区信息，下面是一个print的样例：

(parted) print     # 简写p
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 2147GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name   标志
 1      1049kB  2147GB  2147GB               partb

(parted) quit   # 退出
信息: You may need to update /etc/fstab.
```

## 5、删除分区示例
```
如果分区错了，可以使用rm命令删除分区，比如我们要删除上面的分区，然后打印删除后的结果

(parted) rm 1              #rm后面使用分区的号码，就是用print打印出来的Number
(parted) print
Model: VBOX HARDDISK (ide)
Disk /dev/vdb: 2147GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number Start End Size File system Name Flags
```

## 6、格式化操作
```
完成以后我们可以使用quit命令退出parted并使用系统的mkfs命令对分区进行格式化了。 

[root@node1 ~]# ll /dev/vdb*
brw-rw---- 1 root disk 253, 16 5月  14 09:40 /dev/vdb
brw-rw---- 1 root disk 253, 17 5月  14 09:40 /dev/vdb1
[root@node1 ~]# fdisk -l
磁盘 /dev/vda：42.9 GB, 42949672960 字节，83886080 个扇区

Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x0009e68a

   设备 Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048    83884031    41940992   83  Linux
WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.

磁盘 /dev/vdb：2147.5 GB, 2147483648000 字节，4194304000 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：gpt

#         Start          End    Size  Type            Name
 1         2048   4194301951      2T  Microsoft basic partb
WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.
```

```
[root@node1 ~]# mkfs.ext4 /dev/vdb1
mke2fs 1.42.9 (28-Dec-2013)
文件系统标签=
OS type: Linux
块大小=4096 (log=2)
分块大小=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072000 inodes, 524287488 blocks
26214374 blocks (5.00%) reserved for the super user
第一个数据块=0
Maximum filesystem blocks=4294967296
16000 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
102400000, 214990848, 512000000

Allocating group tables: 完成
正在写入inode表: 完成
Creating journal (32768 blocks): 完成
Writing superblocks and filesystem accounting information: 完成

[root@node1 ~]# mkdir /data
[root@node1 ~]# mount /dev/vdb1 /data/
[root@node1 ~]# df -h
文件系统        容量  已用  可用 已用% 挂载点
/dev/vda1        40G  1.5G   36G    5% /
devtmpfs         32G     0   32G    0% /dev
tmpfs            32G     0   32G    0% /dev/shm
tmpfs            32G  8.3M   32G    1% /run
tmpfs            32G     0   32G    0% /sys/fs/cgroup
/dev/vdb1       2.0T   71M  1.9T    1% /data
[root@node1 ~]# blkid
/dev/vda1: UUID="6634633e-001d-43ba-8fab-202f1df93339" TYPE="ext4"
/dev/vdb1: UUID="d4993a37-4a33-4c95-95de-9711413196c0" TYPE="ext4" PARTLABEL="partb" PARTUUID="385073f7-3a5b-4312-8c42-27a2d1f882cf"
[root@node1 ~]# cp -a /etc/fstab{,.bak}
[root@node1 ~]# vim /etc/fstab
# /etc/fstab
# Created by anaconda on Fri Nov 21 18:16:53 2014
#
# Accessible filesystems, by reference, are maintained under    '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=6634633e-001d-43ba-8fab-202f1df93339 / ext4 defaults,barrier=0 1 1
UUID=d4993a37-4a33-4c95-95de-9711413196c0 /data ext4 defaults 0 0
```
注意
```
使用fdisk或parted工具只是将分区信息写入到磁盘，如果需要使用mkfs格式化并使用分区，则需要重新启动系统。partprobe 是一个可以修改kernel中分区表的工具，可以使kernel重新读取分区表而不用重启系统。
partprobe  /dev/vdb
```

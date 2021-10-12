# Linux IO实时监控iostat命令详解

## 使用方法
```
iostat [ 选项 ] [ <时间间隔> [ <次数> ]]

iostat [ -c ] [ -d ] [ -h ] [ -N ] [ -k | -m ] [ -t ] [ -V ] [ -x ] [ -z ] [ device [...] | ALL ] [ -p [ device [,...] | ALL ] ] [ interval [ count ] ]

-c 显示CPU使用情况
-d 显示磁盘使用情况
-k 以K为单位显示
-m 以M为单位显示
-N 显示磁盘阵列(LVM) 信息
-n 显示NFS使用情况
-p 可以报告出每块磁盘的每个分区的使用情况
-t 显示终端和CPU的信息
-x 显示详细信息
```
 
## 使用实例

命令：iostat -x
```
# iostat -x
Linux 2.6.32-504.16.2.el6.x86_64 (A01-R04-I255-59.JD.LOCAL)     2020年12月22日     _x86_64_    (32 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.53    0.00    0.44    0.00    0.00   99.03

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.04     2.48    0.18    1.04    33.66    28.16    51.04     0.00    1.18   0.39   0.05
```
监控cpu
- %user：CPU处在用户模式下的时间百分比
- %nice：CPU处在带NICE值的用户模式下的时间百分比
- %system：CPU处在系统模式下的时间百分比
- %iowait：CPU等待输入输出完成时间的百分比
- %steal：管理程序维护另一个虚拟处理器时，虚拟CPU的无意识等待时间百分比
- %idle：CPU空闲时间百分比

监测磁盘性能
- Device：设备名称
- rrqm/s：每秒合并到设备的读取请求数
- wrqm/s：每秒合并到设备的写请求数
- r/s：每秒向磁盘发起的读操作数
- w/s：每秒向磁盘发起的写操作数
- rkB/s：每秒读K字节数
- wkB/s:每秒写K字节数
- avgrq-sz：平均每次设备I/O操作的数据大小
- avgqu-sz：平均I/O队列长度
- await：平均每次设备I/O操作的等待时间 (毫秒)，一般地，系统I/O响应时间应该低于5ms，如果大于 10ms就比较大了
- r_await：每个读操作平均所需的时间；不仅包括硬盘设备读操作的时间，还包括了在kernel队列中等待的时间
- w_await：每个写操作平均所需的时间；不仅包括硬盘设备写操作的时间，还包括了在kernel队列中等待的时间
- svctm：平均每次设备I/O操作的服务时间 (毫秒)（这个数据不可信！）
- %util：一秒中有百分之多少的时间用于I/O操作，即被IO消耗的CPU百分比，一般地，如果该参数是100%表示设备已经接近满负荷运行了



 

命令：iostat -d 2 3
```
# iostat -d 2 3
Linux 2.6.32-504.16.2.el6.x86_64 (A01-R04-I255-59.JD.LOCAL)     2020年12月22日     _x86_64_    (32 CPU)

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               1.21        33.66        28.16 2242229290 1875726496

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               0.50         0.00         4.00          0          8

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               2.50         0.00        28.00          0         56
```
- tps：每秒I/O数（即IOPS。磁盘连续读和连续写之和）
- kB_read/s：每秒从磁盘读取数据大小，单位KB/s
- kB_wrtn/s：每秒写入磁盘的数据的大小，单位KB/s
- kB_read：从磁盘读出的数据总数，单位KB
- kB_wrtn：写入磁盘的的数据总数，单位KB

 

参数 -d 表示，显示设备（磁盘）使用状态；-k某些使用block为单位的列强制使用Kilobytes为单位；2表示，数据显示每隔2秒刷新一次。
```
iostat -d -k 1 10
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              39.29        21.14         1.44  441339807   29990031
sda1              0.00         0.00         0.00       1623        523
sda2              1.32         1.43         4.54   29834273   94827104
sda3              6.30         0.85        24.95   17816289  520725244
sda5              0.85         0.46         3.40    9543503   70970116
sda6              0.00         0.00         0.00        550        236
sda7              0.00         0.00         0.00        406          0
sda8              0.00         0.00         0.00        406          0
sda9              0.00         0.00         0.00        406          0
sda10            60.68        18.35        71.43  383002263 1490928140

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             327.55      5159.18       102.04       5056        100
sda1              0.00         0.00         0.00          0          0
```
- tps：该设备每秒的传输次数（Indicate the number of transfers per second that were issued to the device.）。"一次传输"意思是"一次I/O请求"。多个逻辑请求可能会被合并为"一次I/O请求"。"一次传输"请求的大小是未知的。
- kB_read/s：每秒从设备（drive expressed）读取的数据量；
- kB_wrtn/s：每秒向设备（drive expressed）写入的数据量；
- kB_read：读取的总数据量；
- kB_wrtn：写入的总数量数据量；这些单位都为Kilobytes。

上面的例子中，我们可以看到磁盘sda以及它的各个分区的统计数据，当时统计的磁盘总TPS是39.29，下面是各个分区的TPS。（因为是瞬间值，所以总TPS并不严格等于各个分区TPS的总和）

 

指定监控的设备名称为sda，该命令的输出结果和上面命令完全相同。
```
iostat -d sda 2
```
默认监控所有的硬盘设备，现在指定只监控sda。 

 
## -x 参数

iostat还有一个比较常用的选项-x，该选项将用于显示和io相关的扩展数据。
```
iostat -d -x -k 1 10
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          1.56  28.31  7.80 31.49   42.51    2.92    21.26     1.46     1.16     0.03    0.79   2.62  10.28
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          2.00  20.00 381.00  7.00 12320.00  216.00  6160.00   108.00    32.31     1.75    4.50   2.17  84.20
```
输出信息的含义
```
rrqm/s：每秒这个设备相关的读取请求有多少被Merge了（当系统调用需要读取数据的时候，VFS将请求发到各个FS，如果FS发现不同的读取请求读取的是相同Block的数据，FS会将这个请求合并Merge）；wrqm/s：每秒这个设备相关的写入请求有多少被Merge了。

rsec/s：每秒读取的扇区数；
wsec/：每秒写入的扇区数。
rKB/s：The number of read requests that were issued to the device per second；
wKB/s：The number of write requests that were issued to the device per second；
avgrq-sz 平均请求扇区的大小
avgqu-sz 是平均请求队列的长度。毫无疑问，队列长度越短越好。    
await：  每一个IO请求的处理的平均时间（单位是微秒毫秒）。这里可以理解为IO的响应时间，一般地系统IO响应时间应该低于5ms，如果大于10ms就比较大了。
         这个时间包括了队列时间和服务时间，也就是说，一般情况下，await大于svctm，它们的差值越小，则说明队列时间越短，反之差值越大，队列时间越长，说明系统出了问题。
svctm    表示平均每次设备I/O操作的服务时间（以毫秒为单位）。如果svctm的值与await很接近，表示几乎没有I/O等待，磁盘性能很好，如果await的值远高于svctm的值，则表示I/O队列等待太长，         系统上运行的应用程序将变慢。%util： 在统计时间内所有处理IO时间，除以总共统计时间。例如，如果统计间隔1秒，该设备有0.8秒在处理IO，而0.2秒闲置，那么该设备的%util = 0.8/1 = 80%，所以该参数暗示了设备的繁忙程度。一般地，如果该参数是100%表示设备已经接近满负荷运行了（当然如果是多磁盘，即使%util是100%，因为磁盘的并发能力，所以磁盘使用未必就到了瓶颈）。
```

## -c 参数

iostat还可以用来获取cpu部分状态值：
```
iostat -c 1 10
avg-cpu: %user %nice %sys %iowait %idle
1.98 0.00 0.35 11.45 86.22
avg-cpu: %user %nice %sys %iowait %idle
1.62 0.00 0.25 34.46 63.67
```
 
常见用法
```
iostat -d -k 1 10         #查看TPS和吞吐量信息(磁盘读写速度单位为KB)
iostat -d -m 2            #查看TPS和吞吐量信息(磁盘读写速度单位为MB)
iostat -d -x -k 1 10      #查看设备使用率（%util）、响应时间（await） iostat -c 1 10 #查看cpu状态
```
 
实例分析
```
ostat -d -k 1 |grep sda10
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda10            60.72        18.95        71.53  395637647 1493241908
sda10           299.02      4266.67       129.41       4352        132
sda10           483.84      4589.90      4117.17       4544       4076
sda10           218.00      3360.00       100.00       3360        100
sda10           546.00      8784.00       124.00       8784        124
sda10           827.00     13232.00       136.00      13232        136
```

上面看到，磁盘每秒传输次数平均约400；每秒磁盘读取约5MB，写入约1MB。
```
iostat -d -x -k 1
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          1.56  28.31  7.84 31.50   43.65    3.16    21.82     1.58     1.19     0.03    0.80   2.61  10.29
sda          1.98  24.75 419.80  6.93 13465.35  253.47  6732.67   126.73    32.15     2.00    4.70   2.00  85.25
sda          3.06  41.84 444.90 54.08 14204.08 2048.98  7102.04  1024.49    32.57     2.10    4.21   1.85  92.24
```
可以看到磁盘的平均响应时间<5ms，磁盘使用率>80。磁盘响应正常，但是已经很繁忙了。

 
性能监控指标

上面说了这么多，也看了那么多的系统输出，那我们在日常运维中到底需要关注哪些字段呢？下面就来说说这篇文章的重点了，我们到底该关注哪些输出内容就可以确定这台服务器是否存在IO性能瓶颈。

- %iowait：如果该值较高，表示磁盘存在I/O瓶颈
- await：一般地，系统I/O响应时间应该低于5ms，如果大于10ms就比较大了
- avgqu-sz：如果I/O请求压力持续超出磁盘处理能力，该值将增加。如果单块磁盘的队列长度持续超过2，一般认为该磁盘存在I/O性能问题。需要注意的是，如果该磁盘为磁盘阵列虚拟的逻辑驱动器，需要再将该值除以组成这个逻辑驱动器的实际物理磁盘数目，以获得平均单块硬盘的I/O等待队列长度
- %util：一般地，如果该参数是100%表示设备已经接近满负荷运行了

最后，除了关注指标外，我们更需要结合部署的业务进行分析。对于磁盘随机读写频繁的业务，比如图片存取、数据库、邮件服务器等，此类业务吗，tps才是关键点。对于顺序读写频繁的业务，需要传输大块数据的，如视频点播、文件同步，关注的是磁盘的吞吐量。

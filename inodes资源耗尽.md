1.inodes介绍
- Linux系统下文件数据储存在"块"中，文件的元信息，例如文件的创建者、文件的创建日期、文件的大小等。这种储存文件元信息的区域就叫做inode，中文译名为"索引节点"。
- inode也占用硬盘空间，硬盘格式化的时候，操作系统自动将硬盘分成两个区域。一个是数据区，存放文件数据；另一个是inode区（inode table），存放inode所包含的信息。
- 每个inode节点的大小，一般是128字节或256字节。inode节点的总数，在格式化时就给定，一般是每1KB或每2KB就设置一个inode。假定在一块1GB的硬盘中，每个inode节点的大小为128字节，每1KB就设置一个inode，那么inode table的大小就会达到128MB，占整块硬盘的12.8%。

2.inodes资源耗尽
- inodes使用完与存储空间使用完相似，都是创建不了文件或无法正常执行一些命令。inodes使用完，存储空间可能还有，这种情况一般是生成了大量的小文件，把inode table占满。
- 一般情况下存储空间使用完，inodes往往才使用百分之几，所以容易忽视对inodes使用情况的监控。

3.inodes耗尽解决
- inodes的大小在磁盘格式化分区时确定，跟分区的大小相关，分区越大，inodes越大，反之亦然。
- linux操作系统根目录一般分区比较小，如果有定时性的小文件产生而又未及时清理，则很容易造成inodes占满。

查看硬盘空间情况说明inode已用尽
---
1）、查看磁盘空间使用情况，使用df命令
```
[root@node01 ~]# df
Filesystem           1K-blocks       Used   Available   Use%   Mounted on
/dev/sdb1             19223252   12825820     5420948    71%   /
tmpfs                   707876          0      707876     0%   /dev/shm
/dev/sda1                99150      25473       68557    28%   /boot
```

2）、查看inodess使用情况，使用df -i命令
```
[root@node01 ~]# df -i
Filesystem             Inodes     IUsed   IFree  IUse%   Mounted on
/dev/sdb1             1220608   1220608       0   100%   /
tmpfs                  176969         1  176968     1%   /dev/shm
/dev/sda1               25688        38   25650     1%   /boot
```
- 命令df -h和df -hi，磁盘空间使用71%，但是inodes使用100%。


inodes占满解决步骤：
---
（1）查看文件最多的目录
```
for i in /*; do echo $i; find $i | wc -l; done
for i in /*; do num=`find $i | wc -l`; echo "$i $num"; done
```
如果确定目录范围，把/*写的具体点

最终发现是/var/spool/postfix/maildrop目录下小文件过多，原因如下：由于linux在执行cron时，会将cron执行脚本中的output和warning信息，都会以邮件的形式发送给cron所有者。由于客户环境中的sendmail和postfix没有正常运行，邮件发送不成功，导致全部小文件都堆积在maildrop目录下，另由于缺乏自动清理的机制，故此目录下堆积了大量的文件。

经过排查root用户下发现有个每分钟进行一次时钟同步的定时任务，该定时任务每分钟产生一个小文件。

（2）删除大量文件
```
ls | xargs -n 1000 rm -rf           # 需要使用xargs命令，不然会删除失败。  
```

4.总结

（1）设置方面在crontab -e 第一行增加MAILTO="" ，就没有文件产生啦

（2）重定向对定时任务设置定向输出文件，不需要日志输出的定时任务可以将日志重定向到/dev/null，如下：
```
*/10 * * * * /tmp/test.sh >/dev/null 2>&1
```
（3）定时清理文件
```
find 目录 -type f -mtime +30 | xargs -n 1000 rm -f *
```
（4）监控inodes的使用

备注：应注意crontab的写法和产生的文件的定时清理

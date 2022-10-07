# xfs文件系统备份与恢复

## 命令与软件包
```
[root@localhost ~]# rpm -qf `which xfsdump`
xfsdump-3.1.7-1.el7.x86_64
[root@localhost ~]# rpm -qf `which xfsrestore`
xfsdump-3.1.7-1.el7.x86_64
```

## xfsdump的备份级别有以下两种，默认为0（即完全备份）
```
0                       完全备份

1    <=   level <= 9    增量备份：
# ps：增量备份是和第一次的备份（level 0）进行比较，仅备份有差异的文件（level 1）
```

## xfsdump常用参数
```
-L：xfsdump会记录每次备份的session Label，这里可以填写针对此文件系统的简易说明；
-M：xfsdump可以记录存储Media Label，这里可以填写此媒体的简易说明。
-l：是L的小写，就是指定level，有0~9共10个等级，默认为0，即完整备份。
-f：后面接产生的文件和destination file 。例如/dev/st0设备文件名或其他一般文件文件名
-I：大写的“i”，从/var/lib/xfsdump/inventory 列出目前备份的信息状态
```

##  xfsdump使用限制
```
1.必须用root权限
2.只能备份已挂载的文件系统
3.只能备份XFS文件系统
4.只能用xfsrestore解释
5.透过文件系统的UUID来分辨备份档，因此不能备份相同UUID的文件系统
```

## xfsdump备份与xfsrestore恢复
```
# 1、数据备份
# 1.1 先做全量备份，切记“备份的源路径”末尾不要加左斜杠/
xfsdump -l 0 -L sdb3_bak -M sdb3_bak -f 全量备份的成果路径1 备份的源路径 

# 1.2 再做增量备份、
xfsdump -l 1 -L sdb3_bak -M sdb3_bak -f 增量备份的成果路径2 备份的源路径(可以是目录也可以是挂载的盘 例如/boot 或者/dev/sda1) 
xfsdump -l 1 -L sdb3_bak -M sdb3_bak -f 增量备份的成果路径3 备份的源路径 
xfsdump -l 1 -L sdb3_bak -M sdb3_bak -f 增量备份的成果路径4 备份的源路径 

# 2、数据恢复
# 2.1、先恢复全量备份
xfsrestore -f 全量备份的成果路径1 数据恢复的路径
# 2.2、再依次恢复增量
xfsrestore -f 增量备份的成果路径2 数据恢复的路径
xfsrestore -f 增量备份的成果路径2 数据恢复的路径
xfsrestore -f 增量备份的成果路径2 数据恢复的路径
```

## 示例：

### 数据备份
```
# 1、准备一个分区并制作好xfs文件系统，挂载好后给它加一点初始数据
[root@localhost ~]# df
文件系统         1K-块    已用    可用 已用% 挂载点
。。。。。。
/dev/sdb3      1038336   76836  961500    8% /opt
[root@localhost ~]# cp -r /etc/ /opt/
[root@localhost ~]# echo 111 > /opt/1.txt
[root@localhost ~]# ls /opt/
1.txt  etc
[root@localhost ~]# 

# 2、先做全量备份
[root@localhost ~]# xfsdump -l 0 -L sdb3_bak -M sdb3_bak -f /all.bak /opt

# 3、往/opt下新增文件2.txt，然后作增量备份
[root@localhost ~]# echo 222 > /opt/2.txt
[root@localhost ~]# xfsdump -l 1 -L sdb3_bak -M sdb3_bak -f /add.bak1 /opt

# 4、往/opt下新增文件3.txt，然后作增量备份
[root@localhost ~]# echo 333 > /opt/3.txt
[root@localhost ~]# xfsdump -l 1 -L sdb3_bak -M sdb3_bak -f /add.bak2 /opt

# 5、查看一下备份文件大小
[root@localhost ~]# du -sh /opt/
41M /opt/

[root@localhost ~]# ll -h /all.bak   # 全量备份大小
-rw-r--r--. 1 root root 37M 11月  4 18:44 /all.bak
[root@localhost ~]# ll -h /add.bak1  # 增量备份大小
-rw-r--r--. 1 root root 22K 11月  4 18:45 /add.bak1
[root@localhost ~]# ll -h /add.bak2  # 增量备份大小
-rw-r--r--. 1 root root 23K 11月  4 18:46 /add.bak2
```


### 数据恢复：
```
[root@localhost ~]# rm -rf /opt/`*` 
[root@localhost ~]# xfsrestore -f /all.bak /opt/  # 先恢复全量
......
[root@localhost ~]# ls /opt/
1.txt  etc
[root@localhost ~]# xfsrestore -f /add.bak1 /opt/  # 再恢复增量1
[root@localhost ~]# ls /opt/
1.txt  2.txt  etc
[root@localhost ~]# xfsrestore -f /add.bak2 /opt/  # 再恢复增量2
[root@localhost ~]# ls /opt/
1.txt  2.txt  3.txt  etc
```

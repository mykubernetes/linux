xtrabackup实现完全备份、增量备份和部分备份
=====================================
一、完全备份
-----------
```
#完全备份到指定目录
innobackupex --user=root --p 123 -H localhost /data/backup/ 
#查看备份目录内容 
ls /data/backup/2108_xxxx
#还原数据库，确认目录下没有数据
mkdir /data/backup -pv
#在备份点目录下，合并已提交的事物，回滚未提交的事物
innobackupex --apply-log  ./
#复制备份点的备份目录，到此要恢复的目录下
innobackupex --copy-back ./
#修改mysql目录下属主属组
chown -R mysql.mysql  /var/lib/mysql/
#启动mysql
systemctl start mariadb.service
```  

二、增量备份  
----------
```
#因为Myisa不支持增量，修改存储引擎为innodb
USE 'hellodb';

#指明基于那个全量备份路径做增量备份
innobackupex -u root -p 123 --incrementanl /data/backup/  --incremental-basedir=/data/backup/2018_xx1
#指明基于上一个增量备份路径做增量备份
innobackupex -u root -p 123 --incrementanl /data/backup/  --incremental-basedir=/data/backup/2018_xx2
#备份二进制文件
cd /data/backup/2018.xx2
less xtravackup_binlog_info #查看最后位置
#保持二进制文件到指定目录
cd /var/lib/mysql
mysqlbinlog -j xxxx master-log.xxxxx > /data/backup/binlog.sql

#还原数据库
#准备，全量合并第一个增量备份，只提交不回滚
innobackupex --apply-log --redo-only 2018.xxx  --incremental-dir=2018.xx1
#准备，全量合并第二个增量备份，只提交不回滚
innobackupex --apply-log --redo-only 2018.xxx  --incremental-dir=2018.xx2
#对合并后的全量备份做回滚
innobackupex --apply-log  2018.xxx
#恢复
innobackupex --copy-back 2018.xxx
cd /var/lib/mysql/
chown -R mysql.mysql ./*
systemctl start mariadb.service
mysql
mysql < /data/backup/binlog.sql
```  

三、完全备份加二进制日志binlog备份
----------------------------
```
备份：innobackupex  --user  --password=  --host=  /PATH/TO/BACKUP_DIR
准备：innobackupex --apply-log  /PATH/TO/BACKUP_DIR
恢复：innobackupex --copy-back
注意：--copy-back需要在mysqld主机本地进行，mysqld服务不能启动；
innodb_log_file_size可能要重新设定；
首先把完全和增量中的所有事物合并，然后未完成的回滚，恢复数据库
总结：完全+增量+binlog
备份：完全+增量+增量+...
```  

四、完全备份加差异备份
-------------------
```
准备：
innobackupex --apply-log --redo-only BASEDIR
innobackupex --apply-log --redo-only BASEDIR  --incremental-dir=INCREMENTAL-DIR

恢复：
innobackupex --copy-back BASEDIR

备份单库时候命令加上：
--databases
```  

linux下EOF写法梳理
===

通过cat配合重定向能够生成文件并追加操作
```
< :输入重定向
> :输出重定向
>> :输出重定向,进行追加,不会覆盖之前内容
<< :标准输入来自命令行的一对分隔号的中间内容.
```

1）向文件test.sh里输入内容
---

1、新建内容
```
# cat << EOF >test.sh
> 123123123
> 3452354345
> asdfasdfs
> EOF

# cat test.sh
123123123
3452354345
asdfasdfs
```

2、追加内容
```
# cat << EOF >>test.sh
> 7777
> 8888
> EOF

# cat test.sh
123123123
3452354345
asdfasdfs
7777
8888
```

3、覆盖之前的内容
```
# cat << EOF >test.sh
> 55555
> EOF
# cat test.sh
55555
```

2）自定义EOF，比如自定义为wang
---
```
# cat << wang > haha.txt
> ggggggg
> 4444444
> 6666666
> wang

# cat haha.txt
ggggggg
4444444
6666666
```

3）可以编写脚本，向一个文件输入多行内容
---

1、编辑脚本
```
# touch /usr/local/mysql/my.cnf                                # 文件不提前创建也行，如果不存在，EOF命令中也会自动创建

# vim test.sh
#!/bin/bash

cat > /usr/local/mysql/my.cnf << EOF                           # 或者cat << EOF > /usr/local/mysql/my.cnf
[client]
port = 3306
socket = /usr/local/mysql/var/mysql.sock

[mysqld]
port = 3306
socket = /usr/local/mysql/var/mysql.sock

basedir = /usr/local/mysql/
datadir = /data/mysql/data
pid-file = /data/mysql/data/mysql.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1
sync_binlog=1
log_bin = mysql-bin

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
port = 3306
EOF
```

2、执行上面脚本
```
# sh test.sh 
```

3、检查脚本中的EOF是否写入成功
```
# cat /usr/local/mysql/my.cnf 
[client]
port = 3306
socket = /usr/local/mysql/var/mysql.sock

[mysqld]
port = 3306
socket = /usr/local/mysql/var/mysql.sock

basedir = /usr/local/mysql/
datadir = /data/mysql/data
pid-file = /data/mysql/data/mysql.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1
sync_binlog=1
log_bin = mysql-bin

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
port = 3306
```

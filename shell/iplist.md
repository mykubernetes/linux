1、编辑iplist文件
```
cat config
# Host Login Info
user=root
passwd=123456
sshPort=22

# Host ip 
web=172.16.0.224 172.16.0.168
db=172.16.0.224 172.16.0.169 172.16.0.168
yum=httpd mysql
```

2、获取iplist信息
```
cat install.sh
#!/bin/sh
user=`sed '/^user=/!d;s/.*=//' $1 | sed 's/\r//g'`
passwd=`sed '/^passwd=/!d;s/.*=//' $1 | sed 's/\r//g'`
sshPort=`sed '/^sshPort=/!d;s/.*=//' $1 |sed 's/\r//g'`
web=`sed '/^web=/!d;s/.*=//' $1 | sed 's/\r//g'`
db=`sed '/^db=/!d;s/.*=//' $1 | sed 's/\r//g'`
yum=`sed '/^yum=/!d;s/.*=//' $1 | sed 's/\r//g'`

# 用逗号进行分隔
# dbList=${db// /,}


for host_name in web db;
do
iplist=`eval echo '$'"$host_name"`
for host in $iplist;
do
echo ssh ${user}@${host} -p ${sshPort} yum install ${yum}
./install_all.sh $user $host $sshPort $yum
done
done
```

```
cat install_all.sh
user=$1
host=$2
sshPort=$3
yum=$4

脚本文件
```

3、执行脚本
```
./install.sh config.txt
ssh root@172.16.0.224 -p 22 yum install httpd mysql
ssh root@172.16.0.168 -p 22 yum install httpd mysql
ssh root@172.16.0.224 -p 22 yum install httpd mysql
ssh root@172.16.0.169 -p 22 yum install httpd mysql
ssh root@172.16.0.168 -p 22 yum install httpd mysql
```

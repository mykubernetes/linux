SSH服务密码防暴力破解脚本
=======================
```
#! /bin/bash
#ssh 服务器防止密码暴力破解，15次密码错误就将主机IP加入host.deny文件
#ssh服务必须启用模块libwrap.so.0，使用命令ldd /usr/sbin/sshd | grep wrap查看
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /dev/black.txt
DEFINE="15"
for i in `cat /dev/black.txt`
do
        IP=`echo $i |awk -F= '{print $1}'`
        NUM=`echo $i|awk -F= '{print $2}'`
        if [ $NUM -gt $DEFINE ];
        then
                grep $IP /etc/hosts.deny > /dev/null
                if [ $? -gt 0 ];
                then
                        echo "sshd:$IP" >> /etc/hosts.deny
                fi
        fi
done
```  

1、脚本
```
ip=$1
mask=$2
gateway=$3

ipmitool lan print 1 > /dev/null 2>&1

if [ "$?" != "0" ]
then

echo """
===========================
install IPMI tools and libs
===========================
"""


rpm -ivh /tmp/ipmi-config/perl-Data-Dumper-2.145-3.el7.x86_64.rpm /tmp/ipmi-config/net-snmp-5.7.2-47.el7.x86_64.rpm  /tmp/ipmi-config/net-snmp-agent-libs-5.7.2-47.el7.x86_64.rpm  /tmp/ipmi-config/net-snmp-libs-5.7.2-47.el7.x86_64.rpm

rpm -ivh /tmp/ipmi-config/OpenIPMI-2.0.27-1.el7.x86_64.rpm /tmp/ipmi-config/OpenIPMI-modalias-2.0.27-1.el7.x86_64.rpm  /tmp/ipmi-config/OpenIPMI-libs-2.0.27-1.el7.x86_64.rpm

rpm -ivh /tmp/ipmi-config/ipmitool-1.8.18-7.el7.x86_64.rpm

echo "IPMI tools install finished!"

fi

#echo """
#===========================
#set IPMI address
#===========================
#"""
#read -p "input IPMI address: " ip
#read -p "input IPMI netmask: " mask
#read -p "input IPMI gateway: " gateway

#echo """
#plz check your IPMI info:
#IP address:   $ip
#Net mask  :   $mask
#Gateway   :   $gateway
#"""

#while [ 1 == 1 ]
#do
#read -p "IPMI info ok:[y/n]" ok
#if [ "$ok" == "y" ] 
#then
 ipmitool lan set 1 ipsrc static
 ipmitool lan set 1 ipaddr $ip && \
 ipmitool lan set 1 netmask $mask && \
 ipmitool lan set 1 defgw ipaddr $gateway
# if [ "$?" == "0" ]
# then
#   echo """
#==============================
#PMI IP config success!
#==============================
#   """ 
   ipmitool lan print 1|egrep "$ip|$mask|$gateway"
#   exit 0    
# fi
# exit 1
#i 
#
#f [ "$ok" == n ]
#hen
# exit 1
#i
#one
```


```
### 使用方式

1. 分发 ipmi-config 目录到服务器的 /tmp 目录下
2. 运行ipmi_IP.sh 脚本

```
执行方式：

sh /tmp/ipmi-config/ipmi_IP.sh  ipmiIP  ipmiMASK  ipmiGATEWAY

ipmiIP - ipmi 端口IP地址
ipmiMASK -  ipmi 端口掩码
ipmiGATEWAY - ipmi 端口的网关
```



###  推荐方式

ipmi 的IP地址主机位 与服务器的业务IP地址主机位相同，则可以通过循环搞定ipmi 的地址修改。

例如：

服务器IP地址： 20.10.1.20 - 20.10.1.32

ipmi IP地址：   20.11.1.20 - 20.11.1.32     ipmi掩码：255.255.255.0  网关： 20.11.1.1

```
for i in $(seq 20 32)
do
	scp -r ./ipmi-config 20.10.1.$i:/tmp
    ssh 20.10.1.$i sh /tmp/ipmi-config/ipmi_IP.sh  20.11.1.$i 255.255.255.0  20.11.1.1
done
```

```

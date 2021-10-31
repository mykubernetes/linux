首先执行：`ifconfig eth0` 查看当前网络信息：
```
eth0      Link encap:Ethernet  HWaddr b0:83:fe:da:2f:41  
          inet addr:192.168.100.181  Bcast:192.168.100.255  Mask:255.255.255.0
          inet6 addr: fe80::b283:feff:feda:2341/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:96451 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16208 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:11740051 (11.7 MB)  TX bytes:8021609 (8.0 MB)
          Interrupt:35 
```

获取MAC地址：
```
ifconfig eth0 | awk '/HWaddr/ {print $4}'
b0:83:fe:da:2f:41
```

获取本地IP地址：
```
ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'
192.168.100.181
```

获取广播地址：
```
ifconfig eth0 | awk '/Bcast/{print substr($3,7)}'
192.168.100.255
```

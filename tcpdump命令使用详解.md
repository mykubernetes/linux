# 一.概述

一般情况下，在Linux系统的使用和运维过程中，连接网络是必不可少的一个环节。在某些场景中，网络数据的收集与分析显得格外重要。tcpdump作为一款流行的网络数据抓取和收集工具，我们很有必要去了解一下。

本次验证tcpdump的操作系统为：CentOS Linux release 7.5.1804 (Core)

安装tcpdump：
```
[root@linuxidc ~]# yum -y install tcpdump
```

# 二.获取帮助资料

## 2.1 tcpdump -help

在使用Linux命令之前，如果遇到不熟悉的命令选项，就通过–help或者-h选项来对命令及选项做一个初步的了解。在tcpdump的–help中，使用方法及步骤太过于简略，此处不再赘述。

## 2.2 man tcpdump

部分内容如下：
```
tcpdump [-aAbdDefhHIJKlLnNOpqStuUvxX#] [ -B size ] [ -c count ]
  [ -C file_size ] [ -E algo:secret ] [ -F file ] [ -G seconds ]
  [ -i interface ] [ -j tstamptype ] [ -M secret ] [ --number ]
  [ -Q|-P in|out|inout ]
  [ -r file ] [ -s snaplen ] [ --time-stamp-precision precision ]
  [ --immediate-mode ] [ -T type ] [ --version ] [ -V file ]
  [ -w file ] [ -W filecount ] [ -y datalinktype ] [ -z postrotate-command ]
  [ -Z user ] [ expression ]
```

# 三.实践

1.显示所有可以被tcpdump的接口，使用选项-D。
```
[root@linuxidc ~]# tcpdump -D
1.nflog (Linux netfilter log (NFLOG) interface)
2.nfqueue (Linux netfilter queue (NFQUEUE) interface)
3.usbmon1 (USB bus number 1)
4.usbmon2 (USB bus number 2)
5.ens33
6.any (Pseudo-device that captures on all interfaces)
7.lo [Loopback]
```

2.获取指定接口的数据的信息，使用选项-i。
```
[root@linuxidc ~]# tcpdump -i ens33
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
23:43:37.837417 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765734802:2765735014, ack 3454639695, win 251, length 212
23:43:37.838749 IP linuxidc.59877 > public1.alidns.com.domain: 23489+ PTR? 1.1.1.10.in-addr.arpa. (39)
2 packets captured
14 packets received by filter
0 packets dropped by kernel
```
输出内容挺多的，刷得很快。可以根据标准输出的内容快速获取网络连接信息，按Ctrl+c退出。

3.抓取指定接口（设备）的数据包数量。使用的选项是-c。
```
[root@linuxidc ~]# tcpdump -c 10 -i ens33
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
00:47:33.754369 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765810766:2765810978, ack 3454668519, win 251, length 212
00:47:33.757822 IP linuxidc.40048 > public1.alidns.com.domain: 25834+ PTR? 1.1.1.10.in-addr.arpa. (39)
00:47:33.797033 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 212, win 2053, length 0
00:47:34.053798 IP public1.alidns.com.domain > linuxidc.40048: 25834 NXDomain 0/1/0 (116)
00:47:34.056344 IP linuxidc.41574 > public1.alidns.com.domain: 1158+ PTR? 21.1.1.10.in-addr.arpa. (40)
00:47:34.702924 IP public1.alidns.com.domain > linuxidc.41574: 1158 NXDomain 0/1/0 (117)
00:47:34.703374 IP linuxidc.59986 > public1.alidns.com.domain: 12257+ PTR? 5.5.5.223.in-addr.arpa. (40)
00:47:34.703561 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 212:392, ack 1, win 251, length 180
00:47:34.745614 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 392, win 2052, length 0
00:47:34.856428 IP public1.alidns.com.domain > linuxidc.59986: 12257 1/0/0 PTR public1.alidns.com. (72)
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

4.指定抓取包的时间戳，使用选项-tttt。
```
[root@linuxidc ~]# tcpdump -c 10 -tttt -i ens33
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
2018-08-29 00:52:46.759937 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 2765814682, win 2050, length 0
2018-08-29 00:52:46.766774 IP linuxidc.40898 > public1.alidns.com.domain: 57359+ PTR? 21.1.1.10.in-addr.arpa. (40)
2018-08-29 00:52:46.767024 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1:213, ack 0, win 251, length 212
2018-08-29 00:52:46.809552 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 213, win 2049, length 0
2018-08-29 00:52:49.829346 ARP, Request who-has linuxidc (00:0c:29:ce:40:b0 (oui Unknown)) tell 10.1.1.1, length 46
2018-08-29 00:52:49.829370 ARP, Reply linuxidc is-at 00:0c:29:ce:40:b0 (oui Unknown), length 28
2018-08-29 00:52:51.771436 IP linuxidc.40898 > public1.alidns.com.domain: 57359+ PTR? 21.1.1.10.in-addr.arpa. (40)
2018-08-29 00:52:51.783425 ARP, Request who-has gateway tell linuxidc, length 28
2018-08-29 00:52:51.783707 ARP, Reply gateway is-at 00:50:56:f5:98:bc (oui Unknown), length 46
2018-08-29 00:52:52.497640 IP public1.alidns.com.domain > linuxidc.40898: 57359 NXDomain 0/1/0 (117)
10 packets captured
22 packets received by filter
0 packets dropped by kernel
```

5.仅仅抓取ip数据包，使用选项-n。
```
[root@linuxidc ~]# tcpdump -c 10 -tttt -n -i ens33
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
2018-08-29 00:55:27.770507 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 2765822722:2765822934, ack 3454673575, win 251, length 212
2018-08-29 00:55:27.770973 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 212:408, ack 1, win 251, length 196
2018-08-29 00:55:27.771107 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 408:588, ack 1, win 251, length 180
2018-08-29 00:55:27.771237 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 588:768, ack 1, win 251, length 180
2018-08-29 00:55:27.771387 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 768:948, ack 1, win 251, length 180
2018-08-29 00:55:27.771570 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 948:1128, ack 1, win 251, length 180
2018-08-29 00:55:27.771690 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 1128:1308, ack 1, win 251, length 180
2018-08-29 00:55:27.771804 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 1308:1488, ack 1, win 251, length 180
2018-08-29 00:55:27.771944 IP 10.1.1.1.55011 > 10.1.1.21.ssh: Flags [.], ack 1488, win 2053, length 0
2018-08-29 00:55:27.772102 IP 10.1.1.21.ssh > 10.1.1.1.55011: Flags [P.], seq 1488:1764, ack 1, win 251, length 276
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

6.把抓取的数据包存取到文件，使用-w选项。
```
[root@linuxidc ~]# tcpdump -c 10 -tttt -n -i ens33 -w tcpdump.pcap
tcpdump: listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

该文件如果不指定路径的话，默认在当前操作目录下。不能直接被读取，需要使用tcpdump进行读取。这个命令也可以如下：
```
[root@linuxidc ~]# tcpdump -c 100 -tttt -n -i ens33 -w tcpdump.pcap greater 1024
[root@linuxidc ~]# tcpdump -c 100 -tttt -n -i ens33 -w tcpdump.pcap less 1024
```

7.从tcpdump文件中读取抓取的数据包。
```
[root@linuxidc ~]# tcpdump -r tcpdump.pcap
reading from file tcpdump.pcap, link-type EN10MB (Ethernet)
00:57:57.825513 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765825694:2765825842, ack 3454674579, win 251, length 148
00:57:57.825818 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 148, win 2053, length 0
00:57:58.203184 IP 10.1.1.1.58879 > 239.255.255.250.ssdp: UDP, length 174
00:57:59.203638 IP 10.1.1.1.58879 > 239.255.255.250.ssdp: UDP, length 174
00:58:05.116911 IP 10.1.1.1.56434 > linuxidc.ssh: Flags [P.], seq 4162589724:4162589776, ack 2392121475, win 2048, length 52
00:58:05.117228 IP linuxidc.ssh > 10.1.1.1.56434: Flags [.], ack 52, win 251, length 0
00:58:07.235581 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [P.], seq 1:53, ack 148, win 2053, length 52
00:58:07.235886 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 148:200, ack 53, win 251, length 52
00:58:07.277502 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 200, win 2052, length 0
00:58:09.821038 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [P.], seq 53:105, ack 200, win 2052, length 52
```

8.抓取指定接口的指定一些TCP/IP四层模型中网络层和传输层协议（如：TCP/UDP/ICMP/IAGMP/ARP/IP/RARP）的数据包。
```
[root@linuxidc ~]# tcpdump -c 10 -i ens33 tcp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:14:15.388381 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765855386:2765855598, ack 3454691347, win 340, length 212
01:14:15.389466 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 212, win 2049, length 0
01:14:15.959479 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 212:488, ack 1, win 340, length 276
01:14:15.959737 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 488:652, ack 1, win 340, length 164
01:14:15.959908 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 652:816, ack 1, win 340, length 164
01:14:15.960083 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 816:980, ack 1, win 340, length 164
01:14:15.960238 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 980:1144, ack 1, win 340, length 164
01:14:15.960388 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1144:1308, ack 1, win 340, length 164
01:14:15.960557 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1308:1472, ack 1, win 340, length 164
01:14:15.960721 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1472:1636, ack 1, win 340, length 164
10 packets captured
10 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 10 -i ens33 udp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:17:56.217920 IP 10.1.1.1.63463 > 239.255.255.250.ssdp: UDP, length 174
01:17:56.219257 IP linuxidc.48491 > public1.alidns.com.domain: 53308+ PTR? 250.255.255.239.in-addr.arpa. (46)
01:17:57.218813 IP 10.1.1.1.63463 > 239.255.255.250.ssdp: UDP, length 174
01:17:58.220117 IP 10.1.1.1.63463 > 239.255.255.250.ssdp: UDP, length 174
01:17:59.221545 IP 10.1.1.1.63463 > 239.255.255.250.ssdp: UDP, length 174
01:18:01.222170 IP linuxidc.48491 > public1.alidns.com.domain: 53308+ PTR? 250.255.255.239.in-addr.arpa. (46)
01:18:01.460643 IP public1.alidns.com.domain > linuxidc.48491: 53308 NXDomain 0/1/0 (103)
01:18:01.462527 IP linuxidc.46097 > public1.alidns.com.domain: 63425+ PTR? 1.1.1.10.in-addr.arpa. (39)
01:18:02.742698 IP public1.alidns.com.domain > linuxidc.46097: 63425 NXDomain 0/1/0 (116)
01:18:02.743371 IP linuxidc.60483 > public1.alidns.com.domain: 54493+ PTR? 5.5.5.223.in-addr.arpa. (40)
10 packets captured
13 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 10 -i ens33 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:20:40.492456 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 1, length 64
01:20:40.834752 IP 61.135.169.121 > linuxidc: ICMP echo reply, id 9516, seq 1, length 64
01:20:41.492751 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 2, length 64
01:20:42.131624 IP 61.135.169.121 > linuxidc: ICMP echo reply, id 9516, seq 2, length 64
01:20:42.493242 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 3, length 64
01:20:42.800717 IP 61.135.169.121 > linuxidc: ICMP echo reply, id 9516, seq 3, length 64
01:20:43.495523 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 4, length 64
01:20:44.495944 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 5, length 64
01:20:44.501359 IP 61.135.169.121 > linuxidc: ICMP echo reply, id 9516, seq 5, length 64
01:20:45.498312 IP linuxidc > 61.135.169.121: ICMP echo request, id 9516, seq 6, length 64
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

9.抓取指定端口上的数据包。
```
[root@linuxidc ~]# tcpdump -c 10 -i ens33 port 22
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:42:31.847590 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765881522:2765881734, ack 3454706475, win 340, length 212
01:42:31.847902 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 212, win 2049, length 0
01:42:32.302931 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 212:488, ack 1, win 340, length 276
01:42:32.303095 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 488:652, ack 1, win 340, length 164
01:42:32.303185 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 652, win 2053, length 0
01:42:32.303329 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 652:912, ack 1, win 340, length 260
01:42:32.303569 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 912:1076, ack 1, win 340, length 164
01:42:32.303646 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 1076, win 2051, length 0
01:42:32.303747 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1076:1336, ack 1, win 340, length 260
01:42:32.303876 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1336:1500, ack 1, win 340, length 164
10 packets captured
11 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 10 -i ens33 tcp port 22
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:43:34.120931 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 2765885010, win 2048, length 0
01:43:34.123537 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1:213, ack 0, win 340, length 212
01:43:34.164702 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 213, win 2047, length 0
01:43:34.645137 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 213:569, ack 0, win 340, length 356
01:43:34.645386 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 569:733, ack 0, win 340, length 164
01:43:34.645551 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 733, win 2053, length 0
01:43:34.645737 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 733:993, ack 0, win 340, length 260
01:43:34.645922 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 993:1157, ack 0, win 340, length 164
01:43:34.646021 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 1157, win 2051, length 0
01:43:34.646194 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1157:1417, ack 0, win 340, length 260
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

10.抓取指定源、目的IP上的数据包。
```
[root@linuxidc ~]# tcpdump -c 10 -i ens33 src 223.5.5.5
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:48:17.072240 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 35, length 64
01:48:17.372803 IP public1.alidns.com.domain > linuxidc.38253: 55537 NXDomain 0/1/0 (117)
01:48:17.414638 IP public1.alidns.com.domain > linuxidc.51867: 7178 1/0/0 PTR public1.alidns.com. (72)
01:48:18.070799 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 36, length 64
01:48:19.082138 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 37, length 64
01:48:20.099136 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 38, length 64
01:48:21.081299 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 39, length 64
01:48:22.079008 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 40, length 64
01:48:23.090255 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 41, length 64
01:48:24.230821 IP public1.alidns.com > linuxidc: ICMP echo reply, id 9555, seq 42, length 64
10 packets captured
11 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 10 -i ens33 dst 223.5.5.5
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:48:38.069626 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 56, length 64
01:48:38.073248 IP linuxidc.48285 > public1.alidns.com.domain: 46129+ PTR? 5.5.5.223.in-addr.arpa. (40)
01:48:38.135949 IP linuxidc.44970 > public1.alidns.com.domain: 27616+ PTR? 21.1.1.10.in-addr.arpa. (40)
01:48:39.072184 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 57, length 64
01:48:40.076144 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 58, length 64
01:48:41.077810 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 59, length 64
01:48:42.079204 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 60, length 64
01:48:43.080601 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 61, length 64
01:48:44.082011 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 62, length 64
01:48:45.083420 IP linuxidc > public1.alidns.com: ICMP echo request, id 9555, seq 63, length 64
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

11.抓取两台主机之间的数据包。
```
[root@linuxidc ~]# tcpdump -c 10 -i ens33 tcp and \( host 223.5.5.5 or host 10.1.1.21 \)
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:54:54.268935 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765927618:2765927830, ack 3454734639, win 340, length 212
01:54:54.269117 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 212, win 2051, length 0
01:54:54.561897 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 212:488, ack 1, win 340, length 276
01:54:54.562176 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 488:652, ack 1, win 340, length 164
01:54:54.562286 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 652, win 2050, length 0
01:54:54.562493 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 652:912, ack 1, win 340, length 260
01:54:54.562660 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 912:1076, ack 1, win 340, length 164
01:54:54.562808 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 1076, win 2048, length 0
01:54:54.563029 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1076:1336, ack 1, win 340, length 260
01:54:54.563212 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1336:1500, ack 1, win 340, length 164
10 packets captured
11 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 10 -i ens33 src 10.1.1.21 and port 22 and dst 10.1.1.1 and port 22
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
01:57:36.392318 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765943782:2765943994, ack 3454748435, win 362, length 212
01:57:36.904661 IP linuxidc.ssh > 10.1.1.1.56434: Flags [P.], seq 2392278579:2392278711, ack 4162603348, win 251, length 132
01:57:37.010706 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 212:520, ack 1, win 362, length 308
01:57:37.046307 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 520:684, ack 1, win 362, length 164
01:57:37.046546 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 684:848, ack 1, win 362, length 164
01:57:37.046669 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 848:1012, ack 1, win 362, length 164
01:57:37.046842 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1012:1176, ack 1, win 362, length 164
01:57:37.046999 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1176:1340, ack 1, win 362, length 164
01:57:37.047214 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1340:1504, ack 1, win 362, length 164
01:57:37.047399 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1504:1668, ack 1, win 362, length 164
10 packets captured
10 packets received by filter
0 packets dropped by kernel
```

12.以HEX或ASCII格式抓取数据包，分别使用选项-XX和-A即可。
```
[root@linuxidc ~]# tcpdump -c 3 -i ens33 -XX
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
02:03:21.704787 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 2765959902:2765960114, ack 3454752171, win 362, length 212
    0x0000:  0050 56c0 0008 000c 29ce 40b0 0800 4510  .PV.....).@...E.
    0x0010:  00fc 3612 4000 4006 edc2 0a01 0115 0a01  ..6.@.@.........
    0x0020:  0101 0016 d6e3 a4dd 32de cdeb 55ab 5018  ........2...U.P.
    0x0030:  016a 1706 0000 0000 00b0 bcc9 c244 c5bc  .j...........D..
    0x0040:  fb53 12de b143 b265 a9cb 7a34 670b f634  .S...C.e..z4g..4
    0x0050:  d2a5 d977 8de5 1bb0 6166 5394 e0dc 8311  ...w....afS.....
    0x0060:  1e63 1c33 0cae e945 d639 f505 583f dd45  .c.3...E.9..X?.E
    0x0070:  abd7 3822 4d63 2649 0e8d 19ac 2713 4732  ..8"Mc&I....'.G2
    0x0080:  7d7f eb9b df16 295a 94c9 1c68 e456 8319  }.....)Z...h.V..
    0x0090:  dc94 469a 8fbf a84b 7203 b010 0869 3193  ..F....Kr....i1.
    0x00a0:  7957 afad 19d3 3610 b0aa 4488 df5f 3f4b  yW....6...D.._?K
    0x00b0:  1f03 83f9 a480 0d08 cc6b 234c 5804 0787  .........k#LX...
    0x00c0:  180e 5cd0 e681 5c2a cd2f 216e 1f32 53dd  ..\...\*./!n.2S.
    0x00d0:  aa8e 1b22 c6d4 f8c0 896d 2b04 c00d 52f9  ...".....m+...R.
    0x00e0:  56b3 0189 1672 3e1f 35ce 72bc f8f1 3aaf  V....r>.5.r...:.
    0x00f0:  82e7 b2f6 c8af c3a5 36af 0616 c21d 6808  ........6.....h.
    0x0100:  246c bb48 2609 5583 d667                $l.H&.U..g
02:03:21.704989 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 212, win 2049, length 0
    0x0000:  000c 29ce 40b0 0050 56c0 0008 0800 4500  ..).@..PV.....E.
    0x0010:  0028 7afc 4000 8006 69bc 0a01 0101 0a01  .(z.@...i.......
    0x0020:  0115 d6e3 0016 cdeb 55ab a4dd 33b2 5010  ........U...3.P.
    0x0030:  0801 be9b 0000 0000 0000 0000            ............
02:03:21.705899 IP linuxidc.58309 > public1.alidns.com.domain: 46252+ PTR? 1.1.1.10.in-addr.arpa. (39)
    0x0000:  0050 56f5 98bc 000c 29ce 40b0 0800 4500  .PV.....).@...E.
    0x0010:  0043 e88b 4000 4011 62fe 0a01 0115 df05  .C..@.@.b.......
    0x0020:  0505 e3c5 0035 002f ef60 b4ac 0100 0001  .....5./.`......
    0x0030:  0000 0000 0000 0131 0131 0131 0231 3007  .......1.1.1.10.
    0x0040:  696e 2d61 6464 7204 6172 7061 0000 0c00  in-addr.arpa....
    0x0050:  01                                      .
3 packets captured
10 packets received by filter
0 packets dropped by kernel

[root@linuxidc ~]# tcpdump -c 3 -i ens33 -A
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
02:03:53.931462 IP 10.1.1.1.55011 > linuxidc.ssh: Flags [.], ack 2765963078, win 2048, length 0
E..({,@...i.
...
.........WG..?FP....l........
02:03:53.933710 IP linuxidc.40263 > public1.alidns.com.domain: 12427+ PTR? 21.1.1.10.in-addr.arpa. (40)
E..D..@.@.:.
........G.5.0.a0............21.1.1.10.in-addr.arpa.....
02:03:53.934052 IP linuxidc.ssh > 10.1.1.1.55011: Flags [P.], seq 1:213, ack 0, win 362, length 212
E...6.@.@...
...
.........?F..WGP..j..........T.IP.9~<..>....5...{..>> ..N.8.j.>...%.$.X;JE......}../z..Z...L..!.N6<.!'..^F...&..:+-}9.2.c.Bd.."...6Y...(W......!..QY.CWG.....s.[. L.>ED.......>.,1u..........-..> L.."... .......|.;.z|.0AB.R)z...q...N$...
3 packets captured
12 packets received by filter
0 packets dropped by kernel
```

# 四.总结

- 1.tcpdump的使用比较简单，上文已经列举了该工具的常用用法。
- 2.需要加强对TCP/IP四层参考模型的理解，文中涉及到的协议包括网络层和传输层的常见协议。

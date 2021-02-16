通过调试系统内核参数使系统性能最大化

sysctl -a 查看所有系统变量
```
-n：打印值时不打印关键字； 
-e：忽略未知关键字错误； 
-N：仅打印名称； 
-w：当改变sysctl设置时使用此项； 
-p：从配置文件“/etc/sysctl.conf”加载内核参数设置； 
-a：打印当前所有可用的内核参数变量和值； 
-A：以表格方式打印当前所有可用的内核参数变量和值。
```

/proc/sys下内核文件与配置文件sysctl.conf中变量存在着对应关系 配置说明
```
net.inet.tcp.sendspace=65536            #最大的待发送TCP数据缓冲区空间  
net.inet.tcp.recvspace=65536            #最大的接受TCP缓冲区空间 
net.inet.udp.sendspace=65535            #最大的接受UDP缓冲区大小  
net.inet.udp.maxdgram=65535             #最大的发送UDP数据缓冲区大小  
net.local.stream.sendspace=65535        #本地套接字连接的数据发送空间  
net.inet.tcp.rfc1323=1                  #加快网络性能的协议  
net.inet.tcp.rfc1644=1
net.inet.tcp.rfc3042=1
net.inet.tcp.rfc3390=1
kern.ipc.maxsockbuf=2097152             #最大的套接字缓冲区  
kern.maxfiles=65536                     #系统中允许的最多文件数量  
kern.maxfilesperproc=32768              #每个进程能够同时打开的最大文件数量  
net.inet.tcp.delayed_ack=0              #当一台计算机发起TCP连接请求时，系统会回应ACK应答数据包。该选项设置是否延迟ACK应答数据包，把它和包含数据的数据包一起发送，在高速网络和低负载的情况下会略微提高性能，但在网络连接较差的时候，对方计算机得不到应答会持续发起连接请求，反而会降低性能。  
net.inet.icmp.drop_redirect=1           #屏蔽ICMP重定向功能  
net.inet.icmp.log_redirect=1  
net.inet.ip.redirect=0  
net.inet6.ip6.redirect=0  
net.inet.icmp.bmcastecho=0              #防止ICMP广播风暴  
net.inet.icmp.maskrepl=0 
net.inet.icmp.icmplim=100               #限制系统发送ICMP速率  
net.inet.icmp.icmplim_output=0           #安全参数，编译内核的时候加了options TCP_DROP_SYNFIN才可以用  
net.inet.tcp.drop_synfin=1              #安全参数，编译内核的时候加了options TCP_DROP_SYNFIN才可以用  
net.inet.tcp.always_keepalive=1         #设置为1会帮助系统清除没有正常断开的TCP连接，这增加了一些网络带宽的使用，但是一些死掉的连接最终能被识别并清除。死的TCP连接是被拨号用户存取的系统的一个特别的问题，因为用户经常断开modem而不正确的关闭活动的连接 
net.inet.ip.intr_queue_maxlen=1000      #若看到net.inet.ip.intr_queue_drops这个在增加，就要调大net.inet.ip.intr_queue_maxlen，为0最好  
net.inet.tcp.msl=7500                   #防止DOS攻击，默认为30000  
net.inet.tcp.blackhole=2                #接收到一个已经关闭的端口发来的所有包，直接drop，如果设置为1则是只针对TCP包 
net.inet.udp.blackhole=1                #接收到一个已经关闭的端口发来的所有UDP包直接drop  
net.inet.tcp.inflight.enable=1          #为网络数据连接时提供缓冲  
net.inet.ip.fastforwarding=0            #如果打开的话每个目标地址一次转发成功以后它的数据都将被记录进路由表和arp数据表，节约路由的计算时间,但会需要大量的内核内存空间来保存路由表  
#kern.polling.enable=1                  #kernel编译打开options POLLING功能，高负载情况下使用低负载不推荐SMP不能和polling一起用 
kern.ipc.somaxconn=32768                #并发连接数，默认为128，推荐在1024-4096之间，数字越大占用内存也越大 
security.bsd.see_other_uids=0           #禁止用户查看其他用户的进程  
kern.securelevel=0                      #设置kernel安全级别  
net.inet.tcp.log_in_vain=1              #记录下任何TCP连接  
net.inet.udp.log_in_vain=1              #记录下任何UDP连接  
net.inet.udp.checksum=1                 #防止不正确的udp包的攻击  
net.inet.tcp.syncookies=1               #防止DOS攻击  
kern.ipc.shm_use_phys=1                 #仅为线程提供物理内存支持，需要256兆以上内存  
kern.ipc.shmmax=67108864                #线程可使用的最大共享内存  
kern.ipc.shmall=32768                   #最大线程数量  
kern.coredump=0                         #程序崩溃时不记录  
net.local.stream.recvspace=65536        #lo本地数据流接收和发送空间  
net.local.dgram.maxdgram=16384
net.local.dgram.recvspace=65536
net.inet.tcp.mssdflt=1460               #数据包数据段大小，ADSL为1452。 
net.inet.tcp.inflight_enable=1          #为网络数据连接时提供缓冲  
net.inet.tcp.minmss=1460                #数据包数据段最小值，ADSL为1452  
net.inet.raw.maxdgram=65536             #本地数据最大数量  
net.inet.raw.recvspace=65536            #本地数据流接收空间  
net.inet.ip.fw.dyn_max=65535            #ipfw防火墙动态规则数量，默认为4096，增大该值可以防止某些病毒发送大量TCP连接，导致不能建立正常连接 
net.inet.ipf.fr_tcpidletimeout=864000   #设置ipf防火墙TCP连接空闲保留时间，默认8640000（120小时）  
```

参考值(具体根据系统硬件配置对应值)
```
$ /proc/sys/net/core/wmem_max
最大socket写buffer,可参考的优化值:873200
$ /proc/sys/net/core/rmem_max
最大socket读buffer,可参考的优化值:873200
$ /proc/sys/net/ipv4/tcp_wmem
TCP写buffer,可参考的优化值: 8192 436600 873200
$ /proc/sys/net/ipv4/tcp_rmem
TCP读buffer,可参考的优化值: 32768 436600 873200
$ /proc/sys/net/ipv4/tcp_mem
同样有3个值,意思是:
net.ipv4.tcp_mem[0]:低于此值,TCP没有内存压力.
net.ipv4.tcp_mem[1]:在此值下,进入内存压力阶段.
net.ipv4.tcp_mem[2]:高于此值,TCP拒绝分配socket.
上述内存单位是页,而不是字节.可参考的优化值是:786432 1048576 1572864
$ /proc/sys/net/core/netdev_max_backlog
进入包的最大设备队列.默认是300,对重负载服务器而言,该值太低,可调整到1000.
$ /proc/sys/net/core/somaxconn
listen()的默认参数,挂起请求的最大数量.默认是128.对繁忙的服务器,增加该值有助于网络性能.可调整到256.
$ /proc/sys/net/core/optmem_max
socket buffer的最大初始化值,默认10K.
$ /proc/sys/net/ipv4/tcp_max_syn_backlog
进入SYN包的最大请求队列.默认1024.对重负载服务器,增加该值显然有好处.可调整到2048.
$ /proc/sys/net/ipv4/tcp_retries2
TCP失败重传次数,默认值15,意味着重传15次才彻底放弃.可减少到5,以尽早释放内核资源.
$ /proc/sys/net/ipv4/tcp_keepalive_time
$ /proc/sys/net/ipv4/tcp_keepalive_intvl
$ /proc/sys/net/ipv4/tcp_keepalive_probes
这3个参数与TCP KeepAlive有关.默认值是:
tcp_keepalive_time = 7200 seconds (2 hours)
tcp_keepalive_probes = 9
tcp_keepalive_intvl = 75 seconds
意思是如果某个TCP连接在idle 2个小时后,内核才发起probe.如果probe 9次(每次75秒)不成功,内核才彻底放弃,认为该连接已失效.对服务器而言,显然上述值太大. 可调整到:
/proc/sys/net/ipv4/tcp_keepalive_time 1800
/proc/sys/net/ipv4/tcp_keepalive_intvl 30
/proc/sys/net/ipv4/tcp_keepalive_probes 3
$ proc/sys/net/ipv4/ip_local_port_range
指定端口范围的一个配置,默认是32768 61000,已够大.
net.ipv4.tcp_syncookies = 1
表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1
表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1
表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout = 30
表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间。
net.ipv4.tcp_keepalive_time = 1200
表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为20分钟。
net.ipv4.ip_local_port_range = 1024 65000
表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为1024到65000。
net.ipv4.tcp_max_syn_backlog = 8192
表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
net.ipv4.tcp_max_tw_buckets = 5000
表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。默认为180000，改为 5000。对于Apache、Nginx等服务器，上几行的参数可以很好地减少TIME_WAIT套接字数量，但是对于Squid，效果却不大。此项参数可以控制TIME_WAIT套接字的最大数量，避免Squid服务器被大量的TIME_WAIT套接字拖死。
```

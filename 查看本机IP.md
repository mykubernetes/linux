Linux查看本机IP：curl cip.cc
===

绝大多数情况下计算机都是通过NET去上连接互联网的，不管是公司的内部数据中心或是家庭网络大都如此，如果我们想获取公网的出口ip改如何操作嗯？下面提供了几种方法，它们返回结果的速度不太有快有慢，测试curl cip.cc这个命令算是比较好用。
```
curl http://members.3322.org/dyndns/getip
curl icanhazip.com
curl ident.me
curl ifconfig.me
curl ifconfig.co
curl ip.6655.com/ip.aspx
curl ip.cip.cc
curl ipecho.net/plain
curl myip.dnsomatic.com
curl whatismyip.akamai.com
```

更多用法访问
```
wget -qO - ifconfig.co
```

返回IP和地区
```
curl ip.6655.com/ip.aspx?area=1
curl cip.cc
```

windos可以通过浏览器获取，当然cmd窗口命令获取也没问题
```
URL : http://www.cip.cc
```
- 浏览器访问 ：https://ip138.com/
- 浏览器访问 ：http://icanhazip.com/



- trusted（信任） 允许所有的数据包流入与流出
- home（家庭） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许流量
- internal（内部） 等同于home区域
- work（工作） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许流量
- public（公共） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许流量
- external（外部） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量
- dmz（非军事区） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量
- block（限制） 拒绝流入的流量，除非与流出的流量相关；
- drop（丢弃） 拒绝流入的流量，除非与流出的流量相关；


1、默认定义的区域模板配置文件  
```
# ls /usr/lib/firewalld/zones/ 
block.xml  dmz.xml  drop.xml  external.xml  home.xml  internal.xml  public.xml  trusted.xml  work.xml
```  

2、存储规则配置文件  
```
# ls /etc/firewalld/zones/
public.xml  public.xml.old
```  
注意:默认区域为public如果切换区域可直接从区域模板读取  


3、firewalld规则分两种状态：
```
runtime(运行时): 修改规则马上生效，但是临时生效【不建议】
permanent(持久配置): 修改后需要reload重载才能生效【强烈推荐】
```  

4、firewall-cmd分类  

1)zone区域相关命令  
```
--get-default-zone               查询默认的区域名称
--set-default-zone=<区域名称>     设置默认的区域，使其永久生效
--get-active-zones               显示当前正在使用的区域与网卡名称
--get-zones                      显示总共可用的区域
--new-zone=                      新增区域
```  

2)services服务相关指令  
```
--get-services                   列出所有支持的 service
--list-services                  查看当前zone加载的 service
--add-service=<服务名>            设置默认区域允许该服务的流量
--remove-service=<服务名>         设置默认区域不再允许该服务的流量
```  

3)Port端口相关指令  
```
--add-port=<端口号/协议>          设置默认区域允许该端口的流量
--remove-port=<端口号/协议>       设置默认区域不再允许该端口的流量
```  


使用方法
---
查看当前的区域
```
firewall-cmd --get-default-zone
```
查询eth1网卡区域
```
firewall-cmd --get-zone-of-interface=eth1
```
查询public中相关服务是否被允许
```
firewall-cmd --zone=public --query-service=ssh
firewall-cmd --zone=public --query-service=http
```
列出所有支持的 service
```
firewall-cmd --get-services
```
查看当前zone加载的 service
```
firewall-cmd --list-services
```
让配置文件立即生效
```
firewall-cmd --reload
```
允许https服务流量通过public
```
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
```
允许80端口通过public
```
firewall-cmd --permanent --zone=public --add-port=80/tcp 
firewall-cmd --reload
```
修改eth1网卡区域为external
```
firewall-cmd --permanent --zone=external --change-interface=eth1
firewall-cmd --reload
```
拒绝172.27.10.0/22网络用户访问ssh
```
firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="172.27.10.0/22" service name="ssh" reject"
```
重读防火墙

并不中断用户连接，即不丢失状态信息：
```
firewall-cmd --reload
```
中断用户连接，丢弃状态信息：
```
firewall-cmd --complete-reload
```
注意:通常在防火墙出现严重问题时，这个命令才会被使用。如防火墙规则正确，但态信息不正确和无法建立连接等。

设置默认区域
```
firewall-cmd --set-default-zone=work
```
注意:流入默认区域中配置的接口的新访问请求将被置入新的默认区域，当前活动的连接将不受影响。

获取活动的区域
```
firewall-cmd --get-active-zones
```
根据接口获取区域
```
firewall-cmd –get-zone-of-interface=<interface>
firewall-cmd --get-zone-of-interface=eth1
```
修改接口所属区域
```
firewall-cmd [–zone=] –change-interface=
```
列举区域中启用的服务
```
firewall-cmd [ –zone= ] –list-services
```
启用应急模式阻断所有网络连接
```
firewall-cmd --panic-on
```
禁用应急模式
```
firewall-cmd --panic-off
```
查询应急模式
```
firewall-cmd --query-panic
```
启用区域中的一种服务
```
firewall-cmd [--zone=<zone>] --add-service=<service> [--timeout=<seconds>]
```
使区域中的 ipp-client 服务生效60秒:
```
firewall-cmd --zone=home --add-service=ipp-client --timeout=60
```

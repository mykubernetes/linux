- trusted（信任） 允许所有的数据包流入与流出
- home（家庭） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许流量
- internal（内部） 等同于home区域
- work（工作） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许流量
- public（公共） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许流量
- external（外部） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量
- dmz（非军事区） 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量
- block（限制） 拒绝流入的流量，除非与流出的流量相关；
- drop（丢弃） 拒绝流入的流量，除非与流出的流量相关；

https://www.centos.bz/2017/08/firewalld-rule-intro-usage/  
1、默认定义的区域模板配置文件  
```
# ls /usr/lib/firewalld/zones/ 
block.xml  dmz.xml  drop.xml  external.xml  home.xml  internal.xml  public.xml  trusted.xml  work.xml

# ls /usr/lib/firewalld/services/
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

4)interface网卡相关命令  
```
--add-interface=<网卡名称>       将源自该网卡多的所有流量都定向某个指定区域
--change-interface=<网卡名称>    将某个网卡与区域进行关联
```  

5)其他相关指令
```
--list-all                      显示当前区域的网卡配置参数、资源、端口以及服务等信息
--reload                        让"永久生效"的配置规则立即生效，并覆盖当前配置
```  

5、备份firewalld相关配置文件（重要）  
```
cp -r /etc/firewalld/ /etc/firewalld_backup
```  

使用方法  
--
1)将氮气默认区域修改为drop  
```
firewall-cmd --set-default-zone=drop
```  

2)将网络接口关联至drop区域  
```
firewall-cmd --permanent --change-interface=eth0 --zone=drop
```  

3)将10.0.0.0/24网段加入trusted白名单
```
firewall-cmd --permanent --add-source=10.0.0.0/24 --zone=trusted
firewall-cmd --reload
```  

4)查看当前活动区域
```
firewall-cmd --get-active-zones
```  

端口转发策略
---
流量转发命令合适  
```
firewall-cmd --permanent --zone=<区域> --add-forward-port=port=<源端口号>：proto=<协议>:toport=<目标端口号>:toaddr=<目标IP地址>
```  
1、转发本机555/tcp端口的流量至22/tcp端口，要求当前和长期有效  
```
firewall-cmd --permanent --zone=public --add-forward-port=port=555:proto=tcp:toport=22:toaddr=10.0.0.61
firewall-cmd --reload
```  

2、移除本机转发555/tcp端口策略，要求当前和长期有效  
```
firewall-cmd --permanent --zone=public --remove-forward-port=port=555:proto=tcp:toport=22:toaddr=10.0.0.61
firewall-cmd --reload
```  

3、如果需要将本地的10.0.0.61:6666端口转发至后端10.0.0.9:22端口
```
1、开启ip伪装
firewall-cmd --add-masquerade --permanent
2、配置转发
firewall-cmd --permanent --zone=public --add-forward-port=port=6666:proto=tcp:toport=22:toaddr=10.0.0.9
firewall-cmd --reload
```

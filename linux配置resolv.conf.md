一、具体说明
===
/etc/resolv.conf是DNS客户机的配置文件，用于设置DNS服务器的IP地址及DNS域名，还包含了主机的域名搜索顺序。该文件是由域名解析器(resolver，一个根据主机名解析IP地址的库)使用的配置文件。它的格式比较简单，每行以一个关键字开头，后接一个或多个由空格隔开的参数。

resolv.conf的关键字主要有4个，分别为：
- nameserver：定义DNS服务器的IP地址
- domain：定义本地域名
- search：定义域名的搜索列表
- sortlist：对返回的域名进行排序  
注意：这里最主要的就是nameserver关键字，如果没有指定nameserver就找不到DNS服务，其它关键字是可选的。

1、参数解释

- nameserver
表明DNS服务器的IP地址。可以有很多行的nameserver，每一个带一个IP地址。在查询时就按nameserver在本文件中的顺序进行，且只有当第一个nameserver没有反应时才查询下面的nameserver。

- domain
声明主机的域名。很多程序用到它，如邮件系统；当为没有域名的主机进行DNS查询时，也要用到。如果没有域名，主机名将被使用，删除所有在第一个点( .)前面的内容。

- search
它的多个参数指明域名查询顺序。当要查询没有域名的主机，主机将在由search声明的域中分别查找。domain和search不能共存；如果同时存在，后面出现的将会被使用。

- sortlist
允许将得到域名结果进行特定的排序。它的参数为网络/掩码对，允许任意的排列顺序。

2、举例说明
```
cat /etc/resolv.conf
domain  51osos.com
search  www.51osos.com  51osos.com
nameserver 202.102.192.68
nameserver 202.102.192.69
```
1）nameserver：表示域名解析时，使用该地址指定的主机为域名服务器，其中域名服务器是按照文件中出现的顺序来查询的，且只有当第一个nameserver没有反应时才查询下面的nameserver。

2）domain：声明主机的域名，很多程序会用到，如邮件系统。当为没有域名的主机进行DNS查询时，也要用到。如果没有域名，主机名将被使用，删除所有在第一个点(.)前面的内容。

3）search：它的多个参数指明域名查询顺序，当要查询没有域名的主机，主机将在由search声明的域中分别查找。

注意：search和domain不能共存，如果同时存在，后面出现的将会被使用。

4）sortlist：运行将得到域名结果进行特定的排序。它的参数为网络/掩码对，允许任意的排列顺序。

"search domainname.com"表示当提供了一个不包含完全域名的主机名时，在该主机名后添加domainname.com的后缀；"nameserver"表示解析域名时使用该地址指定的主机为域名服务器。其中域名服务器是按照文件中出现的顺序来查询的。其中domain和search可以同时存在，也可以只有一个，nameserver可以指定多个

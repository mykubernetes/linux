Tengine结合ngx_lua_waf防御CC攻击
===

安装 tengine 与 luajit  
CC攻击即http flood，以攻击成本低（只需数台http代理服务器即可实现攻击）、隐蔽性强（中小CC攻击一般不会造成网络瓶颈）、难防御（与正常访问的请求很难区分开）、威力强大（造成和DDOS流量攻击一样的效果，网站长时间无法打开）等特点著称。常规的http flood防御为JS弹回，二次请求验证加入白名单 和 多层缓存（七层、四层共同缓存）实现防御体。  

CC攻击，首先造成的后果往往是被攻击服务器CPU爆满、内存占用高、甚至磁盘IO高占用。通常服务器上有永远处理不完的任务，所以，CC攻击，也是以拒绝服务为目的的攻击，属于DDOS攻击中的一种。  

适应Tengine结合ngx_lua_waf防御CC攻击  

tengine下载地址 http://tengine.taobao.org/   选择稳定的安装包下载编译安装即可。这里用的包是 tengine-2.1.1.tar.gz。  
luajit 下载地址 http://luajit.org/download.html  选择稳定的安装包下载编译安装即可。这里用的包是LuaJIT-2.0.4.tar.gz。  

安装的步骤如下：  
1、安装环境需要的基础文件  
```
# yum install zlib zlib-devel openssl openssl-devel pcre pcre-devel gcc -y
```  
2、下载和安装 LuaJIT-2.0.4.tar.gz  
```
# wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
# tar zxvf LuaJIT-2.0.4.tar.gz 
# cd LuaJIT-2.0.4
# make
# make install PREFIX=/usr/local/luajit
```  

3、下载和安装 tengine-2.1.1.tar.gz  
```
# wget http://tengine.taobao.org/download/tengine-2.1.1.tar.gz
# tar zxvf tengine-2.1.1.tar.gz
# cd tengine-2.1.1
# ./configure --prefix=/opt/nginx --with-http_lua_module --with-luajit-lib=/usr/local/luajit/lib/ --with-luajit-inc=/usr/local/luajit/include/luajit-2.0/ --with-ld-opt=-Wl,-rpath,/usr/local/luajit/lib
# make && make install
```  

下载和配置ngx_lua_waf  
nginx下常见的开源waf有mod_security、naxsi、ngx_lua_waf这三个，ngx_lua_waf 性能高和易用性强，基本上零配置，而且常见的攻击类型都能防御，是比较省心的选择。  
其git 地址为 https://github.com/loveshell/ngx_lua_waf  

1、下载配置文件  
```  
# wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip
```  

2、解压缩    
```
# unzip master.zip
```  

3、移动到nginx的目录下  
```
# mv ngx_lua_waf-master /opt/nginx/conf/
```  

4、重命名  
```
# cd /opt/nginx/conf/ 
# mv ngx_lua_waf-master  waf
```  

5、 修改 ngx_lua_waf 配置文件适应当前的 nginx 环境。修改以下文件的三行即可（修改/opt/nginx/conf/waf下的config.lua文件，将RulePath和logdir改为实际的目录：）
```
# cat /opt/nginx/conf/waf/config.lua|head -n3
RulePath = "/opt/nginx/conf/waf/wafconf/"
attacklog = "on"
logdir = "/opt/nginx/logs/waf"
```  

6、修改 tengine 的配置文件应用 ngx_lua_waf  
在 nginx.conf 的 http 段添加  
```
# vim /opt/nginx/conf/nginx.conf
lua_package_path "/opt/nginx/conf/waf/?.lua";
lua_shared_dict limit 10m;
init_by_lua_file  /opt/nginx/conf/waf/init.lua; 
access_by_lua_file /opt/nginx/conf/waf/waf.lua;
```  
 
7、启动 tengine–nginx 服务  
```  
# /opt/nginx/sbin/nginx  -t
the configuration file /opt/nginx/conf/nginx.conf syntax is ok
# /opt/nginx/sbin/nginx  -s reload
```  

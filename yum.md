搜索rpm包网站
https://pkgs.org/download/  

清华yum源  
https://mirrors.tuna.tsinghua.edu.cn/  

修改时间  
```
date +%F -d -1day  
```  

安装epel源  
```
yum install epel-release -y  
```  

基于命令查找安装包  
```
yum provides netstat  
```

reposync同步aliyunyum库到本地  
---
1、安装必要工具  
```
# yum install yum-utils createrepo plugin-priorities -y
```  
- yum-utils：reposync同步工具  
- createrepo：编辑yum库工具  
- plugin-priorities：控制yum源更新优先级工具，这个工具可以用来控制进行yum源检索的先后顺序，建议可以用在client端。  

2、安装nginx  
```
# vim /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key

# yum-config-manager --enable nginx-mainline
# yum install nginx -y
```  

3、配置nginx  
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    autoindex on;
    autoindex_exact_size on;
    autoindex_localtime on;
```  
- autoindex on: #表示自动在index.html的索引打开  
- autoindex_exact_size on: #表示如果有文件则显示文件大小  
- autoindex_localtime on: #表示显示文件修改时间，以当前系统时间为准  

4、下载阿里yum源,安装epel源  
```
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# yum install epel-release -y
```  

5、刷新缓存,列出安装文件数  
```
# yum clean all
# yum makecache
# yum repolist
```  

6、在nginx的html目录建立rpm库存放目录  
```
# mkdir -p /usr/share/nginx/html/aliyun/CentOS/7/64bit/{base,extras,updates}
```  

7、开始同步下载rpm包  
```  
# reposync -p /usr/share/nginx/html/aliyun/CentOS/7/64bit
```  

8、createrepo 命令用于创建yum源（软件仓库），即为存放于本地特定位置的众多rpm包建立索引，描述各包所需依赖信息，并形成元数据。    
```
cd /usr/share/nginx/html/Aliyun/CentOS/7/
cd base && createrepo -p ./ && cd -
cd extras && createrepo -p ./ && cd -
cd updates && createrepo -p ./ && cd -
```  

9、其他服务器连接YUM仓库  
```
# vim /etc/yum.repos.d/aliyun.repo
 
[base]
name=CentOS-Base(GDS)
baseurl=http://192.168.101.70/aliyun/CentOS/7/64bit/base
path=/
enabled=1
gpgcheck=0
 
[updates]
name=CentOS-Updates(GDS)
baseurl=http://192.168.101.70/aliyun/CentOS/7/64bit/updates
path=/
enabled=1
gpgcheck=0
 
[extras]
name=CentOS-Extras(GDS)
baseurl=http://192.168.101.70/aliyun/CentOS/7/64bit/extras
path=/
enabled=1
gpgcheck=0
```  

10、立定时同步，每周一的3点同步  
```
# crontab -e
0 3 * * 1 /usr/bin/reposync -np   /usr/share/nginx/html/aliyun/CentOS/7/64bit
```  

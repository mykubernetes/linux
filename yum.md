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
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
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
cd /usr/share/nginx/html/aliyun/CentOS/7/
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

11、如果添加或者删除了个人的rpm包，不需要再次重新create，只需要--update就可以了,写入周期性任务计划  
```
createrepo --update  ./
```  


本地不能连接外网方式
---

1、将CentOS-7.2-x86_64-DVD-1511.iso格式文件上传到服务器  

2、创建iso文件将要挂在的目录  
```
# mkdir -p /mnt/cdrom
```  

3、挂在iso文件到刚刚创建的目录中
```
mount -o loop CentOS-7.2-x86_64-DVD-1511.iso /omnt/cdrom
```  

4、创建repo文件 Local.repo，然后在其中加入下面内容  
```
# vim /etc/yum.repos.d/Local.repo
[Local] 
name=Local Yum 
baseurl=file:///mnt/cdrom
gpgcheck=0
enabled=1
```  

5、制作成网络yum源，方法同上  





使用http+createrepo搭建本地yum源仓库
---
```
1、安装所需软件包
# yum install httpd createrepo -y
2、创建目录并导入rpm包作为本地yum源
# mkdir -p /var/www/html/ceph/12.2.12
# cd /var/www/html/ceph/12.2.12
wget https://mirrors.aliyun.com/ceph/rpm-luminous/el7/x86_64/ceph-12.2.12-0.el7.x86_64.rpm
wget https://mirrors.aliyun.com/ceph/rpm-luminous/el7/x86_64/ceph-12.2.12-0.el7.x86_64.rpm


3、创建本地yum仓库
# createrepo /var/www/html/ceph/12.2.12
4、启动http服务
# systemctl start httpd
```  

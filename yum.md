# 一、yum管理rpm包

Yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及CentOS中的Shell前端软件包管理器。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。

```
client---->ftp:http:file----->yum地址----->yum仓库（rpm包集合）
配置一个yum仓库，就是配置一个源（地址）----->指向互联网上的仓库
```

配置文件
```
[root@localhost yum.repos.d]# vim /etc/yum.conf 
[main]
cachedir=/var/cache/yum/$basearch/$releasever  # 缓存目录
keepcache=0                                    # 0表示不缓存，1表示开启缓存
debuglevel=2                                   # 调试级别
logfile=/var/log/yum.log                       # 日志路径
exactarch=1                                    # 检查平台是否兼容
obsoletes=1                                    # 检查包是否废弃
gpgcheck=1                                     # 检查来源是否合法，需要有制作者的公钥信息
plugins=1
installonly_limit=5                            # 同时可以安装软件包个数为5 设为0或1表示不受限制
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=23&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpkg=centos-release

# metadata_expire=90m # 每小时自动检查元数据
```

# 仓库

存放了一个所有相关软件包的一个文件夹,能作为yum仓库必必须具备两点：
- 1.文件下涵盖所有的软件包
- 2.该文件夹下必须要有一个文件记录了本文件夹下所包含软件包的依赖关系。

```
常用选项说明：

#仓库        
yum repolist                            # 查询可用仓库
yum repolist all                        # 查看包括已启用或禁用的所有仓库状态

# 关闭与启用仓库：本质:都是在修改repo文件中的enable的值 0 不启用 1 启用
yum-config-manager --disable epel       #关闭仓库epel
yum-config-manager --enable epel        #启用仓库epel

#查看        
yum list                                #列出可用仓库中所有的软件包
yum list | less
yum grouplist                           #列出可用仓库中的软件组
yum list installed                      #查询已经安装的
yum provides /usr/sbin/ifconfig         #查询命令所属的软件包，可以不加路径，只写命令名字,与rpm -qf的区别在于可以查询未按装的命令，rpm -qf后面只能跟文件或命令的绝对路径
  
#安装        
yum install httpd httpd-tools           #加上-y选项可以变成非交互
yum groupinstall "开发工具" -y           #安装软件组，一个软件组中包含了多个软件包
yum groups install "开发工具" -y         #同上
yum localinstall                        #安装本的rpm包，会自动查找当前系统上已有的仓库解决依赖关系

#卸载        
yum remove httpd httpd-tools http*      #卸载软件包
yum groupremove "开发工具" -y.           #卸载软件组
yum groups remove "开发工具" -y          #同上

#重装        
yum reinstall httpd                      #不小心删除了配置文件的时,可以reinstall一下

#更新       
yum check-update                         # 检查可以更新的软件包
yum update -y                            #更新所有软件包,包括内核,通常只在刚装完系统时执行
yum update httpd -y                      #更新某个软件包

#缓存              
yum makecache                            #制作元数据缓存
yum clean all                            #清理元数据缓存
vim /etc/yum.conf                        #默认软件包下载安装后会自动删除,设置keepcache=1 即开启了软件包缓存,缓存目录为配置文件中指定的cachedir。

#历史记录
yum history                              # 查看执行过的yum命令历史记录
yum history info ID号                    # 查看具体某一条yum命令的详细信息
yum history undo ID号                    # 撤销执行过的历史命令

# 关于安装需要注意： 无论yum安装的软件来自何方，yum时刻以自己仓库中的repodata存储的依赖关系为准，如果有多个仓库，就依次检索
#1、yum直接安装公网的rpm包, 会自动查找当前系统上已有的仓库解决依赖关系 yum install https://mirrors.aliyun.com/centos/7.6.1810/os/x86_64/Packages/samba-4.8.3-4.el7.x86_64.rpm

#2、Yum直接安装本地的rpm包,会自动查找当前系统上已有的仓库解决依赖关系 yum localinstall -y /mnt/Packages/httpd-2.4.6-88.el7.centos.x86_64.rpm


要使用yum前,需要准备一个yum源(我们也称为yum仓库),
这个可以是一个互联网上的仓库,也可以是本地自己搭建的仓库.仓库里面有什么呢?里面全部都是.rpm的软件包.一台linux,可以添加N多个yum源,
能搜索的软件包数量就是N个yum源之和.

系统常见yum源

1.自定义的本地源
2.网络上的源头，如：base基础源、epel扩展源、与服务相关的源(官网)
wget -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo2

配置第三方 yum 源（EPEL）
wget -O /etc/yum.repos.d/epel.repo  http://mirrors.aliyun.com/repo/epel-7.repo
```

基于命令查找安装包  
```
yum provides netstat  
```

安装epel源  
```
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum install epel-release -y  
```

搜索rpm包网站 https://pkgs.org/download/  

# 二、reposync同步aliyun yum库到本地  

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


# 三、本地不能连接外网方式

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


# 四、使用http+createrepo搭建本地yum源仓库

1、安装所需软件包
```
# yum install httpd createrepo -y
```

2、创建目录并导入rpm包作为本地yum源
```
# mkdir -p /var/www/html/ceph/12.2.12
# cd /var/www/html/ceph/12.2.12
wget https://mirrors.aliyun.com/ceph/rpm-luminous/el7/x86_64/ceph-12.2.12-0.el7.x86_64.rpm
wget https://mirrors.aliyun.com/ceph/rpm-luminous/el7/x86_64/ceph-12.2.12-0.el7.x86_64.rpm
```

3、创建本地yum仓库
```
# createrepo /var/www/html/ceph/12.2.12
```

4、启动http服务
```
# systemctl start httpd
```  

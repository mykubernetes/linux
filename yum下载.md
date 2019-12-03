1、通过命令下载rpm包  
```
mkdir glusterfs
yum install --downloadonly --downloaddir=glusterfs/ glusterfs-server
```  

2、通过配置文件下载  
```
# vim /etc/yum.conf
[main]
cachedir=/var/cache/yum/$basearch/$releasever      #yum缓存的目录，yum在此存储下载的rpm包和数据库
keepcache=1                                        #是否保留缓存内容，0：表示安装后删除软件包，1表示安装后保留软件包


# ls /var/cache/yum/x86_64/7/centos-gluster6/packages/
glusterfs-6.3-1.el7.x86_64.rpm                 glusterfs-fuse-6.3-1.el7.x86_64.rpm
glusterfs-api-6.3-1.el7.x86_64.rpm             glusterfs-libs-6.3-1.el7.x86_64.rpm
glusterfs-cli-6.3-1.el7.x86_64.rpm             glusterfs-server-6.3-1.el7.x86_64.rpm
glusterfs-client-xlators-6.3-1.el7.x86_64.rpm  userspace-rcu-0.10.0-3.el7.x86_64.rpm
```  


部署vsftpd
---
```
1、安装vsftpd
yum install ‐y vsftpd ftp

2、设置开机启动
systemctl enable vsftpd

3、启动服务
systemctl start vsftpd

4、查看监听了 21 端口
netstat ‐nltp | grep 21

5、配置权限
vim /etc/vsftpd/vsftpd.conf
修改内容如下：
anonymous_enable=NO             # 禁用匿名用户
chroot_local_user=YES           # 禁止切换根目录
local_root=/data/ftp            # 设置FTP主目录 （该目录等会需要新建）
pasv_min_port=30000             # 配置FTP被动模式的端口
pasv_max_port=30500

6、创建ftp用户并分配权限
  1)创建用户
  useradd admin
  
  2)修改密码
  passwd admin

  3)限制该用户仅能通过 FTP 访问
  usermod -s /sbin/nologin admin
  
  4)为用户分配主目录
     # 创建目录:
     mkdir ‐p /data/ftp/home   # 对应配置文件目录

     # 设置访问权限：
     chmod a‐w /data/ftp && chmod 777 ‐R /data/ftp/home

     # 设置为用户的主目录： 即用户通过 FTP 登录后看到的根目录
     usermod ‐d /data/ftp admin
```


配置SELinux
```
1、查看SELinux中有关FTP的设置状态
getsebool ‐a | grep ftp
ftpd_full_access --> off       # 改为on


2、设置ftpd_full_access为开启状态
setsebool ‐P ftpd_full_access=on
```



配置防火墙
```
# 查询所有已开启端口
firewall‐cmd ‐‐list‐ports

# 开放ftp所需端口
firewall‐cmd ‐‐add‐port=21/tcp ‐‐permanent
firewall‐cmd ‐‐add‐port=20/tcp ‐‐permanent
firewall‐cmd ‐‐add‐port=30000‐30500/tcp ‐‐permanent

# 重新载入防火墙规则
firewall‐cmd ‐‐reload
```




vsftp 服务连接报530 login incorrect
---


```
# 1、创建一个不允许登录系统但可以登录FTP服务器的用户：
useradd -d /var/www -s /sbin/nologin sense

# 2、配置允许登录服务器的账号
vim /etc/vsftpd.conf 
可增加如下选项：
userlist_deny=NO
userlist_enable=YES
userlist_file=/etc/vsftpd_userlist       # 允许登录服务器的账号列表文件

# 3、添加允许登录的账号
vim /etc/vsftpd_userlist
sense

# 解决500 OOPS: vsftpd: refusing to run with writable root inside chroot() 错误
allow_writeable_chroot=YES
```

```
# cat /etc/vsftpd/vsftpd.conf
pam_service_name=vsftpd  # 可知认证pam文件位于/etc/pam.d/vsftpd

#方法1: 因为创建ftp账户时候，禁止了ssh登陆 所以此处应该改为 pam_nologin.so
# cat /etc/pam.d/vsftpd
auth required pam_shells.so
修改后
auth required pam_nologin.so


#方法2：注释掉/etc/pam.d/vsftpd文件里这后一行，不去鉴权
auth    required        pam_shells.so

#方法3：在/etc/shells文件里面增加一行,允许不能登录系统的用户通过鉴权
/sbin/nologin

# 重启,可以正常登陆
systemctl vsftpd.service restart
```



连接ftp
---
```
ftp 192.168.101.66
输入： user
输入： password
```



curl命令访问ftp
---
查看ftp
```
全写
curl --user user:123456 ftp://192.168.101.66

简写
curl -u user:123456 ftp://192.168.101.66

简写
curl ftp://user:123456@192.168.101.66
```

只列出目录，不显示进度条
```
curl ftp://192.168.101.66 –u name:passwd -s
```

下载ftp文件  
curl ftp://192.168.101.66/size.zip –u name:passwd -o size.zip
```
curl ftp://user:123456@192.168.101.66/test.c -o test.c

curl -u user:123456 ftp://192.168.101.66/list.h -o list.h
```

上载一个文件

curl –u name:passwd -T size.mp3 ftp://192.168.101.66/mp3/
```
curl -u user:123456 ftp://192.168.101.66/ -T list.h
```

从服务器上删除文件（使用curl传递ftp协议的DELE命令）
```
curl –u name:passwd ftp://192.168.101.66/ -X 'DELE mp3/size.mp3'
```

curl不支持递归下载，可以用数组方式下载文件，比下载1-10.gif连续命名的文件
```
curl –u name:passwd ftp://w192.168.101.66/img/[1-10].gif –O       # O字母大写
```

要连续下载多个文件
```
curl –u name:passwd ftp://192.168.101.66/img/[one,two,three].jpg –O      # O字母大写
```


FTP文件下载
---
- 说明1：其中 ftp1 用户是ftp服务端的账号，具体家目录是：/mnt/ftp1
- 说明2：当我们使用 curl 通过 FTP 进行下载时，后面跟的路径都是：当前使用的 ftp 账号家目录为基础的相对路径，然后找到的目标文件。

示例1
```
# 其中 tmp.data 的绝对路径是：/mnt/ftp1/tmpdata/tmp.data ；ftp1 账号的家目录是：/mnt/ftp1
# 说明：/tmpdata/tmp.data 这个路径是针对 ftp1 账号的家目录而言的
$ curl -O ftp://ftp1:123456@172.16.1.195:21/tmpdata/tmp.data  

# 或者
$ curl -O -u ftp1:123456 ftp://172.16.1.195:21/tmpdata/tmp.data
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2048M  100 2048M    0     0  39.5M      0  0:00:51  0:00:51 --:--:--  143M
```

示例2
```
# 其中 nginx-1.14.2.tar.gz 的绝对路径是：/tmp/nginx-1.14.2.tar.gz ；ftp1 账号的家目录是：/mnt/ftp1
# 说明：/../../tmp/nginx-1.14.2.tar.gz 这个路径是针对 ftp1 账号的家目录而言的
$ curl -O ftp://ftp1:123456@172.16.1.195:21/../../tmp/nginx-1.14.2.tar.gz  

# 或者
$ curl -O -u ftp1:123456 ftp://172.16.1.195:21/../../tmp/nginx-1.14.2.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  991k  100  991k    0     0  5910k      0 --:--:-- --:--:-- --:--:-- 5937k
```

FTP文件上传
---
可以通过 -T, --upload-file <file> 选项实现。

说明1：其中 ftp1 用户是ftp服务端的账号，具体家目录是：/mnt/ftp1
```
# 其中 tmp_client.data 是客户端本地文件； 
# /tmpdata/ 这个路径是针对 ftp1 账号的家目录而言的，且上传时该目录必须是存在的，否则上传失败。
# 因此上传后文件在ftp服务端的绝对路径是：/mnt/ftp1/tmpdata/tmp_client.data
$ curl -T tmp_client.data ftp://ftp1:123456@172.16.1.195:21/tmpdata/

# 或者
$ curl -T tmp_client.data -u ftp1:123456 ftp://172.16.1.195:21/tmpdata/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2048M    0     0  100 2048M      0  95.4M  0:00:21  0:00:21 --:--:-- 49.3M
```

断点续传
---
使用`-C, --continue-at <offset>`选项实现。其中使用 "-C -"「注意有空格和无空格的情况」，告诉curl自动找出在哪里/如何恢复传输。
```
# 网页端断点续传下载
curl -C - -o tmp.data http://www.zhangblog.com/uploads/tmp/tmp.data   # 下载一个 2G 的文件
```
  
FTP断点续传下载
---
```
curl -C - -o tmp.data1 ftp://ftp1:123456@172.16.1.195:21/tmpdata/tmp.data       # 下载一个 2G 的文件

# 或者
curl -C - -o tmp.data1 -u ftp1:123456 ftp://172.16.1.195:21/tmpdata/tmp.data    # 下载一个 2G 的文件
```



FTP分段下载
---

分段下载
```
curl -r 0-499   -o 00-jpg.part1 ftp://ftp1:123456@172.16.1.195:21/tmpdata/00.jpg
curl -r 500-999 -o 00-jpg.part2 ftp://ftp1:123456@172.16.1.195:21/tmpdata/00.jpg
curl -r 1000-   -o 00-jpg.part3 ftp://ftp1:123456@172.16.1.195:21/tmpdata/00.jpg
```

查看下载文件
```
ll 00-jpg.part*
-rw-rw-r-- 1 yun yun   500 Jul 15 17:59 00-jpg.part1
-rw-rw-r-- 1 yun yun   500 Jul 15 18:00 00-jpg.part2
-rw-rw-r-- 1 yun yun 17196 Jul 15 18:00 00-jpg.part3
```

文件合并
```
cat 00-jpg.part1 00-jpg.part2 00-jpg.part3 > 00.jpg

ll 00.jpg 
-rw-rw-r-- 1 yun yun 18196 Jul 15 18:02 00.jpg
```


https://blog.csdn.net/justry_deng/article/details/87969795


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

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
p输入： password
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

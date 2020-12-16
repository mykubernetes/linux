vsftp 服务连接报530 login incorrect
---

```
# cat /etc/vsftpd/vsftpd.conf
pam_service_name=vsftpd  # 可知认证pam文件位于/etc/pam.d/vsftpd

# cat /etc/pam.d/vsftpd
auth required pam_shells.so  # 因为创建ftp账户时候，禁止了ssh登陆 所以此处应该改为 pam_nologin.so
修改后
auth required pam_nologin.so

# 重启,可以正常登陆
systemctl vsftpd.service restart
```


curl命令访问ftp

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

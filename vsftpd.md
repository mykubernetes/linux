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

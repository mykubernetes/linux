

1、检查是否存在空密码的帐户  
``` # awk -F: '( $2 == "" ) { print $1 }' /etc/shadow ```  
为帐户设置满足密码复杂度的密码  
``` # passwd username ```  

2、检查除root之外的UID为0的用户  
``` # awk -F: '($3 == 0) { print $1 }' /etc/passwd ```  
删除除root外的UID为0的用户  
``` # userdel username ```  

3、设置口令策略满足复杂度要求  
```
# cp -p /etc/login.defs /etc/login.defs_bak
# vim /etc/login.defs

PASS_MAX_DAYS  99999    #密码的最大有效期，99999：永久有效 
PASS_MIN_DAYS  0        #是否可修改密码，0可修改，非0多少天后修改 
PASS_MIN_LEN   8        #密码最小长度，使用pam_cracklib module,该参数不再有效 
PASS_WARN_AGE  7        #密码失效前多少天通知用户修改密码
```  
其他策略解释
```
retry=N:重试多少次后返回修改密码 
difok=N:新密码必须与旧密码不同的位数 
dcredit=N: N>0密码中最多有多少位数字：N<0密码中最少有多少个数字 lcredit=N:小写字母的个数 
ucredit=N:大写字母的个数 
credit=N:特殊字母的个数 
minclass=N:密码组成（大/小字母，数字，特殊字符）
```


4、检查文件与目录缺省权限  
```
# vim /etc/profile
将umask值修改为027
```  

5、检查用户最小授权  
```
chmod 400 /etc/shadow
chmod 644 /etc/group
chmod 644 /etc/passwd
```  

6、检查root目录权限是否为700  
```
#chown root:root /root 
#chmod 700 /root
```  

7、查看字符交互界面超时退出  
```
1 执行备份：
# cp -p /etc/profile /etc/profile_bak
2 在/etc/profile文件增加以下两行：
# vim /etc/profile
TMOUT=300
export TMOUT
改变这项设置后，重新登录才能有效
```  

8、配置SYSLOG  
日志功能设置，记录系统日志及应用日志  
```
1、修改配置：
# vi /etc/rsyslog.conf
配置形如
*.err;kern.debug;daemon.notice;         /var/log/messages的语句，保存退出
*.err;kern.debug;daemon.notice;         /var/log/messages
cron.*                                  /var/log/cron
authpriv.*                              /var/log/secure 
2、重启syslog服务
# /etc/init.d/rsyslog stop
# /etc/init.d/rsyslog start
```  

9、设置日志服务器
设备配置远程日志功能，将需要重点关注的日志内容传输到日志服务器  
```
1、修改配置：
# vim /etc/rsyslog.conf
加上这一行：
 *.*   @192.168.0.1
可以将"*.*"替换为你实际需要的日志信息。比如：kern.* / mail.* 等等。192.168.0.1修改为实际的日志服务器。*.*和@之间为一个Tab。
2、重启syslog服务
# /etc/init.d/rsyslog stop
# /etc/init.d/rsyslog start
```  

10、远程登录取消telnet采用ssh  
```
关闭telent开启ssh：
1、备份
# cp -p /etc/xinetd.d/telnet /etc/xinetd.d/telnet_bak
2、编辑
# vi /etc/xinetd.d/telnet文件，把disable项改为yes,即disable = yes
然后运行
services xinetd restart
telnet就可以关闭掉了
3、安装ssh软件包，通过#/etc/init.d/sshd start来启动SSH。
```  

11、限制具备root权限的用户远程ssh登录  
```
# vim /etc/passwd
帐号信息的 shell 为/sbin/nologin 的为禁止远程登录
如要允许，则改成可以登录的 shell 即可，如/bin/bash
```  

```
# vim /etc/ssh/sshd_config
PermitRootLogin yes改为PermitRootLogin no
# systemctl restart sshd
```  

12、禁止任何人su到root，添加wheel组用户  
```
1、编辑su文件
# vim /etc/pam.d/su   在开头添加下面行：
auth required pam_wheel.so group=wheel
2、补充操作说明：
上述添加表明只有whell组的成员可以使用su命令成为root用户。可以把有需求的用户添加到whell组，以使它可以使用su命令成为root用户。
添加方法：
#usermod –G wheel username
```  

13、检查登录尝试失败后锁定用户帐户  
```
vim /etc/pam.d/system-auth 
auth        required      pam_tally2.so   deny=2  lock_time=300
```
解除用户锁定
```
# pam_tally2 -r -u test1 
Login           Failures Latest failure     From 
test1               1    04/21/20 22:37:54  pts/4
```

上面只是限制了用户从tty登录，而没有限制远程登录，修改sshd文件将实现对远程登陆的限制
```
# vi /etc/pam.d/sshd 增加：
auth required pam_tally2.so deny=6 unlock_time=300 even_deny_root root_unlock_time=30（添加在第一行）
```  

14、检查ssh端口  
```
# vim /etc/ssh/sshd_config   
Port 22                #修改成其他端口
# systemctl restart sshd
```  

15、删除潜在危险文件  
检查帐户目录中是否存在.netrc/.rhosts文件，该文件通常会被系统或进程自动加载并执行，对系统带来安全隐患
```
删除
.netrc/.rhosts文件
# rm -f filename
```  

16、禁止root登录FTP  
```
在ftpaccess文件中加入下列行  
root
```  

17、禁止匿名FTP  
```
# vim /etc/vsftd.conf文件，修改下列行为：  
anonymous_enable=NO
```  


18、禁止su非法提权，只允许root和wheel组用户su到root
```
# vim /et/pam.d/su auth
required        pam_wheel.so group=wheel  #新加一行 
或 
auth            required        pam_wheel.so use_uid     #取消注释
```

19、不响应ICMP请求
```
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```

20、设置shell登陆超时时间为10分钟
```
# vim /etc/profile
exportTMOUT=600

source /etc/profile
```

21、结束非法登录用户
```
# who
root     tty1         2020-04-23 17:33
root     pts/0        2020-04-23 17:35 (10.10.10.1)


# pkill -9 -t pts/0
```

22、配置firewalld防火墙仅开启
```
firewall-cmd —zone=public —add-port=22/tcp —permanent 
firewall-cmd —zone=public —add-port=443/tcp —permanent firewall-cmd —zone=public —add-port=80/tcp —permanent 
firewall-cmd —reload
```

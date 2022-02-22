```
#要认证的主机IP
IP="
192.168.10.182
"
#centos开启
#rpm -q sshpass &>/dev/null || yum -y install sshpass

#ubuntu开启
dpkg -L sshpass &>/dev/null || apt -y install sshpass
[ -f /root/.ssh/id_rsa ] || ssh-keygen -f /root/.ssh/id_rsa -P ''
#登录密码
export SSHPASS=123456
for HOST in $IP;do
     sshpass -e ssh-copy-id -o StrictHostKeyChecking=no $HOST
done
```

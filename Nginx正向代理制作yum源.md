# Nginx正向代理制作yum源

## 配置YUM源

- 阿里yum源
```
wget http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d
wget http://mirrors.aliyun.com/repo/epel-7.repo -O /etc/yum.repos.d
```

- 更新yum仓库
```
yum makecache fast
```

## 部署NGINX

- 配置DNS解析
```
vim /etc/resolv.conf 
# Generated by NetworkManager
nameserver 114.114.114.114
nameserver 8.8.8.8
```

- 配置nginx正向代理
```
yum install nginx -y
cat /etc/nginx/conf.d/package-proxy.conf
server {
	resolver 8.8.8.8;
	listen 10.183.20.67:3128; #根据需求改成相应IP
	location / {
		proxy_pass http://$http_host$request_uri;
	}
}


Nging –T 测试nginx配置
systemctl enable nginx；systemctl start nginx
```

## 配置防火墙

- Firewall配置富规则
```
firewall-cmd  --permanent --add-rich-rule="rule family="ipv4" source address="10.183.20.64/26" port protocol="tcp" port="3128" accept"

firewall-cmd –reload 
```
说明：permanent 策略永久生效

## 功能验证
```
yum repolist all --setopt=*.proxy=http://10.183.20.67:3128
yum install lrzsz --setopt=*.proxy=http://10.183.20.67:3128
```
说明：安装软件需加入参数 --setopt=*.proxy=http://10.183.20.67:3128

# Linux reporsync 制作本地源 yum源

## 制作本地源

### 1、安装工具
```
yum install yum-utils createrepo plugin-priorities nginx -y
```

### 2、配置nginx
```
vim /etc/nginx/nginx.conf
root /home/yum_repo;
location / {
root html;
index index.html index.htm;
}
autoindex on;
autoindex_exact_size on;
autoindex_localtime on;
service nginx restart
```

确认80端口可以使用
```
curl http://10.183.12.78/centos
如果出现 403 错误 
chmod -R 755 /home/yum_repo/
```

### 3、修改源为 aliyun 
```
mkdir /tmp/repo && mv /etc/yum.repos.d/* /tmp/repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/CentOS-epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all ; yum makecache ; yum repolist
```

### 4、配置nginx 发布路径
```
mkdir -p /home/yum_repo/centos/{base,extras,updates}
mkdir -p /home/yum_repo/epel
```

### 5、同步源

脚本如下
```
#base
reposync -n --repoid=base --repoid=extras --repoid=updates -p /home/yum_repo/centos
cd /home/yum_repo/centos/base && createrepo -p ./
cd /home/yum_repo/centos/extras && createrepo -p ./
cd /home/yum_repo/centos/updates && createrepo -p ./
#epel
reposync -n --repoid=epel -p /home/yum_repo/epel
cd /home/yum_repo/epel/epel && createrepo -p ./
nohup ./reposync.sh &
```

准备 group 信息

- centos
```
wget http://mirrors.aliyun.com/centos/7/os/x86_64/repodata/d87379a47bc2060f833000b9cef7f9670195fe197271d37fce5791e669265e8b-c7-x86_64-comps.xml -P /tmp
```

- epel
```
wget http://mirrors.aliyun.com/epel/7/x86_64/repodata/c629c8fc439517aed1ff09d9c8ba32f2fa6984a2f9683e4cd19726591f68128b-comps-Everything.x86_64.xml -P /tmp
createrepo -g /tmp/d8*.xml /home/yum_repo/centos/
createrepo -g /tmp/c6*.xml /home/yum_repo/epel/epel/
```

获取ali云上的源密钥
```
wget http://mirrors.aliyun.com/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -P /home/yum_repo/centos/
wget http://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-7 -P /home/yum_repo/epel/
```

### 6、定时更新

- update.sh 脚本内容如下
```
reposync -n --repoid=base --repoid=extras --repoid=updates -p /home/yum_repo/centos
reposync -n --repoid=epel -p /home/yum_repo/epel
createrepo --update /home/yum_repo/centos/base
createrepo --update /home/yum_repo/centos/updates
createrepo --update /home/yum_repo/centos/extras
createrepo --update /home/yum_repo/epel/epel
vim /etc/crontab
3 3 2 * * root 'bash /home/yum_repo/update.sh > /home/yum_repo/update.log'
```

7、客户端配置 10.183.12.78 为内网地址
```
[base]
name=CentOS-$releasever - Base - local
baseurl=http://10.183.12.78/centos/base
gpgcheck=1
gpgkey=http://10.183.12.78/centos/RPM-GPG-KEY-CentOS-7
#released updates
[updates]
name=CentOS-$releasever - Updates - local
baseurl=http://10.183.12.78/centos/updates
gpgcheck=1
gpgkey=http://10.183.12.78/centos/RPM-GPG-KEY-CentOS-7
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - local
baseurl=http://10.183.12.78/centos/extras
gpgcheck=1
gpgkey=http://10.183.12.78/centos/RPM-GPG-KEY-CentOS-7
[epel]
name=CentOS-$releasever - Epel - local
baseurl=http://10.183.12.78/epel/epel
gpgcheck=1
gpgkey=http://10.183.12.78/epel/RPM-GPG-KEY-EPEL-7
```

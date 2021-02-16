
在/usr/lib/systemd/system目录下包含了各种unit文件，有service后缀的服务unit，有target后缀的开机级别unit等。服务又分为系统服务（system）和用户服务（user）。

1.建立服务文件
```
vim /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
[Install]
WantedBy=multi-user.target
```
- Description:描述服务
- After:描述服务类别
- [Service]服务运行参数的设置
- Type=forking是后台运行的形式
- ExecStart为服务的具体运行命令
- ExecReload为重启命令
- ExecStop为停止命令
- PrivateTmp=True表示给服务分配独立的临时空间

注意：启动、重启、停止命令全部要求使用绝对路径

2.常用命令
```
systemctl start nginx.service           #启动nginx服务
systemctl enable nginx.service          #设置开机自启动
systemctl disable nginx.service         #停止开机自启动
systemctl status nginx.service          #查看服务当前状态
systemctl restart nginx.service         #重新启动服务
systemctl list-units --type=service     #查看所有已启动的服务
```

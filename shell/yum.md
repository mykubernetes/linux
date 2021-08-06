1、启动http
```
cat yum-repo.service
[Unit]
Description=TSF Yum Repo

[Service]
Type=simple
WorkingDirectory=/opt/yum-repo                        #工作目录
ExecStart=/usr/bin/python2 -m SimpleHTTPServer 8081
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target


cp -f yum-repo.service /usr/lib/systemd/system/
```

2、启动
```
systemctl daemon-reload
systemctl enable yum-repo
systemctl start yum-repo
systemctl status yum-repo
```

3、配置仓库
```
[web]
name=web
baseurl=http://172.16.0.224:8081/centos/$releasever/$basearch/
enabled=1
gpgcheck=0
```

4、本地目录配重yum源

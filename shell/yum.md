1、启动http
```
cat yum-repo.service
[Unit]
Description=TSF Yum Repo

[Service]
Type=simple
WorkingDirectory=/opt/tsf-yum-repo
ExecStart=/usr/bin/python2 -m SimpleHTTPServer 8081
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

2、启动
```
systemctl daemon-reload
systemctl enable yum-repo
```

3、配重仓库
```
[web]
name=web
baseurl=http://172.16.0.224:8081/centos/$releasever/$basearch/
enabled=1
gpgcheck=0
```

4、本地目录配重yum源

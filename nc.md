
1、文件传输：监听者为接收方
```
# nc -l 2233 > /tmp/fstab
# nc 192.168.101.66 2233 < /etc/fstab 
```


1、文件传输：监听者为传输方
```
# nc -l 2233 < /tmp/fstab
# nc 192.168.101.66 2233 > /tmp/fstab
```

3、作为web客户端访问web服务器
```
# nc 172.16.100.7 80
GET /index.html HTTP/1.1
Host: 172.16.100.7
连续回车
```

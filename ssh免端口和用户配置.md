ssh免端口和用户配置  
===
ssh如果不指定端口号和用户，则按默认配置连接  
```
文件默认不存在需要手动创建
# vim .ssh/config

Host hz
    HostName 122.224.151.00
    Port  8080
    User  user1
Host nj
    HostName 58.213.99.00
    Port  9091
    User  user2
```

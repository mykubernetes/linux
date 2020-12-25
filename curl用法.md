
-A参数指定客户端的用户代理标头
---
```
# 将User-Agent改成 Chrome 浏览器
curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36' https://google.com

# 移除User-Agent标头
curl -A '' https://google.com

# 通过-H参数直接指定标头，更改User-Agent
curl -H 'User-Agent: php/1.0' https://google.com
```

-b参数用来向服务器发送 Cookie
---
```
# 生成一个标头Cookie: foo=bar，向服务器发送一个名为foo、值为bar的 Cookie
curl -b 'foo=bar' https://google.com

# 发送两个 Cookie
curl -b 'foo1=bar;foo2=bar2' https://google.com

# 读取本地文件cookies.txt，里面是服务器设置的 Cookie
curl -b cookies.txt https://www.google.com
```

-c参数将服务器设置的 Cookie 写入一个文件
---
```
# 将服务器的 HTTP 回应所设置 Cookie 写入文本文件cookies.txt
curl -c cookies.txt https://www.google.com
```

-d参数用于发送 POST 请求的数据体
---
```
curl -d'login=emma＆password=123'-X POST https://google.com/login

curl -d 'login=emma' -d 'password=123' -X POST  https://google.com/login

# 读取本地文本文件的数据，向服务器发送
curl -d '@data.txt' https://google.com/login
```

--data-urlencode参数等同于-d，发送 POST 请求的数据体，区别在于会自动将发送的数据进行 URL 编码
---
```
# 发送的数据hello world之间有一个空格，需要进行 URL 编码
curl --data-urlencode 'comment=hello world' https://google.com/login
```

-e参数用来设置 HTTP 的标头Referer，表示请求的来源
---
```
# 将Referer标头设为https://google.com?q=example
curl -e 'https://google.com?q=example' https://www.example.com
```

-H参数可以通过直接添加标头Referer，达到同样效果
---
```
curl -H 'Referer: https://google.com?q=example' https://www.example.com
```


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

-F参数用来向服务器上传二进制文件
---
```
# 给 HTTP 请求加上标头Content-Type: multipart/form-data，然后将文件photo.png作为file字段上传
curl -F 'file=@photo.png' https://google.com/profile

# -F参数可以指定 MIME 类型
# 指定 MIME 类型为image/png，否则 curl 会把 MIME 类型设为application/octet-stream
curl -F 'file=@photo.png;type=image/png' https://google.com/profile

# -F参数也可以指定文件名
# 原始文件名为photo.png，但是服务器接收到的文件名为me.png
curl -F 'file=@photo.png;filename=me.png' https://google.com/profile
```

-G参数用来构造 URL 的查询字符串
---
```
# 发出一个 GET 请求，实际请求的 URL 为https://google.com/search?q=kitties&count=20。如果省略-G，会发出一个 POST 请求
curl -G -d 'q=kitties' -d 'count=20' https://google.com/search

# 如果数据需要 URL 编码，可以结合--data--urlencode参数
curl -G --data-urlencode 'comment=hello world' https://www.example.com
```

-H参数添加 HTTP 请求的标头
---
```
# 添加 HTTP 标头Accept-Language: en-US
curl -H 'Accept-Language: en-US' https://google.com

# 添加两个 HTTP 标头
curl -H 'Accept-Language: en-US' -H 'Secret-Message: xyzzy' https://google.com

添加 HTTP 请求的标头是Content-Type: application/json，然后用-d参数发送 JSON 数据
curl -d '{"login": "emma", "pass": "123"}' -H 'Content-Type: application/json' https://google.com/login
```

-i参数打印出服务器回应的 HTTP 标头
---
```
# 收到服务器回应后，先输出服务器回应的标头，然后空一行，再输出网页的源码
curl -i https://google.com
```

-I参数向服务器发出 HEAD 请求，然会将服务器返回的 HTTP 标头打印出来
---
```
# 输出服务器对 HEAD 请求的回应
curl -I https://google.com

# --head参数等同于-I
curl --head https://www.example.com
```

-k参数指定跳过 SSL 检测
---
```
# 不会检查服务器的 SSL 证书是否正确
curl -L -d 'tweet=hi' https://api.twitter.com/tweet
```

-L参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向
---
```
curl -L -d 'tweet=hi' https://api.twitter.com/tweet
```

--limit-rate用来限制 HTTP 请求和回应的带宽，模拟慢网速的环境
---
```
curl --limit-rate 200k https://google.com
```

-o参数将服务器的回应保存成文件，等同于wget命令
---
```
curl -o example.html https://www.example.com
```

-O参数将服务器回应保存成文件，并将 URL 的最后部分当作文件名
---
```
# 将服务器回应保存成文件，文件名为bar.html
curl -O https://www.example.com/foo/bar.html
```

-s参数将不输出错误和进度信息
---
```
# 一旦发生错误，不会显示错误信息。不发生错误的话，会正常显示运行结果
curl -s https://www.example.com

# 如果想让 curl 不产生任何输出，可以使用下面的命令
curl -s -o /dev/null https://google.com
```

-u参数用来设置服务器认证的用户名和密码
---
```
# 上面命令设置用户名为bob，密码为12345，然后将其转为 HTTP 标头Authorization: Basic Ym9iOjEyMzQ1
curl -u 'bob:12345' https://google.com/login

# curl 能够识别 URL 里面的用户名和密码
curl https://bob:12345@google.com/login

# 命令只设置了用户名，执行后，curl 会提示用户输入密码
curl -u 'bob' https://google.com/login
```

-v参数输出通信的整个过程，用于调试
---
```
curl -v https://www.example.com

# --trace参数也可以用于调试，还会输出原始的二进制数据
curl --trace - https://www.example.com
```

-x参数指定 HTTP 请求的代理
---
```
# 指定 HTTP 请求通过myproxy.com:8080的 socks5 代理发出,如果没有指定代理协议，默认为 HTTP
curl -x socks5://james:cats@myproxy.com:8080 https://www.example.com

# 请求的代理使用 HTTP 协议
curl -x james:cats@myproxy.com:8080 https://www.example.com
```

-X参数指定 HTTP 请求的方法
---
```
# 对https://www.example.com发出 POST 请求
curl -X POST https://www.example.com
```

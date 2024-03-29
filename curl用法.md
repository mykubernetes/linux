# curl参数说明
```
-A/--user-agent <string>             设置用户代理发送给服务器
-b/--cookie <name=string/file>       cookie字符串或文件读取位置
-c/--cookie-jar <file>               操作结束后把cookie写入到这个文件中
-C/--continue-at <offset>            断点续转
-D/--dump-header <file>              把header信息写入到该文件中
-e/--referer                         来源网址
-f/--fail                            连接失败时不显示http错误
-o/--output                          把输出写到该文件中
-O/--remote-name                     把输出写到该文件中，保留远程文件的文件名
-r/--range <range>                   检索来自HTTP/1.1或FTP服务器字节范围
-s/--silent                          静音模式。不输出任何东西
-T/--upload-file <file>              上传文件
-u/--user <user[:password]>          设置服务器的用户和密码
-w/--write-out [format]              什么输出完成后
-x/--proxy <host[:port]>             在给定的端口上使用HTTP代理
-#/--progress-bar                    进度条显示当前的传送状态

-a/--append                          上传文件时，附加到目标文件
--anyauth                            可以使用“任何”身份验证方法
--basic                              使用HTTP基本验证
-B/--use-ascii                       使用ASCII文本传输
-d/--data <data>                     HTTP POST方式传送数据
--data-ascii <data>                  以ascii的方式post数据
--data-binary <data>                 以二进制的方式post数据
--negotiate                          使用HTTP身份验证
--digest                             使用数字身份验证
--disable-eprt                       禁止使用EPRT或LPRT
--disable-epsv                       禁止使用EPSV
--egd-file <file>                    为随机数据(SSL)设置EGD socket路径
--tcp-nodelay                        使用TCP_NODELAY选项
-E/--cert <cert[:passwd]>            客户端证书文件和密码 (SSL)
--cert-type <type>                   证书文件类型 (DER/PEM/ENG) (SSL)
--key <key>                          私钥文件名 (SSL)
--key-type <type>                    私钥文件类型 (DER/PEM/ENG) (SSL)
--pass  <pass>                       私钥密码 (SSL)
--engine <eng>                       加密引擎使用 (SSL). "--engine list" for list
--cacert <file>                      CA证书 (SSL)
--capath <directory>                 CA目   (made using c_rehash) to verify peer against (SSL)
--ciphers <list>                     SSL密码
--compressed                         要求返回是压缩的形势 (using deflate or gzip)
--connect-timeout <seconds>          设置最大请求时间
--create-dirs                        建立本地目录的目录层次结构
--crlf                               上传是把LF转变成CRLF
--ftp-create-dirs                    如果远程目录不存在，创建远程目录
--ftp-method [multicwd/nocwd/singlecwd]    控制CWD的使用
--ftp-pasv                           使用 PASV/EPSV 代替端口
--ftp-skip-pasv-ip                   使用PASV的时候,忽略该IP地址
--ftp-ssl                            尝试用 SSL/TLS 来进行ftp数据传输
--ftp-ssl-reqd                       要求用 SSL/TLS 来进行ftp数据传输
-F/--form <name=content>             模拟http表单提交数据
-form-string <name=string>           模拟http表单提交数据
-g/--globoff                         禁用网址序列和范围使用{}和[]
-G/--get                             以get的方式来发送数据
-h/--help                            帮助
-H/--header <line>                   自定义头信息传递给服务器
--ignore-content-length              忽略的HTTP头信息的长度
-i/--include                         输出时包括protocol头信息
-I/--head                            只显示文档信息
-j/--junk-session-cookies            读取文件时忽略session cookie
--interface <interface>              使用指定网络接口/地址
--krb4 <level>                       使用指定安全级别的krb4
-k/--insecure                        允许不使用证书到SSL站点
-K/--config                          指定的配置文件读取
-l/--list-only                       列出ftp目录下的文件名称
--limit-rate <rate>                  设置传输速度
--local-port<NUM>                    强制使用本地端口号
-m/--max-time <seconds>              设置最大传输时间
--max-redirs <num>                   设置最大读取的目录数
--max-filesize <bytes>               设置最大下载的文件总量
-M/--manual                          显示全手动
-n/--netrc                           从netrc文件中读取用户名和密码
--netrc-optional                     使用 .netrc 或者 URL来覆盖-n
--ntlm                               使用 HTTP NTLM 身份验证
-N/--no-buffer                       禁用缓冲输出
-p/--proxytunnel                     使用HTTP代理
--proxy-anyauth                      选择任一代理身份验证方法
--proxy-basic                        在代理上使用基本身份验证
--proxy-digest                       在代理上使用数字身份验证
--proxy-ntlm                         在代理上使用ntlm身份验证
-P/--ftp-port <address>              使用端口地址，而不是使用PASV
-Q/--quote <cmd>                     文件传输前，发送命令到服务器
--range-file                         读取（SSL）的随机文件
-R/--remote-time                     在本地生成文件时，保留远程文件时间
--retry <num>                        传输出现问题时，重试的次数
--retry-delay <seconds>              传输出现问题时，设置重试间隔时间
--retry-max-time <seconds>           传输出现问题时，设置最大重试时间
-S/--show-error                      显示错误
--socks4 <host[:port]>               用socks4代理给定主机和端口
--socks5 <host[:port]>               用socks5代理给定主机和端口
-t/--telnet-option <OPT=val>         Telnet选项设置
--trace <file>                       对指定文件进行debug
--trace-ascii <file>                 Like --跟踪但没有hex输出
--trace-time                         跟踪/详细输出时，添加时间戳
--url <URL>                          Spet URL to work with
-U/--proxy-user <user[:password]>    设置代理用户名和密码
-V/--version                         显示版本信息
-X/--request <command>               指定什么命令
-y/--speed-time                      放弃限速所要的时间。默认为30
-Y/--speed-limit                     停止传输速度的限制，速度时间'秒
-z/--time-cond                       传送时间设置
-0/--http1.0                         使用HTTP 1.0
-1/--tlsv1                           使用TLSv1（SSL）
-2/--sslv2                           使用SSLv2的（SSL）
-3/--sslv3                           使用的SSLv3（SSL）
--3p-quote                           like -Q for the source URL for 3rd party transfer
--3p-url                             使用url，进行第三方传送
--3p-user                            使用用户名和密码，进行第三方传送
-4/--ipv4                            使用IP4
-6/--ipv6                            使用IP6
```

# 常见网页访问示例

基本用法

1、访问一个网页
```
curl https://www.baidu.com
```

2、进度条展示,有时候我们不需要进度表展示，而需要进度条展示。比如：下载文件时。
- -#, --progress-bar
```
# curl https://www.baidu.com | head -n1              # 进度表显示
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2443  100  2443    0     0  11662      0 --:--:-- --:--:-- --:--:-- 11688
<!DOCTYPE html>


# curl -# https://www.baidu.com | head -n1           # 进度条显示
######################################################################## 100.0%
<!DOCTYPE html>
```

3、静默模式与错误信息打印

3.1静默模式示例
- -s, --silent 静默模式去掉这些不必要的信息。
```
[root@iZ28xbsfvc4Z ~]# curl https://www.baidu.com | head -n1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2443  100  2443    0     0  11874      0 --:--:-- --:--:-- --:--:-- 11859
<!DOCTYPE html>
[root@iZ28xbsfvc4Z ~]# curl -s https://www.baidu.com | head -n1
<!DOCTYPE html>
```

3.2静默模式结合错误信息打印
- -s, --silent 时，还需要打印错误信息，那么还需要使用 -S, --show-error 选项。
```
# curl -s https://140.205.16.113/ 

# curl -sS https://140.205.16.113/ 
curl: (51) Unable to communicate securely with peer: requested domain name does not match the server's certificate.
```

4、显示详细操作信息
- -v, --verbose
- 以 > 开头的行表示curl发送的”header data”
- 以 < 开头的行表示curl接收到的通常情况下隐藏的”header data”
- 以 * 开头的行表示curl提供的附加信息

```
# curl -v https://www.baidu.com
* About to connect() to www.baidu.com port 443 (#0)
*   Trying 180.101.49.12...
* Connected to www.baidu.com (180.101.49.12) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* SSL connection using TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
* Server certificate:
* 	subject: CN=baidu.com,O="Beijing Baidu Netcom Science Technology Co., Ltd",OU=service operation department,L=beijing,ST=beijing,C=CN
* 	start date: May 09 01:22:02 2019 GMT
* 	expire date: Jun 25 05:31:02 2020 GMT
* 	common name: baidu.com
* 	issuer: CN=GlobalSign Organization Validation CA - SHA256 - G2,O=GlobalSign nv-sa,C=BE
> GET / HTTP/1.1
> User-Agent: curl/7.29.0
> Host: www.baidu.com
> Accept: */*
> 
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: private, no-cache, no-store, proxy-revalidate, no-transform
< Connection: Keep-Alive
< Content-Length: 2443
< Content-Type: text/html
< Date: Fri, 12 Jul 2019 08:26:23 GMT
< Etag: "588603eb-98b"
< Last-Modified: Mon, 23 Jan 2017 13:23:55 GMT
< Pragma: no-cache
< Server: bfe/1.0.8.18
< Set-Cookie: BDORZ=27315; max-age=86400; domain=.baidu.com; path=/
< 
<!DOCTYPE html>
………………                   # curl 网页的具体信息
```

5、指定访问的请求方法
- curl默认使用GET方式访问。使用了 -d, --data <data> 选项，那么会默认为POST方法访问。如果此时还想实现 GET 访问，那么可以使用 -G, --get 选项强制curl 使用GET方法访问。同时 -X, --request <command> 选项也可以指定访问方法。

POST请求和数据传输
```
# curl -sv -X POST -d 'user=zhang&pwd=123456' http://www.zhangblog.com/2019/06/24/domainexpire/ | head -n1

## 或者
# curl -sv -d 'user=zhang&pwd=123456' http://www.zhangblog.com/2019/06/24/domainexpire/ | head -n1
* About to connect() to www.zhangblog.com port 80 (#0)
*   Trying 120.27.48.179...
* Connected to www.zhangblog.com (120.27.48.179) port 80 (#0)
> POST /2019/06/24/domainexpire/ HTTP/1.1  # POST 请求方法
> User-Agent: curl/7.29.0
> Host: www.zhangblog.com
> Accept: */*
> Content-Length: 21
> Content-Type: application/x-www-form-urlencoded
> 
} [data not shown]
* upload completely sent off: 21 out of 21 bytes
< HTTP/1.1 405 Not Allowed
< Server: nginx/1.14.2
< Date: Thu, 18 Jul 2019 07:56:23 GMT
< Content-Type: text/html
< Content-Length: 173
< Connection: keep-alive
< 
{ [data not shown]
* Connection #0 to host www.zhangblog.com left intact
<html>
```

指定请求方法
```
curl -vs -X POST https://www.baidu.com | head -n1
curl -vs -X PUT https://www.baidu.com | head -n1
```

6、保存访问网页
6.1使用linux的重定向功能保存
```
curl www.baidu.com >> baidu.html
```

6.2使用curl的大O选项
- -O, --remote-name 选项实现。
```
# curl -O https://www.baidu.com   # 使用了 -O 选项，必须指定到具体的文件  错误使用
curl: Remote file name has no length!
curl: try 'curl --help' or 'curl --manual' for more information

# curl -O https://www.baidu.com/index.html   # 使用了 -O 选项，必须指定到具体的文件  正确使用
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2443  100  2443    0     0  13289      0 --:--:-- --:--:-- --:--:-- 13349
```

6.3使用curl的小o选项
- `-o, --output <file>` 选项实现。
```
# curl -o sina.txt https://www.sina.com.cn/   # 单个操作
# ll
-rw-r--r-- 1 root root   154 Jul 13 21:06 sina.txt

# curl "http://www.{baidu,douban}.com" -o "site_#1.txt"  # 批量操作，注意curl 的地址需要用引号括起来
[1/2]: http://www.baidu.com --> site_baidu.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2381  100  2381    0     0  46045      0 --:--:-- --:--:-- --:--:-- 46686

[2/2]: http://www.douban.com --> site_douban.txt
100   162  100   162    0     0   3173      0 --:--:-- --:--:-- --:--:--  3173

# ll
total 220
-rw-r--r-- 1 root root  2381 Jul  4 16:53 site_baidu.txt
-rw-r--r-- 1 root root   162 Jul  4 16:53 site_douban.txt
```

7、允许不安全访问
- 使用curl进行https访问访问时，如果SSL证书是我们自签发的证书，那么这个时候需要使用 -k, --insecure 选项，允许不安全的访问。
```
# curl https://140.205.16.113/  # 被拒绝
curl: (51) Unable to communicate securely with peer: requested domain name does not match the server's certificate.

# curl -k https://140.205.16.113/                 # 允许执行不安全的证书连接
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head><title>403 Forbidden</title></head>
<body bgcolor="white">
<h1>403 Forbidden</h1>
<p>You don't have permission to access the URL on this server.<hr/>Powered by Tengine</body>
</html>
```

8、获取HTTP响应状态码
- 在脚本中，这是很常见的测试网站是否正常的用法。`-w, --write-out <format>`
```
# curl -o /dev/null -s -w %{http_code} https://baidu.com
302

# curl -o /dev/null -s -w %{http_code} https://www.baidu.com
200
```
  
9、指定proxy服务器以及其端口
- 很多时候上网需要用到代理服务器(比如是使用代理服务器上网或者因为使用curl别人网站而被别人屏蔽IP地址的时候)，幸运的是curl通过使用 -x, --proxy <[protocol://][user:password@]proxyhost[:port]> 选项来支持设置代理。

```
curl -x 192.168.100.100:1080 https://www.baidu.com
```

10、模仿浏览器访问
- 有些网站需要使用特定的浏览器去访问他们，有些还需要使用某些特定的浏览器版本。可以通过`-A, --user-agent <agent string>`或者`-H, --header <header>`选项实现模拟浏览器访问。
```
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/75.0.3770.999" http://www.zhangblog.com/2019/06/24/domainexpire/ 
或者
curl -H 'User-Agent: Mozilla/5.0' http://www.zhangblog.com/2019/06/24/domainexpire/
```

11、伪造referer（盗链）

有些网站的网页对http访问的链接来源做了访问限制，这些限制几乎都是通过referer来实现的。

比如：要求是先访问首页，然后再访问首页中的邮箱页面，这时访问邮箱的referer地址就是访问首页成功后的页面地址。如果服务器发现对邮箱页面访问的referer地址不是首页的地址，就断定那是个盗连了。

可以通过`-e, --referer`或者`-H, --header <header>`实现伪造 referer 。
```
curl -e 'https://www.baidu.com' http://www.zhangblog.com/2019/06/24/domainexpire/
或者
curl -H 'Referer: https://www.baidu.com' http://www.zhangblog.com/2019/06/24/domainexpire/
```

12、构造HTTP请求头
- `-H, --header <header>`实现构造http请求头。

```
curl -H 'Connection: keep-alive' -H 'Referer: https://sina.com.cn' -H 'User-Agent: Mozilla/1.0' http://www.zhangblog.com/2019/06/24/domainexpire/
```

13、保存响应头信息
- `-D, --dump-header <file>`选项实现。

```
# curl -D baidu_header.info www.baidu.com 
………………

# ll
total 4
-rw-r--r-- 1 root root 400 Jul  3 10:11 baidu_header.info           # 生成的头文件
```

14、限时访问

- `--connect-timeout <seconds>` 连接服务端的超时时间。这只限制了连接阶段，一旦curl连接了此选项就不再使用了。
```
# 当前 https://www.zhangXX.com 是国外服务器，访问受限
# curl --connect-timeout 10 https://www.zhangXX.com | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10001 milliseconds
```

- `-m, --max-time <seconds> `允许整个操作花费的最大时间(以秒为单位)。这对于防止由于网络或链接变慢而导致批处理作业挂起数小时非常有用。
```
# curl -m 10 --limit-rate 5 http://www.baidu.com/ | head            # 超过10秒后，断开连接
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  2  2381    2    50    0     0      4      0  0:09:55  0:00:10  0:09:45     4
curl: (28) Operation timed out after 10103 milliseconds with 50 out of 2381 bytes received
<!DOCTYPE html>
<!--STATUS OK--><html> <head><met

### 或
# curl -m 10 https://www.zhangXX.com | head                         # 超过10秒后，断开连接
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10001 milliseconds
```
                                  
15、显示抓取错误

当我们请求访问失败时或者没有该网页时，网站一般都会给出一个错误的提示页面。

如果我们不需要这个错误页面，只想得到简洁的错误信息。那么可以通过 -f, --fail 选项实现。
```
# curl http://www.zhangblog.com/201912312
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.14.2</center>
</body>
</html>

# curl -f http://www.zhangblog.com/201912312               # 得到更简洁的错误信息
curl: (22) The requested URL returned error: 404 Not Found
```

16、网页文件下载
```
# 以进度条展示，而不是进度表展示
# curl -# -o tmp.data2 http://www.zhangblog.com/uploads/tmp/tmp.data
######################################################################## 100.0%
```

17、分段下载

有时文件比较大，或者难以迅速传输，而利用分段传输，可以实现稳定、高效并且有保障的传输，更具有实用性，同时容易对差错文件进行更正。

- `-r, --range <range>`

如下示例使用了同一张图片，大小为 18196 字节。

17.1分段下载
```
# curl -I http://www.zhangblog.com/uploads/hexo/00.jpg   # 查看文件大小
HTTP/1.1 200 OK
Server: nginx/1.14.2
Date: Mon, 15 Jul 2019 03:23:44 GMT
Content-Type: image/jpeg
Content-Length: 18196                        # 文件大小
Last-Modified: Fri, 05 Jul 2019 08:04:58 GMT
Connection: keep-alive
ETag: "5d1f04aa-4714"
Accept-Ranges: bytes

### 分段下载一个文件
# curl -r 0-499   -o 00-jpg.part1 http://www.zhangblog.com/uploads/hexo/00.jpg
# curl -r 500-999 -o 00-jpg.part2 http://www.zhangblog.com/uploads/hexo/00.jpg
# curl -r 1000-   -o 00-jpg.part3 http://www.zhangblog.com/uploads/hexo/00.jpg
```

17.2查看下载文件
```
# ll
total 36
-rw-r--r-- 1 root root   500 Jul 15 11:25 00-jpg.part1
-rw-r--r-- 1 root root   500 Jul 15 11:25 00-jpg.part2
-rw-r--r-- 1 root root 17196 Jul 15 11:26 00-jpg.part3
```

17.3文件合并
```
# cat 00-jpg.part1 00-jpg.part2 00-jpg.part3 > 00.jpg

# ll 00.jpg
total 56
-rw-r--r-- 1 root root 18196 Jul 15 11:29 00.jpg
```


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

# 带token
```
curl -X PUT -H 'X-Access-Token:{{你的token}}' ttps://www.example.com
```

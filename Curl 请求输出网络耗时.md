
curl 请求页面时打印请求过程中的耗时，方便识别网络过程中存在问题。
生成打印字段配置文件：
```
# cat >./curl-format.txt  <<-EOF
   time_namelookup: %{time_namelookup}\n
      time_connect: %{time_connect}\n
   time_appconnect: %{time_appconnect}\n
     time_redirect: %{time_redirect}\n
  time_pretransfer: %{time_pretransfer}\n
time_starttransfer: %{time_starttransfer}\n
                    ----------\n
time_total: %{time_total}\n
EOF
```
- time_namelookup： DNS解析时间
- time_connect：TCP 连接建立的时间，就是三次握手的时间 ,计算方式：time_connect - time_namelookup 
- time_appconnect：SSL/SSH 等上层协议建立连接的时间，比如 connect/handshake 的时间
- time_redirect： 从开始到最后一个请求事务的时间
- time_pretransfer：从请求开始到响应开始传输的时间
- time_starttransfer： 从请求开始到第一个字节将要传输的时间
- time_total：这次请求花费的全部时间



示例：
```
# curl -w "@curl-format.txt" -o /dev/null -s -L "https://www.baidu.com"
   time_namelookup:  0.529108
      time_connect:  0.688685
   time_appconnect:  1.201098
     time_redirect:  0.000000
  time_pretransfer:  1.201304
time_starttransfer:  1.418342
                    ----------
time_total:  1.540865

# 循环多次执行
for i in $(seq 1000);do curl -w "@curl-format.txt" -o /dev/null -s -L "https://www.baidu.com";echo ------$i---------;sleep 1;done
```

计算公式
```
DNS查询时间：0529108
TCP连接时间： time_connect - time_namelookup = 0.688685 - 0.529108 = 159ms
服务器处理时间：time_starttransfer - time_pretransfer = 1.418342 - 1.201304 = 217ms
内容传输时间：time_total - time_starttransfer = 1.540865 - 1.418342 = 122ms
```

命令行直接运行
```
curl -w "%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}" -o /dev/null -s -L "https://www.baidu.com"  

输出信息如下：
0.028
0.033
0.057
0.450
0.677


#循环执行
for i in $(seq 1000);do curl -w "%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}" -o /dev/null -s -L "https://www.baidu.com";echo ------$i---------;sleep 1;done
```

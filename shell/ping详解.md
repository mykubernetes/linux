- -q 不显示任何传送封包的信息，只显示最后的结果
- -n 只输出数值
- -R 记录路由过程
- -c count 总次数
- -i 时间间隔
- -t 存活数值：设置存活数值TTL的大小
- -w ping次数
- -s 设置发送包的大小

```
#!/bin/bash

for i in {1..254}
do
  ping -c1 -i 1 -w 1 192.168.1.$i >/dev/null 2>&1
  if [ $? = 0 ];then
    echo "10.200.12.$i up"
  else
    echo "10.200.12.$i down"
  fi
done
```

```
#!/bin/bash
. /etc/init.d/functions
for var in {1..254};
do
  ip=192.168.1.$var
  ping -c2 -i 0.5 -w 1 $ip >/dev/null 2>&1
    if [ $? = 0 ];then
      action "$ip" /bin/true
    else
      action "$ip" /bin/false
    fi
done
```

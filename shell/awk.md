https://mp.weixin.qq.com/s?__biz=MzAwNTM5Njk3Mw==&mid=2247486759&idx=1&sn=72fc2dfe7422f7e9caa6b583173f27d5&chksm=9b1c0da5ac6b84b356ac960bc12a75c8c4d8cadcec6cc40c0d9008d3783b93e4f53c6db4105a&mpshare=1&scene=23&srcid=#rd


内置变量
```
$0   #当前记录
$1~$n #当前记录的第N个字段
FS   #输入字段分隔符（-F相同作用）默认空格
RS   #输入记录分割符，默认换行符
NF   #字段个数就是列 
NR   #记录数，就是行号，默认从1开始
OFS  #输出字段分隔符，默认空格
ORS  #输出记录分割符，默认换行符 
```

外部变量
```
# a=100
# b=100
# echo |awk '{print v1*v2 }' v1=$a v2=$b
10000
```

算术运算符
```
+ - 加减
* / & 乘 除 求余
^ *  求幂
++ -- 增加或减少，作为前缀或后缀

# awk 'BEGIN{a="b";print a,a++,a--,++a;}'
b 0 1 1

# awk 'BEGIN{a="0";print a,a++,a--,++a;}'
0 0 1 1

# awk 'BEGIN{a="0";print a,a++,--a,++a;}'
0 0 0 1

#和其它编程语言一样，所有用作算术运算符进行操作，操作数自动转为数值，所有非数值都变为0
```

赋值运算符
```
= += -= *= /= %= ^= **=
```

正则运算符
```
~ !~  匹配正则表达式/不匹配正则表达式
```

逻辑运算符
```
||  &&  逻辑或  逻辑与
```

关系运算符
```
< <= > >= != = 
```

其它运算符
```
$   字段引用 
空格 字符串链接符
?:   三目运算符
ln   数组中是否存在某键值
```

Awk正则
```
^    行首定位符
$    行尾定位符
.    匹配任意单个字符
*    匹配0个或多个前导字符（包括回车）
+    匹配1个或多个前导字符
?    匹配0个或1个前导字符 
[]   匹配指定字符组内的任意一个字符/^[ab]
[^]  匹配不在指定字符组内的任意一个字符
()   子表达式
|    或者
\    转义符
~,!~ 匹配或不匹配的条件语句
x{m} x字符重复m次
x{m,} x字符至少重复m次
X{m,n} x字符至少重复m次但不起过n次（需指定参数-posix或--re-interval）
```


统计访问IP次数：
```
# awk '{a[$1]++}END{for(v in a)print v,a[v]}' access.log
```
统计访问访问大于100次的IP：
```
# awk '{a[$1]++}END{for(v ina){if(a[v]>100)print v,a[v]}}' access.log
```
统计访问IP次数并排序取前10：
```
# awk '{a[$1]++}END{for(v in a)print v,a[v]|"sort -k2 -nr |head -10"}' access.log
```
统计时间段访问最多的IP：
```
# awk'$4>="[02/Jan/2017:00:02:00" &&$4<="[02/Jan/2017:00:03:00"{a[$1]++}END{for(v in a)print v,a[v]}'access.log
```
统计上一分钟访问量：
```
# date=$(date -d '-1 minute'+%d/%d/%Y:%H:%M)
# awk -vdate=$date '$4~date{c++}END{printc}' access.log
```
统计访问最多的10个页面：
```
# awk '{a[$7]++}END{for(vin a)print v,a[v]|"sort -k1 -nr|head -n10"}' access.log
```
统计每个URL数量和返回内容总大小：
```
# awk '{a[$7]++;size[$7]+=$10}END{for(v ina)print a[v],v,size[v]}' access.log
```
统计每个IP访问状态码数量：
```
# awk '{a[$1" "$9]++}END{for(v ina)print v,a[v]}' access.log
```
统计访问IP是404状态次数：
```
# awk '{if($9~/404/)a[$1" "$9]++}END{for(i in a)print v,a[v]}' access.log
```

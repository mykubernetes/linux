# 1.Awk基础介绍

## 1.什么是awk
- awk不仅仅是一个文本处理工具，通常用于处理数据并生成结果报告。当然awk也是一门编程语言，是linux上功能最强大的数据处理工具之一。

## 2.awk语法格式
```
第一种形式：
awk 'BEGIN{} pattern {commands} END {}' file_name

第二种形式：
standard output | awk BEGIN{} pattern {commands} END {}

第三种形式：
awk [options] -f awk-script-file filenames
```

| 语法格式 | 含义 |
|---------|-----|
| BEGIN {} | 正式处理数据之前执行 |
| pattern	| 匹配模式 |
| {commands} | 处理命令，可能多行 |
| END{}	| 处理完所有匹配数据后执行 |

## 2.Awk工作原理

`# awk -F: '{print $1,$3}' /etc/passwd`
- 1.awk将文件中的每一行作为输入, 并将每一行赋给内部变量$0, 以换行符结束
- 2.awk开始进行字段分解，每个字段存储在已编号的变量中，从$1开始[默认空格分割]
- 3.awk默认字段分隔符是由内部FS变量来确定, 可以使用-F修订
- 4.awk行处理时使用了print函数打印分割后的字段
- 5.awk在打印后的字段加上空格，因为$1,$3 之间有一个逗号。逗号被映射至OFS内部变量中，称为输出字段分隔符， OFS默认为空格.
- 6.awk输出之后，将从文件中获取另一行，并将其存储在$0中，覆盖原来的内容，然后将新的字符串分隔成字段并进行处理。该过程将持续到所有行处理完毕

# 3、Awk内置变量

| 内置变量 | 含义 |
|---------|------|
| $0 | 当前记录 |
| $1~$n | 当前记录的第N个字段 |
| FS | 输入字段分隔符（-F相同作用）默认空格 |
| RS | 输入记录分割符，默认换行符 |
| NF | 字段个数就是列  |
| NR | 记录数，就是行号，默认从1开始 |
| OFS | 输出字段分隔符，默认空格 |
| ORS | 出记录分割符，默认换行符 |

要想了解awk的一些内部变量需要先准备如下数据文件。
```
[root@oldxu ~]# cat awk_file.txt
ll 1990 50 51 61
kk 1991 60 52 62
hh 1992 70 53 63
jj 1993 80 54 64
mm 1994 90 55 65
```

1.awk内置变量，$0保存当前记录的内容
```
[root@oldxu ~]# awk '{print $0}' /etc/passwd
```

2.awk内置变量，FS指定字段分割符， 默认以空白行作为分隔符
```
#1.输出文件中的第一列
[root@oldxu ~]# awk '{print $1}' awk_file.txt
ll
kk
hh
jj
mm
```

#2.指定多个分隔符，获取第一列内容
```
[root@oldxu ~]# cat awk_file.txt
ll:1990 50 51 61
kk:1991 60 52 62
hh 1992 70 53 63
jj 1993 80 54 64
mm 1994 90 55 65

#以冒号或空格为分隔符

[root@oldxu ~]# awk -F '[: ]' '{print $2}' awk_file.txt
1990
1991
1992
1993
1994

#4.指定多个分隔符

[root@oldxu ~]# cat awk_file.txt
ll::1990 50 51 61
kk:1991 60 52 62
hh 1992 70 53 63
jj 1993 80 54 64
mm 1994 90 55 65

#[: ]+连续的多个冒号当一个分隔符，连续的多个空格当一个分隔符，连续空格和冒号也当做一个字符来处理
[root@oldxu ~]# awk -F '[: ]+' '{print $2}' awk_file.txt
1990
1991
1992
1993
1994
```

3.awk内置变量NF，保存每行的最后一列
```
#1.通过print打印，NF和$NF，你发现了什么?
[root@oldxu ~]# awk '{print NF,$NF}' awk_file.txt
5 61
5 62
5 63
5 64
5 65

#F: 如果将第五行的55置为空，那么该如何在获取最后一列的数字?
[root@oldxu ~]# awk '{print $5}' awk_file.txt
61
62
63
64

#最后一列为空，为什么?

#Q.使用$NF为什么就能成功?(因为NF变量保存的是每一行的最后一列)
[root@oldxu ~]# awk '{print $NF}' awk_file.txt
61
62
63
64
65

#2.如果一个文件很长，靠数列数需要很长的时间，那如何快速打印倒数第二列?
[root@oldxu ~]# awk '{print $(NF-1)}' awk_file.txt
51
52
53
54
90
```

4.awk内置变量NR，表示记录行号。
```
#1.使用pring打印NR，会发现NR会记录每行文件的行号
[root@oldxu ~]# awk '{print NR,$0}' awk_file.txt
1 ll 1990 50 51 61
2 kk 1991 60 52 62
3 hh 1992 70 53 63
4 jj 1993 80 54 64
5 mm 1994 90    65

#2.那如果我们想打印第二行到第三行的内容怎么办?
[root@oldxu ~]# awk 'NR>1&&NR<4 {print NR,$0}' awk_file.txt
2 kk 1991 60 52 62
3 hh 1992 70 53 63

#3.那如果只想打印第三行，该怎么办?
[root@oldxu ~]# awk 'NR==3 {print NR,$00}' awk_file.txt
3 hh 1992 70 53 63

#4.那如果既想打印第三行，又想打印第一列？
[root@oldxu ~]# awk 'NR==3 {print NR,$1}' awk_file.txt
3 hh
```

5.awk内置变量RS，读入行分隔符。
```
[root@oldxu ~]# cat file.txt
Linux|Shell|Nginx--docker|Gitlab|jenkins--mysql|redis|mongodb

[root@oldxu ~]# awk 'BEGIN{RS="--"}{print $0}' file.txt
Linux|Shell|Nginx
docker|Gitlab|jenkins
mysql|redis|mongodb
```

6.awk内置变量，“OFS输出字段分隔符”，初始情况下OFS变量是空格。
```
[root@oldxu ~]# awk 'BEGIN{RS="--";FS="|";OFS=":"} {print $1,$3}' file.txt
Linux:Nginx
docker:jenkins
mysql:mongodb
```

7.awk内置变量，“ORS输出行分隔符”，默认行分割符为\n。
```
[root@openvpn-192 ~]# awk 'BEGIN{RS="--";FS="|";OFS=":";ORS="----"} {print $1,$3}' file.txt
Linux:Nginx----docker:jenkins----mysql:mongodb
```

# 4.Awk格式输出

- awk可以通过printf函数生成非常漂亮的数据报表。

| **格式符**	| **含义** |
|-------|-------|
| %s | 打印字符串 |
| %d | 打印十进制数（整数） |
| %f | 打印一个浮点数（小数） |
| %x | 打印十六进制数 |
| **修饰符**	| **含义** |
| -	| 左对齐 |
| +	| 右对齐 |

1.printf默认没有分隔符。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}{printf $1}' /etc/passwd 
rootbindaemonadm
```

2.加入换行，格式化输出。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}{printf "%s\n",$1}' /etc/passwd 
root
bin
daemon
adm
```

3.使用占位符美化输出。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"} {printf "%20s %20s\n",$1,$7}' /etc/passwd
                root            /bin/bash
                 bin        /sbin/nologin
              daemon        /sbin/nologin
                 adm        /sbin/nologin
```

4.默认右对齐，- 表示左对齐。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}{printf "%-20s %-20s\n",$1,$7}' /etc/passwd
root                 /bin/bash           
bin                  /sbin/nologin       
daemon               /sbin/nologin       
adm                  /sbin/nologin
```

5.美化一个成绩表。
```
[root@localhost shell]# cat student.txt
oldxu       80    90    96    98
oldqiang    93    98    92    91
oldguo      78    76    87    92
oldli       86    89    68    92
oldgao      85    95    75    90

#效果

[root@web01 shell-awk]# cat student.awk
BEGIN {
    printf "%-10s%-10s%-10s%-10s%-10s\n",
    "Name","Yuwen","Shuxue","yinyu","qita"
}

{
    printf "%-10s%-10d%-10d%-10d%-10d\n",$1,$2,$3,$4,$5
}

[root@web01 shell-sed]# awk -f student.awk student.txt
name      Yuwen     shuxue    yinyu     qita
oldxu     80        90        96        98
oldqiang  93        98        92        91
oldguo    78        76        87        92
oldli     86        89        68        92
oldgao    85        95        75        90
```

# 5.Awk模式匹配

- awk第一种模式匹配：RegExp awk第二种模式匹配：关系运算匹配

## RegExp示例

1.匹配/etc/passwd文件行中含有root字符串的所有行。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}/root/{print $0}' passwd
```

2.匹配/etc/passwd文件行中以root开头的行。
```
[root@oldxu ~]# awk '/^root/{print $0}' passwd
```

3.匹配/etc/passwd文件行中/bin/bash结尾的行。
```
[root@oldxu ~]# awk '/\/bin\/bash$/{print $0}' passwd
```

### 运算符匹配示例

| **符号** | **含义** |
|-----|-----|
| <	| 小于 |
| >	| 大于 |
| <= | 小于等于 |
| >= | 大于等于 |
| == | 等于 |
| != | 不等于 |
| ~	| 匹配正则表达式 |
| !~ | 不匹配正则表达式 |

1、以:为分隔符，匹配/etc/passwd文件中第3个字段小于50的所有行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$3<50{print $0}' passwd
```

2、以:为分隔符，匹配/etc/passwd文件中第3个字段大于50的所有行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$3>50{print $0}' passwd
```

3、以:为分隔符，匹配/etc/passwd文件中第7个字段为/bin/bash的所有行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$7=="/bin/bash"{print $0}' passwd
```

4、以:为分隔符，匹配/etc/passwd文件中第7个字段不为/bin/bash的所有行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$7!="/bin/bash"{print $0}' passwd
```

5、以:为分隔符，匹配/etc/passwd文件中第3个字段包含3个数字以上的所有行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$3 ~ /[0-9]{3,}/{print $0}' passwd 
```


### 布尔运算符匹配示例
```
符号   	#含义
||    	#或
&&    	#与
!	      #非
```

1、以:为分隔符，匹配passwd文件中包含ftp或mail的所有行信息。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$1=="ftp" || $1=="mail" {print $0}' passwd
```

2、以:为分隔符，匹配passwd文件中第3个字段小于50并且第4个字段大于50的所有行信息。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}$3<50 && $4>50{print $0}' passwd
```

3.匹配没有/sbin/nologin 的行。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"} $0 !~ /\/sbin\/nologin/{print $0}' passwd
```

### 运算符匹配示例

| 运算符	| 含义 |
|-------|------|
| +	| 加 |
| -	| 减 |
| *	| 乘 |
| /	| 除 |
| %	| 模 |

1、计算学生课程分数平均值，学生课程文件内容如下：
```
[root@localhost shell]# cat student.txt
oldxu       80    90    96    98
oldqiang    93    98    92    91
oldguo      78    76    87    92
oldli       86    89    68    92
oldgao      85    95    75    90

#1.输出平均值
[root@web01 shell-awk]# cat student.awk
BEGIN {
    printf "%-10s%-10s%-10s%-10s%-10s%-10s\n",
    "Name","Yuwen","Shuxue","yinyu","qita","AVG"
}

{
    total=$2+$3+$4+$5
    avg=total/(NF-1)
}

{
    printf "%-10s%-10d%-10d%-10d%-10d%-10d\n",$1,$2,$3,$4,$5,avg
}

#2.执行观察结果
[root@web01 shell-awk]# awk -f student.awk  student.txt
Name      Yuwen     Shuxue    yinyu     qita      AVG
oldxu     80        90        96        98        91
oldqiang  93        98        92        91        93
oldguo    78        76        87        92        83
oldli     86        89        68        92        83
oldgao    85        95        75        90        86
```

本章练习示例:
- 1.找出/etc/passwd文件中uid为0的。
- 2.找出/etc/passwd文件中uid小于10的。
- 3.找出/etc/passwd文件中uid 小于50，且bash为/bin/bash 的行
- 4.匹配用户名为root并且打印uid小于15的行
- 5.匹配用户名为root或uid大于5000
- 6.匹配uid为3位及以上的行
- 7.匹配到 /sbin/nologin 的行
- 8.磁盘使用率大于多少则，则打印可用的值。
- 9.正则匹配nginx开头的行

翻译如下语句含义:

示例1
```
# awk '/west/' datafile 
# awk '/^nor/' datafile 
# awk '$3 ~ /^nor/' datafile 
# awk '/^(no|so)/' datafile 
# awk '{print $3,$2}' datafile
# awk '{print $3 $2}' datafile 
# awk '{print $0}' datafile 
# awk '{print "Number of fields: "NF}' datafile 
# awk '/nor/{print $3,$2}' datafile
# awk '/^[ns]/{print $1}' datafile 
# awk '$5 ~ /\. [7-9]+/' datafile 
# awk '$2 !~ /E/{print $1,$2}' datafile 
# awk '$3 ~ /^job/{print $3 "is a nice boy."}' datafile 
# awk '$8 ~ /[0-9][0-9]$/{print $8}' datafile
# awk '$4 ~ /Cn$/{print "The price is $" $8 "."}' datafile 
# awk '/gdx/{print $0}' datafile 
# awk -F: '{print "Number of fields: "NF}' /etc/passwd 
# awk -F"[ :]" '{print NF}' /etc/passwd 
```

awk示例2
```
[root@oldxu ~]# cat b.txt 
oldxu:is a:good boy!

[root@oldxu ~]# awk '{print NF}' b.txt
[root@oldxu ~]# awk -F ':' '{print NF}' b.txt
[root@oldxu ~]# awk -F"[ :]" '{print NF}' b.txt
```

# 6.Awk条件判断

- if语句格式: { if(表达式)｛语句;语句;... ｝ }

1.以:为分隔符，打印当前管理员用户名称
```
[root@oldxu ~]# awk -F: '{ if($3==0){print $1 "is adminisitrator"} }' /etc/passwd
```

2.以:为分隔符，统计系统用户数量
```
[root@oldxu ~]# awk -F: '{ if($3>0 && $3<1000){i++}} END {print i}' passwd
```

3.以:为分隔符，统计普通用户数量
```
[root@oldxu ~]# awk -F: '{ if($3>1000){i++}} END {print i}' passwd
```

4.以:为分隔符，只打印/etc/passwd中第3个字段的数值在50-100范围内的行信息
```
[root@oldxu ~]# awk 'BEGIN{FS=":"}{if($3>50 && $3<100) print $0}' passwd*
```

- if...else 语句格式: {if(表达式)｛语句;语句;... ｝else{语句;语句;...}}

#1.以:为分隔符，判断第三列如果等于0，则打印该用户名称，如果不等于0则打印第七列。
```
[root@oldxu ~]# awk 'BEGIN{FS=":"} { if ($3==0) { print $1 }  else { print $7 }  }' /etc/passwd

#2.以:为分隔符，判断第三列如果等于0，那么则打印管理员出现的个数，否则都视为系统用户，并打印它的个数。
[root@oldxu ~]# awk 'BEGIN{FS=":";OFS="\n"} { if($3==0) { i++ } else { j++ } } END { print i" 个管理员" , j" 个系统用户" }' /etc/passwd
1 个管理员
326 个系统用户
```

- if...else if...else 语句格式: { if(表达式 1)｛语句;语句；... ｝else if(表达式 2)｛语句;语句；. .. ｝else｛语句;语句；... ｝}

1.使用awk if打印出当前/etc/passwd文件管理员有多少个，系统用户有多少个，普通用户有多少个
```
[root@oldxu ~]# awk -F: '{ if($3==0){i++} else if($3>0 && $3<1000){j++} else if($3>1000) {k++}} END {print "管理员个数"i; print "系统用户个数" j; print "系统用户个 数" }' /etc/passwd
管理员个数1
系统用户个数29
系统用户个数69

[root@web01 shell-awk]# cat passwd_count.awk
#行处理前
BEGIN{
    FS=":";OFS="\n"
}
#行处理中
{
    if($3==0)
        { i++ }
    else if ($3>0 && $3<1001)
        { j++ }
    else
        { k++ }
}
#行处理后
END {
    print i" 个管理员",
          j" 个系统用户",
          k" 个普通用户"
}
```

2.打印/etc/passwd文件中UID小于50的、或者UID小雨50大于100、或者UID大于100的用户名以及UID。 

`UID<50    root    0 UID<50    bin    1 50<UID<100    nobody    99 50<UID<100    dbus    81 UID>100    systemd    192 UID>100    chrony    998`

```
[root@oldxu ~]# cat if.awk 
BEGIN{
    FS=":"
}

{
    if($3<50)
    {
        printf "%-20s%-20s%-10d\n","UID<50",$1,$3
    }
    else if ($3>50 && $3<100)
    {
        printf "%-20s%-20s%-10d\n","50<UID<100",$1,$3
    }
    else 
    {
        printf "%-20s%-20s%-10d\n","UID>100",$1,$3
    }
}
```

3.计算下列每个同学的平均分数，并且只打印平均分数大于90的同学姓名和分数信息
```
[root@oldxu ~]# cat student.txt
oldxu       80    90    96    98
oldqiang    93    98    92    91
oldguo      78    76    87    92
oldli       86    89    68    92
oldgao      85    95    75    90


[root@oldxu ~]# awk 'BEGIN{printf "%-20s%-20s%-20s%-20s%-20s%-20s\n","Name","Chinese","English","Math","Physical","Average"}{sum=$2+$3+$4+$5;avg=sum/4}{if(avg>90) printf "%-20s%-20d%-20d%-20d%-20d%-0.2f\n",$1,$2,$3,$4,$5,avg}' student.txt 
```


# 7.Awk循环语句

while循环：while(条件表达式) 动作
```
[root@oldxu ~]# awk 'BEGIN{ i=1; while(i<=10){print i; i++} }'
[root@oldxu ~]# awk -F: '{i=1; while(i<=NF){print $i; i++}}' /etc/passwd
[root@oldxu ~]# awk -F: '{i=1; while(i<=10) {print $0; i++}}' /etc/passwd
[root@oldxu ~]#cat b.txt
111 222
333 444 555
666 777 888 999
[root@oldxu ~]# awk '{i=1; while(i<=NF){print $i; i++}}' b.txt
```

for循环：for(初始化计数器;计数器测试;计数器变更) 动作
```
#C 风格 for
[root@oldxu ~]# awk 'BEGIN{for(i=1;i<=5;i++){print i} }' 

#将每行打印 10 次
[root@oldxu ~]# awk -F: '{ for(i=1;i<=10;i++) {print $0} }' passwd
[root@oldxu ~]# awk -F: '{ for(i=1;i<=10;i++) {print $0} }' passwd 
[root@oldxu ~]# awk -F: '{ for(i=1;i<=NF;i++) {print $i} }' passwd
```

需求：计算1+2+3+4+...+100的和，请使用while、for两种循环方式实现
```
# while循环
[root@oldxu ~]# cat add_while.awk 
BEGIN{
    while(i<=100)
    {   # 一个变量不赋值，默认为0或者空
        sum+=i
        i++
    }    
        print sum
}

# for循环 
[root@oldxu ~]# cat add_for.awk 
BEGIN{
    for(i=0;i<=100;i++) 
    {
        sum+=i
    }
        print sum
}
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



https://mp.weixin.qq.com/s?__biz=MzAwNTM5Njk3Mw==&mid=2247486759&idx=1&sn=72fc2dfe7422f7e9caa6b583173f27d5&chksm=9b1c0da5ac6b84b356ac960bc12a75c8c4d8cadcec6cc40c0d9008d3783b93e4f53c6db4105a&mpshare=1&scene=23&srcid=#rd

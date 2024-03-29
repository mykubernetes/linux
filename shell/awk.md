# 1.Awk基础介绍




## 1.命令选项
- -F fs or --field-separator fs ：指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:。
- -v var=value or --asign var=value ：赋值一个用户定义变量。
- -f scripfile or --file scriptfile ：从脚本文件中读取awk命令。
- -mf nnn and -mr nnn ：对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。
- -W compact or --compat, -W traditional or --traditional ：在兼容模式下运行awk。所以gawk的行为和标准的awk完全一样，所有的awk扩展都被忽略。
- -W copyleft or --copyleft, -W copyright or --copyright ：打印简短的版权信息。
- -W help or --help, -W usage or --usage ：打印全部awk选项和每个选项的简短说明。
- -W lint or --lint ：打印不能向传统unix平台移植的结构的警告。
- -W lint-old or --lint-old ：打印关于不能向传统unix平台移植的结构的警告。
- -W posix ：打开兼容模式。但有以下限制，不识别：/x、函数关键字、func、换码序列以及当fs是一个空格时，将新行作为一个域分隔符；操作符**和**=不能代替^和^=；fflush无效。
- -W re-interval or --re-inerval ：允许间隔正则表达式的使用，参考(grep中的Posix字符类)，如括号表达式[[:alpha:]]。
- -W source program-text or --source program-text ：使用program-text作为源代码，可与-f命令混用。
- -W version or --version ：打印bug报告信息的版本。

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

| 变量 | 描述 |
|------|------|
| $n | 当前记录的第n个字段，字段间由FS分隔。 |
| $0 | 完整的输入记录。 |
| ARGC | 命令行参数的数目。 |
| ARGIND | 命令行中当前文件的位置(从0开始算)。 |
| ARGV | 包含命令行参数的数组。 |
| CONVFMT | 数字转换格式(默认值为%.6g) |
| ENVIRON | 环境变量关联数组。 |
| ERRNO | 最后一个系统错误的描述。 |
| FIELDWIDTHS | 字段宽度列表(用空格键分隔)。 |
| FILENAME | 当前文件名。 |
| FNR | 同NR，但相对于当前文件。 |
| FS | 字段分隔符(默认是任何空格)。 |
| IGNORECASE | 如果为真，则进行忽略大小写的匹配。 |
| NF | 当前记录中的字段数。 |
| NR | 当前记录数。 |
| OFMT | 数字的输出格式(默认值是%.6g)。 |
| OFS | 输出字段分隔符(默认值是一个空格)。 |
| ORS | 输出记录分隔符(默认值是一个换行符)。 |
| RLENGTH | 由match函数所匹配的字符串的长度。 |
| RS | 记录分隔符(默认是一个换行符)。 |
| RSTART | 由match函数所匹配的字符串的第一个位置。 |
| SUBSEP | 数组下标分隔符(默认值是/034)。 |


要想了解awk的一些内部变量需要先准备如下数据文件。
```
# cat awk_file.txt
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
# cat awk_file.txt
ll:1990 50 51 61
kk:1991 60 52 62
hh 1992 70 53 63
jj 1993 80 54 64
mm 1994 90 55 65

#以冒号或空格为分隔符

# awk -F '[: ]' '{print $2}' awk_file.txt
1990
1991
1992
1993
1994

#4.指定多个分隔符

# cat awk_file.txt
ll::1990 50 51 61
kk:1991 60 52 62
hh 1992 70 53 63
jj 1993 80 54 64
mm 1994 90 55 65

#[: ]+连续的多个冒号当一个分隔符，连续的多个空格当一个分隔符，连续空格和冒号也当做一个字符来处理
# awk -F '[: ]+' '{print $2}' awk_file.txt
1990
1991
1992
1993
1994
```

3.awk内置变量NF，保存每行的最后一列
```
#1.通过print打印，NF和$NF，你发现了什么?
# awk '{print NF,$NF}' awk_file.txt
5 61
5 62
5 63
5 64
5 65

#F: 如果将第五行的55置为空，那么该如何在获取最后一列的数字?
# awk '{print $5}' awk_file.txt
61
62
63
64

#最后一列为空，为什么?

#Q.使用$NF为什么就能成功?(因为NF变量保存的是每一行的最后一列)
# awk '{print $NF}' awk_file.txt
61
62
63
64
65

#2.如果一个文件很长，靠数列数需要很长的时间，那如何快速打印倒数第二列?
# awk '{print $(NF-1)}' awk_file.txt
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

8、统计/etc/passwd:文件名，每行的行号，每行的列数，对应的完整行内容:
```
# awk -F ':' '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF ",linecontent:"$0}' /etc/passwd
filename:/etc/passwd,linenumber:1,columns:7,linecontent:root:x:0:0:root:/root:/bin/bash
filename:/etc/passwd,linenumber:2,columns:7,linecontent:daemon:x:1:1:daemon:/usr/sbin:/bin/sh
filename:/etc/passwd,linenumber:3,columns:7,linecontent:bin:x:2:2:bin:/bin:/bin/sh
filename:/etc/passwd,linenumber:4,columns:7,linecontent:sys:x:3:3:sys:/dev:/bin/sh
```

9、使用printf替代print,可以让代码更加简洁，易读
```
# awk -F ':' '{printf("filename:%10s,linenumber:%s,columns:%s,linecontent:%s\n",FILENAME,NR,NF,$0)}' /etc/passwd
```

10、当前shell环境变量及其值的关联数组
```
# awk 'BEGIN{print ENVIRON["PATH"]}'
/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin:/root/bin:/usr/lib64
```


## awk自定义变量

1. 下面统计/etc/passwd的账户人数:
```
# awk '{count++;print $0;} END{print "user count is ", count}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
......
user count is  40
```
count是自定义变量。之前的action{}里都是只有一个print,其实print只是一个语句，而action{}可以有多个语句，以;号隔开。

2. 这里没有初始化count，虽然默认是0，但是妥当的做法还是初始化为0:
```
# awk 'BEGIN {count=0;print "[start]user count is ", count} {count=count+1;print $0;} END{print "[end]user count is ", count}' /etc/passwd
[start]user count is 0 root:x:0:0:root:/root:/bin/bash
...
[end]user count is 40
```

3. 统计某个文件夹下的文件占用的字节数:
```
# ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size}'
[end]size is  8657198
```

4 如果以M为单位显示:
```
# ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size/1024/1024,"M"}'
[end]size is  8.25889 M
```
- 注意，统计不包括文件夹的子目录。

1 在脚本中赋值变量

在gawk中给变量赋值使用赋值语句进行，例如：
```
# awk ' BEGIN {test="hello" ;print test }'
hello
```

2 在命令行中使用赋值变量

gawk命令也可以在“脚本”外为变量赋值，并在脚本中进行引用。例如，上述的例子还可以改写为：
```
# awk -v test="hello" ' BEGIN {print test }'
hello
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

## 条件语句

统计某个文件夹下的文件占用的字节数,过滤4096大小的文件(一般都是文件夹):
```
# ls -l |awk 'BEGIN {size=0;print "[start]size is ", size} {if($5!=4096){size=size+$5;}} END{print "[end]size is ", size/1024/1024,"M"}'
[start]size is  0
[end]size is  8.22339 M
```

## 循环语句

显示/etc/passwd的账户:
```
# awk -F ':' 'BEGIN {count=0;} {name[count] = $1;count++;}; END{for (i = 0; i < NR; i++) print i, name[i]}' /etc/passwd
0 root
1 daemon
2 bin
3 sys
4 sync
5 games
......
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

# 1.Awk数组概述

- 1.什么是awk数组 数组其实也算是变量, 传统的变量只能存储一个值，但数组可以存储多个值。
- 2.awk数组应用场景 通常用来统计、比如：统计网站访问TOP10、网站Url访问TOP10等等等
- 3.awk数组统计技巧 1.在awk中，使用数组时，不仅可以使用1 2 3 ..n作为数组索引，也可以使用字符串作为数组索引。 2.要统计某个字段的值，就将该字段作为数组的索引，然后对索引进行遍历。
- 4.awk数组的语法 array_name[index]=value
- 5.awk数组示例 1.统计/etc/passwd中各种类型shell的数量。

```
[root@web01 shell-awk]# cat passwd_count.awk
BEGIN{
    FS=":"
}

#赋值操作（因为awk是一行一行读入的，相当是循环了整个文件中的内容）
{
    hosts[$NF]++
}


#赋值完成后，需要通过循环的方式将其索引的次数遍历出来
END {
    for (item in hosts) {
        print item,
        hosts[item]
    }
}
```

2.统计主机上所有的tcp链接状态数，按照每个tcp状态分类。
```
[root@Shell ~]# netstat -an | grep tcp | awk '{arr[$6]++}END{for (i in arr) print i,arr[i]}'
```

3.统计当前系统80端口连接状态信息。<当前时实状态ss>
```
[root@Shell ~]# ss -an|awk '/:80/{tcp[$2]++} END {for(i in tcp){print i,tcp[i]}}'
```

4.统计当前访问的每个IP的数量<当前时实状态 netstat,ss>
```
[root@Shell ~]# ss -an|awk -F ':' '/:80/{ips[$(NF-1)]++} END {for(i in ips){print i,ips[i]}}'
```

# 2.Awk数组示例

- Nginx日志分析，日志格式如下：
```
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

52.55.21.59 - - [25/Jan/2018:14:55:36 +0800] "GET /feed/ HTTP/1.1" 404 162 "https://www.google.com/" "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; de) Presto/2.9.168 Version/11.52" "-"
```

1.统计一天内访问最多的10个IP
```
[root@oldxu ~]# cat ngx_top_10
{
    cip[$1]++
}

END{
    for ( item in cip ) {
        print item,cip[item]
    }
}
```

2.统计访问大于1000次的IP
```
[root@oldxu ~]# cat ngx_top_10_2
{
    cip[$1]++
}

END{
    for ( item in cip ) {
        if (cip[item] > 10000) {
            print item,cip[item]
        }
    }
}
```

3.统计访问最多的10个页面($request top 10)
```
[root@oldxu ~]# cat ngx_request_top_10
{
    request[$7]++
}

END{
    for ( item in request ) {
        print item,request[item]
    }
}
```

4.统计每个URL访问内容总大小($body_bytes_sent)
```
[root@web01 awk_nginx]# cat ngx_request_size
{
    #相同的url会自动累加其大小
    url[$7]+=$10
}

END{
    for ( item in url ){
            print item,  url[item]/1024/1024"Mb"
    }
}
```

5.统计2018年01月25日，每个IP访问状态码数量($status)
```
[root@web01 awk_nginx]# cat ngx_ip_code_top
{
    ip_code[$1" "$9]++
}

END{
    for ( item in ip_code ) {
        print item,ip_code[item]
    }
}
```

6.统计访问状态码为404及出现的次数($status)
```
[root@oldxu ~]# cat ngx_status_top_404
{
    status[$9]++
}

END{
    for ( item in status) {
        if (item == 404 ) {
            print item,status[item]
        }
    }
}
```

7.统计2018年01月25日,各种状态码数量
```
#统计状态码出现的次数
[root@Shell ~]# awk '{code[$9]++} END {for(i in code){print i,code[i]}}' log.bjstack.log

[root@Shell ~]# awk '{if($9>=100 && $9<200) {i++}
else if ($9>=200 && $9<300) {j++}
else if ($9>=300 && $9<400) {k++}
else if ($9>=400 && $9<500) {n++}
else if($9>=500) {p++}}
END{print i,j,k,n,p,i+j+k+n+p}' log.bjstack.log
```

# 3.Awk数组案例

1.模拟生产环境数据脚本，需要跑大约30~60s(等待一段时间ctrl+c结束即可)
```
[root@localhost shell]# cat insert.sh 
#!/bin/bash
function create_random()
{
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

INDEX=1
while true
do
    for user in oldxu oldguo oldqiang oldboy oldli
    do
        COUNT=$RANDOM
        NUM1=`create_random 1 $COUNT`
        NUM2=`expr $COUNT - $NUM1`
        echo "`date '+%Y-%m-%d %H:%M:%S'` $INDEX user: $user insert $COUNT records into datebase:product table:detail, insert $NUM1 records successfully,failed $NUM2 records" >> ./db.log.`date +%Y%m%d`
        INDEX=`expr $INDEX + 1`
    done
done
```

数据格式如下：
```
2019-11-06 18:25:53 1 user: oldxu insert 8302 records into datebase:product table:detail, insert 1166 records successfully,failed 7136 records
2019-11-06 18:25:53 2 user: oldguo insert 16106 records into datebase:product table:detail, insert 15215 records successfully,failed 891 records
2019-11-06 18:25:53 3 user: oldqiang insert 1133 records into datebase:product table:detail, insert 995 records successfully,failed 138 records
2019-11-06 18:25:53 4 user: oldgao insert 8894 records into datebase:product table:detail, insert 7375 records successfully,failed 1519 records
2019-11-06 18:25:53 5 user: oldboy insert 8248 records into datebase:product table:detail, insert 3554 records successfully,failed 4694 records
```

需求1：统计每个人分别插入了多少条records进数据库
```
[root@lb01 ~]# awk '
BEGIN {
    printf "%-20s%-20s\n","User","Total records"
} 
{
    success[$5]+=$7
    #success[$5]=success[$5]+$7
} 
END { 
    for (u in success)
    printf "%-20s%20d\n",u,success[u]
}' db.log.20191106
```

需求2：统计每个人分别插入成功了多少record，失败了多少record
```
[root@lb01 ~]# awk '
BEGIN {
    printf "%-20s%-20s%-20s\n","User","Success","Failed"
} 
{
    success[$5]+=$13
    failed[$5]+=$16
} 
END { 
    for (u in success) 
    printf "%-20s%-20d%-20d\n",u,success[u],failed[u]
}' db.log.20191106
```

需求3：将需求1和需求2结合起来，一起输出，输出每个人分别插入多少条数据，多少成功，多少失败，并且要格式化输出，加上标题
```
[root@lb01 ~]# awk '
BEGIN {
    printf "%-20s%-20s%-20s%-20s\n","User","Total","Success","Failed"
} 
{
    success[$5]+=$13
    failed[$5]+=$16
} 

END { 
    for (u in success) 
    printf "%-20s%-20s%-20d%-20d\n",u,success[u]+failed[u],success[u],failed[u]
}' db.log.20191106
```

需求4：在例子3的基础上，加上结尾，统计全部插入记录数，成功记录数，失败记录数。
```
[root@lb01 ~]# awk '
BEGIN {
    printf "%-20s%-20s%-20s%-20s\n","User","Total","Success","Failed"
} 
{
    total[$5]+=$7
    success[$5]+=$13
    failed[$5]+=$16

    #在原始数据进行统计累计
    total_sum+=$7
    success_sum+=$13
    failed_sum+=$16  
} 

END { 
    for (u in success) {
    printf "%-20s%-20s%-20d%-20d\n",u,total[u],success[u],failed[u]
    }
    printf "%-20s%-20s%-20d%-20d\n","total",total_sum,success_sum,failed_sum
}' db.log.20191106
```




外部变量
```
# a=100
# b=100
# echo |awk '{print v1*v2 }' v1=$a v2=$b
10000
```

赋值运算符
| 运算符 | 描述 |
|-------|-------|
| `= += -= *= /= %= ^= **=`	|赋值语句 |

逻辑运算符
```
||	逻辑或
&&	逻辑与
```

正则运算符

| 运算符 | 描述 |
|-------|-------|
| ~ ~! | 匹配正则表达式和不匹配正则表达式 |

关系运算符

| 运算符 | 描述 |
|-------|-------|
| < <= > >= != == | 关系运算符 |

算术运算符

| 运算符 | 描述 |
|-------|-------|
| + - | 加，减 |
| * / & | 乘，除与求余 |
| + - ! | 一元加，减和逻辑非 |
| ^ *** | 求幂 |
| ++ -- | 增加或减少，作为前缀或后缀 |

其它运算符

| 运算符 | 描述 |
|-------|-------|
| $ | 字段引用 |
| 空格 | 字符串连接符 |
| ?: | C条件表达式 |
| in | 数组中是否存在某键值 |


算术运算符
```
# awk 'BEGIN{a="b";print a,a++,a--,++a;}'
b 0 1 1

# awk 'BEGIN{a="0";print a,a++,a--,++a;}'
0 0 1 1

# awk 'BEGIN{a="0";print a,a++,--a,++a;}'
0 0 0 1

#和其它编程语言一样，所有用作算术运算符进行操作，操作数自动转为数值，所有非数值都变为0
```

位置匹配
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


awk赋值运算符
```
a+=5; 等价于：a=a+5; 其它同类
```
awk逻辑运算符
```
[chengmo@localhost ~]$ awk 'BEGIN{a=1;b=2;print (a>5 && b<=2),(a>5 || b<=2);}'
0 1
```

awk正则运算符
```
[chengmo@localhost ~]$ awk 'BEGIN{a="100testa";if(a ~ /^100*/){print "ok";}}'
ok
```

awk关系运算符
```
如：> < 可以作为字符串比较，也可以用作数值比较，关键看操作数如果是字符串 就会转换为字符串比较。两个都为数字 才转为数值比较。字符串比较：按照ascii码顺序比较。
[chengmo@localhost ~]$ awk 'BEGIN{a="11";if(a >= 9){print "ok";}}'

[chengmo@localhost ~]$ awk 'BEGIN{a=11;if(a >= 9){print "ok";}}'  
ok
```

awk算术运算符
```
说明，所有用作算术运算符 进行操作，操作数自动转为数值，所有非数值都变为0。

[chengmo@localhost ~]$ awk 'BEGIN{a="b";print a++,++a;}' 
0 2
```

其它运算符
```
?:运算符
[chengmo@localhost ~]$ awk 'BEGIN{a="b";print a=="b"?"ok":"err";}'
ok

in运算符
[chengmo@localhost ~]$ awk 'BEGIN{a="b";arr[0]="b";arr[1]="c";print (a in arr);}'
0

[chengmo@localhost ~]$ awk 'BEGIN{a="b";arr[0]="b";arr["b"]="c";print (a in arr);}'
1
in运算符，判断数组中是否存在该键值。
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

## 控制语句：

if-else
`语法：if (condition) {then-body} else {[ else-body ]}`
```
[root@sta ~]# awk -F: '{if ($1=="root") print $1, "Admin"; else print $1, "Common User"}' /etc/passwd |head -n 3
root Admin
bin Common User
daemon Common User
```

while

`语法： while (condition){statement1; statment2; …}`
```
awk -F: '{i=1;while (i<=3) {print $i;i++}}' /etc/passwd
awk -F: '{i=1;while (i<=NF) { if (length($i)>=4) {print $i}; i++ }}' /etc/passwd
```

do-while

`语法： do {statement1, statement2, …} while (condition)`
```
[root@sta ~]# awk -F : '{ i=1 ; while( i<=NF) {if(length($i)>4) {print $i}; i++ } }' /etc/passwd |head -n 3
/root
/bin/bash
/sbin/nologin
```

for
`语法： for ( variable assignment; condition; iteration process) { statement1, statement2, …}`
```
[root@sta ~]# awk -F : '{ for(i=1;i<=NF;i++) {if(length($i)>4) {print $i}; i++ } }' /etc/passwd |head -n 3
/bin/bash
/sbin/nologin
daemon
```

for循环还可以用来遍历数组元素：

`语法： for (i in array) {statement1, statement2, …}`
```
[root@localhost ~]# awk -F: '{shell[$NF]++} END{for (A in shell) {print A,shell[A]} }' /etc/passwd #查看用户shell
/bin/sync 1
/bin/bash 2
/sbin/nologin 26
/sbin/halt 1
/sbin/shutdown 1
```

case

`语法：switch (expression) { case VALUE or /REGEXP/: statement1, statement2,… default: statement1, …}`

break 和 continue

常用于循环或case语句中

next

提前结束对本行文本的处理，并接着处理下一行；例如，下面的命令将显示其ID号为奇数的用户：
```
# awk -F: '{if($3%2==0) next;print $1,$3}' /etc/passwd |head -n 3
bin 1
adm 3
sync 5
```

## 常见用法

Linux Web服务器网站故障分析常用的命令

系统连接状态篇：

1.查看TCP连接状态
```
netstat -nat |awk ‘{print $6}’|sort|uniq -c|sort -rn
netstat -n | awk ‘/^tcp/ {++S[$NF]};END {for(a in S) print a, S[a]}’ 或
netstat -n | awk ‘/^tcp/ {++state[$NF]}; END {for(key in state) print key,"\t",state[key]}’
netstat -n | awk ‘/^tcp/ {++arr[$NF]};END {for(k in arr) print k,"t",arr[k]}’
netstat -n |awk ‘/^tcp/ {print $NF}’|sort|uniq -c|sort -rn
netstat -ant | awk ‘{print $NF}’ | grep -v ‘[a-z]‘ | sort | uniq -c
```

2.查找请求数请20个IP（常用于查找攻来源）：
```
netstat -anlp|grep 80|grep tcp|awk ‘{print $5}’|awk -F: ‘{print $1}’|sort|uniq -c|sort -nr|head -n20
netstat -ant |awk ‘/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A[i],i}’ |sort -rn|head -n20
```

3.用tcpdump嗅探80端口的访问看看谁最高
```
tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." ‘{print $1"."$2"."$3"."$4}’ | sort | uniq -c | sort -nr |head -20
```

4.查找较多time_wait连接
```
netstat -n|grep TIME_WAIT|awk ‘{print $5}’|sort|uniq -c|sort -rn|head -n20
```

5.找查较多的SYN连接
```
netstat -an | grep SYN | awk ‘{print $5}’ | awk -F: ‘{print $1}’ | sort | uniq -c | sort -nr | more
```

6.根据端口列进程
```
netstat -ntlp | grep 80 | awk ‘{print $7}’ | cut -d/ -f1
```

网站日志分析篇1（Apache）：

1.获得访问前10位的ip地址
```
cat access.log|awk ‘{print $1}’|sort|uniq -c|sort -nr|head -10
cat access.log|awk ‘{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}’
```

2.访问次数最多的文件或页面,取前20
```
cat access.log|awk ‘{print $11}’|sort|uniq -c|sort -nr|head -20
```

3.列出传输最大的几个exe文件（分析下载站的时候常用）
```
cat access.log |awk ‘($7~/.exe/){print $10 " " $1 " " $4 " " $7}’|sort -nr|head -20
```

4.列出输出大于200000byte(约200kb)的exe文件以及对应文件发生次数
```
cat access.log |awk ‘($10 > 200000 && $7~/.exe/){print $7}’|sort -n|uniq -c|sort -nr|head -100
```

5.如果日志最后一列记录的是页面文件传输时间，则有列出到客户端最耗时的页面
```
cat access.log |awk ‘($7~/.php/){print $NF " " $1 " " $4 " " $7}’|sort -nr|head -100
```

6.列出最最耗时的页面(超过60秒的)的以及对应页面发生次数
```
cat access.log |awk ‘($NF > 60 && $7~/.php/){print $7}’|sort -n|uniq -c|sort -nr|head -100
```

7.列出传输时间超过 30 秒的文件
```
cat access.log |awk ‘($NF > 30){print $7}’|sort -n|uniq -c|sort -nr|head -20
```

8.统计网站流量（G)
```
cat access.log |awk ‘{sum+=$10} END {print sum/1024/1024/1024}’
```

9.统计404的连接
```
awk ‘($9 ~/404/)’ access.log | awk ‘{print $9,$7}’ | sort
```

10. 统计http status
```
cat access.log |awk ‘{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}'
cat access.log |awk '{print $9}'|sort|uniq -c|sort -rn
```

11.蜘蛛分析，查看是哪些蜘蛛在抓取内容。
```
/usr/sbin/tcpdump -i eth0 -l -s 0 -w - dst port 80 | strings | grep -i user-agent | grep -i -E 'bot|crawler|slurp|spider'
```

网站日分析2(Squid篇）按域统计流量
```
zcat squid_access.log.tar.gz| awk '{print $10,$7}' |awk 'BEGIN{FS="[ /]"}{trfc[$4]+=$1}END{for(domain in trfc){printf "%st%dn",domain,trfc[domain]}}'
```

https://mp.weixin.qq.com/s?__biz=MzAwNTM5Njk3Mw==&mid=2247486759&idx=1&sn=72fc2dfe7422f7e9caa6b583173f27d5&chksm=9b1c0da5ac6b84b356ac960bc12a75c8c4d8cadcec6cc40c0d9008d3783b93e4f53c6db4105a&mpshare=1&scene=23&srcid=#rd


https://blog.51cto.com/qiangsh/1844629

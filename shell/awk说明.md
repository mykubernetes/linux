# Awk 说明

## 命令选项
- （1）-F fs or --field-separator fs ：指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:。
- （2）-v var=value or --asign var=value ：赋值一个用户定义变量。
- （3）-f scripfile or --file scriptfile ：从脚本文件中读取awk命令。
- （4）-mf nnn and -mr nnn ：对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。
- （5）-W compact or --compat, -W traditional or --traditional ：在兼容模式下运行awk。所以gawk的行为和标准的awk完全一样，所有的awk扩展都被忽略。
- （6）-W copyleft or --copyleft, -W copyright or --copyright ：打印简短的版权信息。
- （7）-W help or --help, -W usage or --usage ：打印全部awk选项和每个选项的简短说明。
- （8）-W lint or --lint ：打印不能向传统unix平台移植的结构的警告。
- （9）-W lint-old or --lint-old ：打印关于不能向传统unix平台移植的结构的警告。
- （10）-W posix ：打开兼容模式。但有以下限制，不识别：/x、函数关键字、func、换码序列以及当fs是一个空格时，将新行作为一个域分隔符；操作符**和**=不能代替^和^=；fflush无效。
- （11）-W re-interval or --re-inerval ：允许间隔正则表达式的使用，参考(grep中的Posix字符类)，如括号表达式[[:alpha:]]。
- （12）-W source program-text or --source program-text ：使用program-text作为源代码，可与-f命令混用。
- （13）-W version or --version ：打印bug报告信息的版本。


## awk的环境变量

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

## 六. awk运算符

| 运算符 | 描述 |
| `= += -= *= /= %= ^= **=` | 赋值 |
| ?: | C条件表达式 |
| ~ ~! | 匹配正则表达式和不匹配正则表达式 |
| < <= > >= != == | 关系运算符 |
| 空格 | 连接 |
| + - | 加，减 |
| * / & | 乘，除与求余 |
| + - ! | 一元加，减和逻辑非 |
| ^ *** | 求幂 |
| ++ -- | 增加或减少，作为前缀或后缀 |
| $ | 字段引用 |
| in | 数组成员 |


## 匹配操作符(~)

用来在记录或者域内匹配正则表达式。如$ awk '$1 ~/^root/' test将显示test文件第一列中以root开头的行。

## 比较表达式

`conditional expression1 ? expression2: expression3，`

例如：
```
$ awk '{max = {$1 > $3} ? $1: $3: print max}' test。如果第一个域大于第三个域，$1就赋值给max，否则$3就赋值给max。
$ awk '$1 + $2 < 100' test。如果第一和第二个域相加大于100，则打印这些行。
$ awk '$1 > 5 && $2 < 10' test,如果第一个域大于5，并且第二个域小于10，则打印这些行。
```

## 范围模板

范围模板匹配从第一个模板的第一次出现到第二个模板的第一次出现之间所有行。如果有一个模板没出现，则匹配到开头或末尾。如$ awk '/root/,/mysql/' test将显示root第一次出现到mysql第一次出现之间的所有行。

## 示例

### 1.  入门实例

1.1 显示最近登录的5个帐号:
```
# last -n 5 | awk '{print $1}'
root
root
root
dmtsai
root
```

1.2 如果只是显示/etc/passwd的账户:
```
# cat /etc/passwd |awk -F ':' '{print $1}'
root
daemon
bin
sys
```

1.3 如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以tab键分割:
```
# cat /etc/passwd |awk -F ':' '{print $1"\t"$7}'
root /bin/bash
daemon /bin/sh
bin /bin/sh
sys /bin/sh
```

1.4 如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以逗号分割,而且在所有行添加列名name,shell,在最后一行添加"blue,/bin/nosh":
```
# cat /etc/passwd |awk -F ':' 'BEGIN {print "name,shell"} {print $1","$7} END {print "blue,/bin/nosh"}'
name,shell
root,/bin/bash
daemon,/bin/sh
bin,/bin/sh
sys,/bin/sh
....
blue,/bin/nosh
```

1.5 搜索/etc/passwd有root关键字的所有行:
```
# awk -F: '/root/' /etc/passwd
root:x:0:0:root:/root:/bin/bash
```
这种是pattern的使用示例，匹配了pattern(这里是root)的行才会执行action(没有指定action，默认输出每行的内容)。

搜索支持正则，例如找root开头的: awk -F: '/^root/' /etc/passwd

1.6 搜索/etc/passwd有root关键字的所有行，并显示对应的shell
```
# awk -F: '/root/{print $7}' /etc/passwd
/bin/bash
```

1.7 其他小示例:
```
$ awk '/^(no|so)/' test                              # 打印所有以模式no或so开头的行。
$ awk '/^[ns]/{print $1}' test                       # 如果记录以n或s开头，就打印这个记录。
$ awk '$1 ~/[0-9][0-9]$/(print $1}' test             # 如果第一个域以两个数字结束就打印这个记录。
$ awk '$1 == 100 || $2 < 50' test                    # 如果第一个或等于100或者第二个域小于50，则打印该行。
$ awk '$1 != 10' test                                # 如果第一个域不等于10就打印该行。
$ awk '/test/{print $1 + 10}' test                   # 如果记录包含正则表达式test，则第一个域加10并打印出来。
$ awk '{print ($1 > 5 ? "ok "$1: "error"$1)}' test   # 如果第一个域大于5则打印问号后面的表达式值，否则打印冒号后面的表达式值。
$ awk '/^root/,/^mysql/' test                        # 打印以正则表达式root开头的记录到以正则表达式mysql开头的记录范围内的所有记录。如果找到一个新的正则表达式root开头的记录，则继续打印直到下一个以正则表达式mysql开头的记录为止，或到文件末尾。
```

### 2. awk内置变量示例

统计/etc/passwd:文件名，每行的行号，每行的列数，对应的完整行内容:
```
# awk -F ':' '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF ",linecontent:"$0}' /etc/passwd
filename:/etc/passwd,linenumber:1,columns:7,linecontent:root:x:0:0:root:/root:/bin/bash
filename:/etc/passwd,linenumber:2,columns:7,linecontent:daemon:x:1:1:daemon:/usr/sbin:/bin/sh
filename:/etc/passwd,linenumber:3,columns:7,linecontent:bin:x:2:2:bin:/bin:/bin/sh
filename:/etc/passwd,linenumber:4,columns:7,linecontent:sys:x:3:3:sys:/dev:/bin/sh
```

使用printf替代print,可以让代码更加简洁，易读
```
# awk -F ':' '{printf("filename:%10s,linenumber:%s,columns:%s,linecontent:%s\n",FILENAME,NR,NF,$0)}' /etc/passwd
```

awk中同时提供了print和printf两种打印输出的函数。

其中print函数的参数可以是变量、数值或者字符串。字符串必须用双引号引用，参数用逗号分隔。如果没有逗号，参数就串联在一起而无法区分。这里，逗号的作用与输出文件的分隔符的作用是一样的，只是后者是空格而已。

printf函数，其用法和c语言中printf基本相似,可以格式化字符串,输出复杂时，printf更加好用，代码更易懂。

## 3. awk自定义变量

3.1. 下面统计/etc/passwd的账户人数:
```
# awk '{count++;print $0;} END{print "user count is ", count}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
......
user count is  40
```
count是自定义变量。之前的action{}里都是只有一个print,其实print只是一个语句，而action{}可以有多个语句，以;号隔开。

3.2. 这里没有初始化count，虽然默认是0，但是妥当的做法还是初始化为0:
```
# awk 'BEGIN {count=0;print "[start]user count is ", count} {count=count+1;print $0;} END{print "[end]user count is ", count}' /etc/passwd
[start]user count is 0 root:x:0:0:root:/root:/bin/bash
...
[end]user count is 40
```

3.3. 统计某个文件夹下的文件占用的字节数:
```
# ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size}'
[end]size is  8657198
```

3.4 如果以M为单位显示:
```
# ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size/1024/1024,"M"}'
[end]size is  8.25889 M
```
注意，统计不包括文件夹的子目录。

## 4. 条件语句

统计某个文件夹下的文件占用的字节数,过滤4096大小的文件(一般都是文件夹):
```
# ls -l |awk 'BEGIN {size=0;print "[start]size is ", size} {if($5!=4096){size=size+$5;}} END{print "[end]size is ", size/1024/1024,"M"}'
[start]size is  0
[end]size is  8.22339 M
```

## 5. 循环语句

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

## awk变量

awk内置变量之记录变量：
```
FS: field separator，读取文件本时，所使用字段分隔符；
RS: Record separator，输入文本信息所使用的换行符；
OFS: Output Filed Separator: 输出分割符
ORS：Output Row Separator：输出行分割符
awk -F: F指定输入分割符
OFS=”#” 指定输出分割符
```

例：
```
[root@localhost ~]# awk 'BEGIN {OFS="#"} {print $1,$2}' test.txt
this#is
```

awk内置变量之数据变量：
```
NR: The number of input records，awk命令所处理的记录数；如果有多个文件，这个数目会把处理的多个文件中行统一计数；
NF：Number of Field，当前记录的field个数； 当前行的字段总数
FNR: 与NR不同的是，FNR用于记录正处理的行是当前这一文件中被总共处理的行数； awk可能处理多个文件，各自文件计数
ARGV: 数组，保存命令行本身这个字符串，如awk ‘{print $0}’ a.txt b.txt这个命令中，ARGV[0]保存awk，ARGV[1]保存a.txt；
ARGC: awk命令的参数的个数；
FILENAME: awk命令所处理的文件的名称；
ENVIRON：当前shell环境变量及其值的关联数组；
```

如：
```
[root@sta ~]# awk 'BEGIN{print ENVIRON["PATH"]}'
/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin:/root/bin:/usr/lib64
```

用户自定义变量

gawk允许用户自定义自己的变量以便在程序代码中使用，变量名命名规则与大多数编程语言相同，只能使用字母、数字和下划线，且不能以数字开头。gawk变量名称区分字符大小写。

1 在脚本中赋值变量

在gawk中给变量赋值使用赋值语句进行，例如：
```
[root@localhost ~]# awk ' BEGIN {test="hello" ;print test }'
hello
```

2 在命令行中使用赋值变量

gawk命令也可以在“脚本”外为变量赋值，并在脚本中进行引用。例如，上述的例子还可以改写为：
```
[root@localhost ~]# awk -v test="hello" ' BEGIN {print test }'
hello
```

## 输出重定向
```
print items > output-file
print items >> output-file
print items | command
```

特殊文件描述符：
```
/dev/stdin：标准输入
/dev/sdtout: 标准输出
/dev/stderr: 错误输出
/dev/fd/N: 某特定文件描述符，如/dev/stdin就相当于/dev/fd/0；
```
例子：
```
[root@sta ~]# awk -F: '{printf "%-15s %i\n",$1,$3 > "/dev/stderr" }' /etc/passwd
```

## awk的操作符：

例：
```
# awk -F: '$3>=500 {print $1,$3}' /etc/passwd
feiyu 500

# awk -F: '$7~"bash$" {print $1,$7}' /etc/passwd      #shell为bash的
root /bin/bash
feiyu /bin/bash

# awk -F: '$7!~"bash$" {print $1,$7}' /etc/passwd |head -n 3
bin /sbin/nologin
daemon /sbin/nologin
adm /sbin/nologin

# awk -F: '$3==0,$7~"nologin" {print $1,$3,$7}' /etc/passw     d #范围匹配
root 0 /bin/bash
bin 1 /sbin/nologin
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

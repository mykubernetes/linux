# linux awk 内置函数实例

## 一、算术函数

以下算术函数执行与 C 语言中名称相同的子例程相同的操作：

| 函数名 | 说明 |
|-------|------|
| atan2( y, x )	| 返回 y/x 的反正切。 |
| cos( x )	| 返回 x 的余弦；x 是弧度。 |
| sin( x )	| 返回 x 的正弦；x 是弧度。 |
| exp( x )	| 返回 x 幂函数。 |
| log( x )	| 返回 x 的自然对数。 |
| sqrt( x )	| 返回 x 平方根。 |
| int( x )	| 返回 x 的截断至整数的值。 |
| rand( )	| 返回任意数字 n，其中 0 <= n < 1。 |
| srand( [Expr] )	| 将 rand 函数的种子值设置为 Expr 参数的值，或如果省略 Expr 参数则使用某天的时间。返回先前的种子值。 |

### 示例：
```
awk 'BEGIN{OFMT="%.3f"; fs=sin(3.14/2); fe=exp(1); fl=log(exp(2)); fi=int(3.1415); fq=sqrt(100); print fs, fe, fl, fi, fq;}' 
结果：
1.000   2.718   2   3   10            # sin(3.14/2) = 1.000;        exp(1) = 2.718;          log(exp(2)) = 2;           int(3.1415) = 3;        sqrt(100) = 10
```
 

随机数：
```
awk 'BEGIN{srand(); fr=int(100*rand()); print fr;}'
结果：
64
9
25
```
 
## 二、字符串函数

| 函数 | 说明 |
|------|------|
| gsub( Ere, Repl, [ In ] ) | 除了正则表达式所有具体值被替代这点，它和 sub 函数完全一样地执行。 |
| sub( Ere, Repl, [ In ] ) | 用 Repl 参数指定的字符串替换 In 参数指定的字符串中的由 Ere 参数指定的扩展正则表达式的第一个具体值。sub 函数返回替换的数量。出现在 Repl 参数指定的字符串中的 &（和符号）由 In 参数指定的与 Ere 参数的指定的扩展正则表达式匹配的字符串替换。如果未指定 In 参数，缺省值是整个记录（$0 记录变量）。 |
| index( String1, String2 ) | 在由 String1 参数指定的字符串（其中有出现 String2 指定的参数）中，返回位置，从 1 开始编号。如果 String2 参数不在 String1 参数中出现，则返回 0（零）。 |
| length [(String)] | 返回 String 参数指定的字符串的长度（字符形式）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。 |
| blength [(String)] | 返回 String 参数指定的字符串的长度（以字节为单位）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。 |
| substr( String, M, [ N ] ) | 返回具有 N 参数指定的字符数量子串。子串从 String 参数指定的字符串取得，其字符以 M 参数指定的位置开始。M 参数指定为将 String 参数中的第一个字符作为编号 1。如果未指定 N 参数，则子串的长度将是 M 参数指定的位置到 String 参数的末尾 的长度。 |
| match( String, Ere ) | 在 String 参数指定的字符串（Ere 参数指定的扩展正则表达式出现在其中）中返回位置（字符形式），从 1 开始编号，或如果 Ere 参数不出现，则返回 0（零）。RSTART 特殊变量设置为返回值。RLENGTH 特殊变量设置为匹配的字符串的长度，或如果未找到任何匹配，则设置为 -1（负一）。 |
| split( String, A, [Ere] ) | 将 String 参数指定的参数分割为数组元素 A[1], A[2], . . ., A[n]，并返回 n 变量的值。此分隔可以通过 Ere 参数指定的扩展正则表达式进行，或用当前字段分隔符（FS 特殊变量）来进行（如果没有给出 Ere 参数）。除非上下文指明特定的元素还应具有一个数字值，否则 A 数组中的元素用字符串值来创建。 |
| tolower( String ) | 返回 String 参数指定的字符串，字符串中每个大写字符将更改为小写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。 |
| toupper( String ) | 返回 String 参数指定的字符串，字符串中每个小写字符将更改为大写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。 |
| sprintf(Format, Expr, Expr, . . . ) | 根据 Format 参数指定的 printf 子例程格式字符串来格式化 Expr 参数指定的表达式并返回最后生成的字符串。 |
 
### 1） sub， gsub使用
```
awk 'BEGIN{info="this is a test in 2013-01-04"; sub(/[0-9]+/, "!", info); print info}'              # sub
结果：
this is a test in !-01-04

awk 'BEGIN{info="this is a test in 2013-01-04"; gsub(/[0-9]+/, "!", info); print info}'            # gsub
结果：
this is a test in !-!-!
```

### 2） index 查找
```
awk 'BEGIN{info="this is a test in 2013-01-04"; print index(info, "test") ? "found" : "no found";}'                   # 匹配 “test” ，打印 “found； 不匹配， 打印 ”not found“
结果：
found             
```

### 3） match 匹配
```
awk 'BEGIN{info="this is a test in 2013-01-04"; print match(info, /[0-9]+/) ? "found" : "no found";}'                # 匹配 数字 ，打印 “found； 不匹配， 打印 ”not found“
结果：
found    
```

### 4） substr 子串
```
awk 'BEGIN{info="this is a test in 2013-01-04"; print substr(info, 4, 10);}'                 # 第4-10字符，起始从1计
结果：
s is a tes
```

### 5） split 分割
```
awk 'BEGIN{info="this is a test in 2013-01-04"; split(info, tA, " "); print "len : " length(tA); for(k in tA) {print k, tA[k];}}'        # 以空格“ ” 分割，打印数组长度，及其各元素
结果：
len : 6
4 test
5 in
6 2013-01-04
1 this
2 is
3 a
```

### 6） printf 格式化输出

格式化字符串格式：

| 格式符 | 说明 |
|--------|------|
| %d | 十进制有符号整数 |
| %u | 十进制无符号整数 |
| %f | 浮点数 |
| %s | 字符串 |
| %c | 单个字符 |
| %p | 指针的值 |
| %e | 指数形式的浮点数 |
| %x | %X 无符号以十六进制表示的整数 |
| %o | 无符号以八进制表示的整数 |
| %g | 自动选择合适的表示法 |
 
其中格式化字符串包括两部分内容: 一部分是正常字符, 这些字符将按原样输出; 另一部分是格式化规定字符, 以"%"开始, 后跟一个或几个规定字符,用来确定输出内容格式。
```
awk 'BEGIN{n1=124.113; n2=-1.224; n3=1.2345; printf("n1 = %.2f, n2 = %.2u, n3 = %.2g, n1 = %X, n1 = %o\n", n1, n2, n3, n1, n1);}'
结果：
n1 = 124.11,   n2 = 18446744073709551615,   n3 = 1.2,   n1 = 7C,   n1 = 174
```

## 三、时间函数

| 函数名 | 说明 |
|-------|------|
| mktime( YYYY MM DD HH MM SS[ DST]) | 生成时间格式 |
| strftime([format [, timestamp]]) | 格式化时间输出，将时间戳转为时间字符串,具体格式，见下表. |
| systime() | 得到时间戳,返回从1970年1月1日开始到当前时间(不计闰年)的整秒数 |

## strftime日期和时间格式说明符

| 格式 | 描述 |
|------|------|
| %a | 星期几的缩写(Sun) |
| %A | 星期几的完整写法(Sunday) |
| %b | 月名的缩写(Oct) |
| %B | 月名的完整写法(October) |
| %c | 本地日期和时间 |
| %d | 十进制日期 |
| %D | 日期 08/20/99 |
| %e | 日期，如果只有一位会补上一个空格 |
| %H | 用十进制表示24小时格式的小时 |
| %I | 用十进制表示12小时格式的小时 |
| %j | 从1月1日起一年中的第几天 |
| %m | 十进制表示的月份 |
| %M | 十进制表示的分钟 |
| %p | 12小时表示法(AM/PM) |
| %S | 十进制表示的秒 |
| %U | 十进制表示的一年中的第几个星期(星期天作为一个星期的开始) |
| %w | 十进制表示的星期几(星期天是0) |
| %W | 十进制表示的一年中的第几个星期(星期一作为一个星期的开始) |
| %x | 重新设置本地日期(08/20/99) |
| %X | 重新设置本地时间(12：00：00) |
| %y | 两位数字表示的年(99) |
| %Y | 当前月份 |
| %Z | 时区(PDT) |
| %% | 百分号(%) |
 

### 示例
```
awk 'BEGIN{tstamp=mktime("2013 01 04 12 12 12"); print strftime("%c", tstamp);}'
结果：
Fri 04 Jan 2013 12:12:12 PM CST

awk 'BEGIN{tstamp1=mktime("2013 01 04 12 12 12"); tstamp2=mktime("2013 02 01 0 0 0"); print tstamp2-tstamp1;}'
结果：
2375268

awk 'BEGIN{tstamp1=mktime("2013 01 04 12 12 12"); tstamp2=systime(); print tstamp2-tstamp1;}'
结果：
33771
```

## 四、 一般函数

| 函数 | 说明 |
|------|------|
| close( Expression ) | 用同一个带字符串值的 Expression 参数来关闭由 print 或 printf 语句打开的或调用 getline 函数打开的文件或管道。如果文件或管道成功关闭，则返回 0；其它情况下返回非零值。如果打算写一个文件，并稍后在同一个程序中读取文件，则 close 语句是必需的。 |
| system(Command ) | 执行 Command 参数指定的命令，并返回退出状态。等同于system 子例程。 |
| Expression | getline [ Variable ] | 从来自 Expression 参数指定的命令的输出中通过管道传送的流中读取一个输入记录，并将该记录的值指定给 Variable 参数指定的变量。如果当前未打开将 Expression 参数的值作为其命令名称的流，则创建流。创建的流等同于调用 popen 子例程，此时 Command 参数取 Expression 参数的值且 Mode 参数设置为一个是 r 的值。只要流保留打开且 Expression 参数求得同一个字符串，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。 |
| getline [ Variable ] < Expression | 从 Expression 参数指定的文件读取输入的下一个记录，并将 Variable 参数指定的变量设置为该记录的值。只要流保留打开且 Expression 参数对同一个字符串求值，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。 |
| getline [ Variable ] | 将 Variable 参数指定的变量设置为从当前输入文件读取的下一个输入记录。如果未指定 Variable 参数，则 $0 记录变量设置为该记录的值，还将设置 NF、NR 和 FNR 特殊变量。 |

### 示例

1） close 用法
```
awk 'BEGIN{while("cat /etc/passwd" | getline) {print $0;}; close("/etc/passwd");}' | head -n10
结果：
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/bin/sh
man:x:6:12:man:/var/cache/man:/bin/sh
lp:x:7:7:lp:/var/spool/lpd:/bin/sh
mail:x:8:8:mail:/var/mail:/bin/sh
news:x:9:9:news:/var/spool/news:/bin/sh
```

2） getline 用法
```
awk 'BEGIN{while(getline < "/etc/passwd"){print $0;}; close("/etc/passwd");}' | head -n10
结果：
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/bin/sh
man:x:6:12:man:/var/cache/man:/bin/sh
lp:x:7:7:lp:/var/spool/lpd:/bin/sh
mail:x:8:8:mail:/var/mail:/bin/sh
news:x:9:9:news:/var/spool/news:/bin/sh

awk 'BEGIN{print "Enter your name:"; getline name; print name;}'
结果：
Enter your name:
root
root
```

3） System 用法
```
awk 'BEGIN{b=system("ls -al"); print b;}'
结果：
total 32
drwxr-xr-x 2 homer homer 4096 2013-01-04 20:27 .
drwxr-xr-x 4 homer homer 4096 2013-01-04 11:35 ..
-rw-r--r-- 1 homer homer 1773 2013-01-04 19:54 2013-01-03_output_top800_title_url.log
-rw-r--r-- 1 homer homer 1773 2013-01-04 19:55 2013-01-04_output_top800_title_url.log
-rwxr-xr-x 1 homer homer  555 2013-01-04 20:23 catline.sh
-rw-r--r-- 1 homer homer   26 2013-01-04 20:27 ret.txt
-rw-r--r-- 1 homer homer   16 2013-01-04 19:58 str2.txt
-rw-r--r-- 1 homer homer   16 2013-01-04 11:15 str.txt
```

awk的数组，一种关联数组（Associative Arrays），下标可以是数字和字符串。因无需对数组名和元素提前声明，也无需指定元素个数 ，所以awk的数组使用非常灵活。
首先介绍下几个awk数组相关的知识点：

<1>建立数组
```
array[index] = value ：数组名array，下标index以及相应的值value。
```

<2>读取数组值
```
{ for (item in array)  print array[item]} # 输出的顺序是随机的
{for(i=1;i<=len;i++)  print array[i]} # Len 是数组的长度
```

<3>多维数组，array[index1,index2,……]：SUBSEP是数组下标分割符，默认为“\034”。可以事先设定SUBSEP，也可以直接在SUBSEP的位置输入你要用的分隔符，如：
```
awk 'BEGIN{SUBSEP=":";array["a","b"]=1;for(i in array) print i}'
a:b
awk 'BEGIN{array["a"":""b"]=1;for(i in array) print i}'
a:b
```
但，有些特殊情况需要避免，如：
```
awk 'BEGIN{
SUBSEP=":"
array["a","b:c"]=1               # 下标为“a:b:c”
array["a:b","c"]=2               #下标同样是“a:b:c”
for (i in array) print i,array[i]}'
a:b:c 2                                 #所以数组元素只有一个。
```

<4>删除数组或数组元素： 使用delete 函数
```
delete array                     #删除整个数组
delete array[item]           # 删除某个数组元素（item）
```

<5> 排序：awk中的asort函数可以实现对数组的值进行排序，不过排序之后的数组下标改为从1到数组的长度。在gawk 3.1.2以后的版本还提供了一个asorti函数，这个函数不是依据关联数组的值，而是依据关联数组的下标排序，即asorti(array)以后，仍会用数字（1到数组长度）来作为下标，但是array的数组值变为排序后的原来的下标，除非你指定另一个参数如:asorti(a,b)。（非常感谢lionfun对asorti的指正和补充）
```
echo 'aa
bb
aa
bb
cc' |\
awk '{a[$0]++}END{l=asorti(a);for(i=1;i<=l;i++)print a[i]}'
aa
bb
cc
echo 'aa
bb
aa
bb
cc' |\
awk '{a[$0]++}END{l=asorti(a,b);for(i=1;i<=l;i++)print b[i],a[b[i]]}'
aa 2
bb 2
cc 1
```


下面说awk数组的实际应用。

1.  除去重复项, 这个不多说, 只给出代码：
```
awk '!a[$0]++' file(s)                   
awk '!($0 in a){a[$0];print}' file(s)   
```
另一种：http://bbs.chinaunix.net/thread-1859344-1-1.html 

2. 计算总数（sum），如：
```
awk  '{name[$0]+=$1};END{for(i in name) print  i, name[i]}'
再举个例子：
echo "aaa 1
aaa 1
ccc 1
aaa 1
bbb 1
ccc 1" |awk '{a[$1]+=$2}END{for(i in a) print i,a[i]}'
aaa 3
bbb 1
ccc 2
```

3. 查看文件差异。
```
cat file1
aaa
bbb
ccc
ddd
cat file2
aaa
eee
ddd
fff
```

<1>  合并file1和file2，除去重复项：
```
awk 'NR==FNR{a[$0]=1;print}   #读取file1，建立数组a，下标为$0，并赋值为1，然后打印
NR>FNR{                   #读取file2
if(!(a[$0])) {print }      #如果file2 的$0不存在于数组a中，即不存在于file1，则打印。
}' file1 file2
aaa
bbb
ccc
ddd
eee
fff
```

<2> 提取文件1中有，但文件2中没有：
```
awk 'NR==FNR{a[$0]=1}           #读取file2，建立数组a，下标为$0，并赋值为1
NR>FNR{                   #读取file1
if(!(a[$0])) {print }      #如果file1 的$0不存在于数组a中，即不存在于file2，则打印。
}' file2 file1
bbb
ccc
```
另：http://bbs.chinaunix.net/viewthr ... &page=1#pid15547885 

4.  排序：
```
echo "a
1
0
b
2
10
8
100" |
awk '{a[$0]=$0} #建立数组a，下标为$0，赋值也为$0
END{
len=asort(a)      #利用asort函数对数组a的值排序，同时获得数组长度len
for(i=1;i<=len;i++) print i "\t"a[i]  #打印
}'
1       0
2       1
3       2
4       8
5       10
6       100
7       a
8       b
```

5.  有序输出：采用（index in array）的方式打印数组值的顺序是随机的，如果要按原序输出，则可以使用下面的方法：http://bbs2.chinaunix.net/viewthread.php?tid=1811279
```
awk '{a[$1]=$2
c[j++]=$1}
END{
for(m=0;m<j;m++)print c[m],a[c[m]]
}'
```

6.  多个文本编辑：这里主要指的是待处理的文本之间的格式上有区别，如分隔符不同，；或是待处理文本需提取的信息的位置不同，如不同的列或行。
<例1>：
```
cat file1
g1.1 2
g2.2 4
g2.1 5
g4.1 3
cat file2
g1.1 2
g1.2 3
g4.1 4
cat file3
g1.2 3
g5.1 3
```

要求输出：
```
g1.1 2 2 -
g1.2 - 3 3
g2.2 4 - -
g2.1 5 - -
g4.1 3 4 -
g5.1 - - 3
```
实现代码如下：
```
awk '{a[ARGIND" "$1]=$2 # ARGIND是当前命令行文件的位置（从0开始），将它和第一列的value作为下标，建立数组a。
       b[$1]   #将第一列的value作为下标，建立数组b，目的是在读完所有文件之后，能得到第一列value的uniqe-list。
        }
END{ 
        for(i in b) { 
                printf i" " 
                for(j=1;j<=ARGIND;j++) printf "%s ", a[j" "i]?a[j" "i]:"-" #此时的ARGIND值为3.
print "" 
                }
        }' file1 file2 file3
```

这里是利用awk的内置变量ARGIND来处理完成对文件的处理。关于ARGIND，ARGV，ARGC的使用，大家可以参考：http://bbs.chinaunix.net/viewthr ... 0335&from=favorites。

当然，我们也可以利用另外一个内置变量FILENAME来完成相同的任务（大家可以先想想怎么写），如下：
```
awk '{a[FILENAME" "$1]=$2;b[$1];c[FILENAME]}END{for(i in b) {printf i" ";for(j in c) printf "%s ", a[j" "i]?a[j" "i]:"-";print""}}' file1 file2 file3
```

<例2>：对上面的数据的格式稍作改动，每个文件的分隔符都一样的情况，但输出要求不变：
```
cat file1
g1.1|2
g2.2|4
g2.1|5
g4.1|3
cat file2
g1.1#2
g1.2#3
g4.1#4
cat file3
g1.2@3
g5.1@3
```
实现代码如下：
```
awk '{a[ARGIND" "$1]=$2
b[$1]
}
END{
for(i in b) {
printf i" "
for(j=2;j<=ARGIND;j+=2) printf "%s ", a[j" "i]?a[j" "i]:"-" # 由于FS的设置也是有对应ARGIND值，所以对ARGIND稍作改动。
print ""
}
}' FS="|" file1 FS="#" file2 FS="@" file3 # 对每个文件分别设置FS的值。
```
因为这个例子的数据比较简单，我们也可以在BEGIN模块中完成对FS值设置，如下：
```
awk 'BEGIN{FS="[|#@]"}{a[ARGIND" "$1]=$2; b[$1]}END{for(i in b) {printf i" ";for(j=1;j<=ARGIND;j++) printf "%s ", a[j" "i]?a[j" "i]:"-"; print ""}}' file1 file2 file3
```
利用FILENAME 同样可以解决问题：
```
awk '
FILENAME=="file1"{FS="|"}    # 设置FS
FILENAME=="file2"{FS="#"}   #设置FS
FILENAME=="file3"{FS="@"}  #设置FS 
# 稍显繁琐，不过一目了然
{$0=$0}                                   #使FS生效。
{a[ARGIND" "$1]=$2; b[$1]}
END{ for(i in b) {printf i" "; for(j=1;j<=ARGIND;j++) printf "%s ", a[j" "i]?a[j" "i]:"-"; print ""}
}' file1 file2 file3
```
推荐一个关于数组处理文件的帖子http://www.chinaunix.net/jh/24/577044.html ，里面有不少例子供大家学习。

7.  文本翻转或移位：二维或多维数组的应用
<例1>：
```
Inputfile
1 2 3 4 5 6
2 3 4 5 6 1
3 4 5 6 1 2
4 5 6 1 2 3
Outputfile
4 3 2 1
5 4 3 2
6 5 4 3
1 6 5 4
2 1 6 5
3 2 1 6
awk '{
     if (max_nf < NF)
          max_nf = NF # 数组第一维的长度
     max_nr = NR      # 数组第二维的长度
     for (x = 1; x <= NF; x++)
          vector[x, NR] = $x #建立数组vector
}
END {
     for (x = 1; x <= max_nf; x++) {
          for (y = max_nr; y >= 1; --y)
               printf("%s ", vector[x, y])
          printf("\n")
     }
}'
```
<例2>：来自http://bbs.chinaunix.net/viewthr ... &page=1#pid13339226

有两个文本a和b，要求输出c文本，合并的规则是按照第一行的headline（按字母顺序）合并文本a和b，空缺按“0”补齐。
```
cat a.txt
a b c d
1 2 9 7
4 5 8 9
5 3 6 1
cat b.txt
a e f d g
9 2 4 7 3
4 3 7 9 4
cat c.txt
a b c d e f g
1 2 9 7 0 0 0
4 5 8 9 0 0 0
5 3 6 1 0 0 0
9 0 0 7 2 4 3
4 0 0 9 3 7 4
```
下面我们来参看并解读下Tim大师的代码：
```
awk '
FNR==1{    #FNR==1，即a和b文本的第一行，这个用的真的很巧妙。
        for(i=1;i<=NF;i++){ 
                b[i]=$i    #读取文本的每个元素存入数组b
                c[$i]++}  #另建立数组c，并统计每个元素的个数
                next          #可以理解为，读取FNR!=1的文本内容。
        }
{k++                                     # 统计除去第一行的文本行数
for(i=1;i<=NF;i++)a[k","b[i]]=$i  #利用一个二维数组来保持每个数字的位置， k，b[i]可以理解为每个数字的坐标。
}
END{
        l=asorti(c)          #利用asorti函数对数组的下标进行排序，并获取数组长度，即输出文件的列数(NF值)
        for(i=1;i<=l;i++)printf c[i]" " # 先打印第一行，相当于headline。
        print ""
        for(i=1;i<=k;i++){
                for(j=1;j<=l;j++)printf a[i","c[j]]?a[i","c[j]]" ":"0 " # 打印二维数组的值。
                print ""}
        }' a.txt b.txt
```

8.  选择性打印：

打印某个关键字前几行，以3行为例：
```
seq 20 |awk '/\<10\>/{for(i=NR-3;i<NR;i++)print a[i%3];exit}{a[NR%3]=$0}'
7
8
9
```
利用NR取余数，建立数组，这是一种非常高效的代码。

9. 通过split函数建立数组：数组的下标为从1开始的数字。
```
split(s, a [, r]) # s：string， a：array name，[,r]：regular expression。
echo 'abcd' |awk '{len=split($0,a,"");for(i=1;i<=len;i++) print "a["i"] = " a[i];print "length = " len}'
a[1] = a
a[2] = b
a[3] = c
a[4] = d
length = 4
```

10． awk数组使用的小技巧和需要避免的用法：

<1> 嵌套数组：
```
awk 'BEGIN{a[1]=3;b[1]=1;print a[b[1]]}'
3
```

<2> 下标设为变量或函数：
```
awk 'BEGIN{s=123;a[substr(s,2)]=substr(s,1,1);for(i in a)print "index : "i"\nvalue : "a[i]}'
index : 23
value : 1
```

<3> 不可以将数组名作为变量使用，否则会报错：
```
awk 'BEGIN{a["1"] = 3; delete a;a=3;print a}'  #即使你已经使用了delete函数。
awk: fatal: attempt to use array `a' in a scalar context
```

<4> 数组的长度：
```
length(array)  
```

<5> match 函数也可以建立数组（你知道么？，版本要求高于gawk 3.1.2）
```
echo "foooobazbarrrrr | 
gawk '{ match($0, /(fo+).+(bar*)/, arr)  #匹配到的部分自动赋值到arr中，下标从1开始
          print arr[1], arr[2]
          print arr[1, "start"], arr[1, "length"]  #二维数组arr[index,＂start＂]值=RSTART
          print arr[2, "start"], arr[2, "length"]  #二维数组arr[index,＂length＂]值=RLENGTH
          }'
foooo barrrrr
1 5
9 7
```

<6>想到过用split清空数组么?
```
awk 'BEGIN{
split("abc",array,"")
print "array[1] = "array[1],"\narray[2] = "array[2],"\narray[3] = "array[3]
split("",array)
print "array[1] = "array[1],"\narray[2] ="array[2],"\narray[3] ="array[3]
}'
array[1] = a
array[2] = b
array[3] = c
array[1] =
array[2] =
array[3] =
```

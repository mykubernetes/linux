awk调用shell命令的两种方法：system与print

- awk中使用的shell命令，有2种方法：

# 一。使用所以system（）

awk程序中我们可以使用system() 函数去调用shell命令

如：awk 'BEGIN{system("echo abc")}' file

echo abc 就会做为“命令行”，由shell来执行，所以我们会得到以下结果：

```
root@ubuntu:~# awk 'BEGIN{system("echo abc")}'
abc
root@ubuntu:~#


root@ubuntu:~# awk 'BEGIN{v1="echo";v2="abc";system(v1" "v2)}'
abc
root@ubuntu:~#


root@ubuntu:~# awk 'BEGIN{v1="echo";v2="abc";system(v1 v2)}'
/bin/sh: echoabc: command not found
root@ubuntu:~#


root@ubuntu:~# awk 'BEGIN{v1=echo;v2=abc;system(v1" "v2)}'
root@ubuntu:~#
```

1、编写user.sql文件,内容如下:
```
张三  1111111111
赵四  2222222222
王五  3333333333
李六  4444444444
田七  5555555555
贴吧  6666666666
敬酒  7777777777
```

2、使用base64进行批量加密
```
[root@stark shell]# cat user.sql |awk '{print $1;system("echo "$2" |base64")}' |xargs -n2
张三 MTExMTExMTExMQo=
赵四 MjIyMjIyMjIyMgo=
王五 MzMzMzMzMzMzMwo=
李六 NDQ0NDQ0NDQ0NAo=
田七 NTU1NTU1NTU1NQo=
贴吧 NjY2NjY2NjY2Ngo=
敬酒 Nzc3Nzc3Nzc3Nwo=
```

3、使用md5sum进行批量加密
```
cat user.sql |awk '{print $1;system("echo "$2" |md5sum |xargs -d -")}' |xargs -n2
张三 b2c5860a03d2c4f1f049a3b2409b39a8
赵四 b8fdaa19d9fad56810253ba652081e67
王五 8a848b6348e182648878711f9aa9713f
李六 7289c6ad35de1b7d3209b6fee0cb62bb
田七 3151c62af8684438cdeb9fddc0e0e99e
贴吧 2c2877a2bc7252d4696b38804c5c5711
敬酒 a7f70fb8e0fcfb90d55017d749355efd
```

从上面的例子，我们简单的分析一下awk是怎样调用system的：

如果system（）括号里面的参数没有加上双引号的话，awk认为它是一个变量，它会从awk的变量里面把它们先置换为常量，然后再回传给shell

如果system（）括号里面的参数有加上双引号的话，那么awk就直接把引号里面的内容回传给shell，作为shell的“命令行”


# 二。使用print cmd | “/bin/bash”
```
root@ubuntu:~# awk 'BEGIN{print "echo","abc"| "/bin/bash"}'
abc
root@ubuntu:~#


root@ubuntu:~# awk 'BEGIN{print "echo","abc",";","echo","123"| "/bin/bash"}'
abc
123
root@ubuntu:~#
```

# 三。总结

无论使用system（）还是print cmd | “/bin/bash”

awk都是新开一个shell，在相应的cmdline参数送回给shell，所以要注意当前shell变量与新开shell变量问题

```
1.1
root@ubuntu:~# abc=12345567890
root@ubuntu:~# awk 'BEGIN{system("echo $abc")}'

root@ubuntu:~#


1.2
root@ubuntu:~# export abc=12345567890
root@ubuntu:~# awk 'BEGIN{system("echo $abc")}'
12345567890
root@ubuntu:~#

2.1
root@ubuntu:~# abc=1234567890
root@ubuntu:~# awk 'BEGIN{print "echo","$abc"| "/bin/bash"}'

root@ubuntu:~#


2.2
root@ubuntu:~# export abc=1234567890
root@ubuntu:~# awk 'BEGIN{print "echo","$abc"| "/bin/bash"}'
1234567890
root@ubuntu:~#
```

以上例子，没有export的话，那些变量都是只存在于当前shell变量中，所以都是echo不出来的 ，

而使用了 export的都是环境变量，所以awk调用新的shell时候，可以echo出来。

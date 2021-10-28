awk调用shell命令的两种方法：system与print
from：http://www.oklinux.cn/html/developer/shell/20070626/31550.html
awk中使用的shell命令，有2种方法：

一。使用所以system（）

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

从上面的例子，我们简单的分析一下awk是怎样调用system的：
如果system（）括号里面的参数没有加上双引号的话，awk认为它是一个变量，它会从awk的变量里面把它们先置换为常量，然后再回传给shell

如果system（）括号里面的参数有加上双引号的话，那么awk就直接把引号里面的内容回传给shell，作为shell的“命令行”



二。使用print cmd | “/bin/bash”
```
root@ubuntu:~# awk 'BEGIN{print "echo","abc"| "/bin/bash"}'
abc
root@ubuntu:~#


root@ubuntu:~# awk 'BEGIN{print "echo","abc",";","echo","123"| "/bin/bash"}'
abc
123
root@ubuntu:~#


三。总结

无论使用system（）还是print cmd | “/bin/bash”
awk都是新开一个shell，在相应的cmdline参数送回给shell，所以要注意当前shell变量与新开shell变量问题

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

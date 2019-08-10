1、当stdin含有特殊字元时候，将其当成一般字符，像/空格等，配合find的-print0  
```
# touch "a b c".txt
# find . -name *.txt -print0 |xargs -0 ls
./a b c.txt
```

2、-a file 从文件中读入作为stdin  
```
# cat > 1.txt <<EOF
aaa bbb ccc ddd
a b 
c d
EOF

# xargs -a 1.txt
aaa bbb ccc ddd a b c d
```  

3、-e flag，注意有时候可能会是-E,flag必须是一个以空格为分隔的标志，当xargs分析含有flag这个标志的时候就停止  
```
# xargs -E 'ddd' -a 1.txt 
aaa bbb ccc

# cat 1.txt |xargs -E ddd
aaa bbb ccc
```  

4、-n 后面加次数，bison命令执行的时候一次用几个参数,默认是所有
```
# cat 1.txt |xargs -n 2
aaa bbb
ccc ddd
a b
c d
```  

5、-i或者-I 需要根据linux的支持，将xargs的选项名称，一般是一行一行赋予给{},可以用{}代替  
```
# touch {1..10}.txt
# find . -name "*.txt" |xargs -I {} cp -v {} /var/tmp
```  

6、-t显示详细过程  
```
# find . -name "*.txt" |xargs -t -I {} cp {}  /var/tmp/
cp ./1.txt /var/tmp/ 
cp ./2.txt /var/tmp/ 
cp ./3.txt /var/tmp/ 
cp ./4.txt /var/tmp/ 
cp ./5.txt /var/tmp/ 
cp ./6.txt /var/tmp/ 
cp ./7.txt /var/tmp/ 
cp ./8.txt /var/tmp/ 
cp ./9.txt /var/tmp/ 
cp ./10.txt /var/tmp/ 
```  

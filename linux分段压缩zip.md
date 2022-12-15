# linux zip分段压缩

## 使用场景
```
现在我们有一个较大的软件包（10G），需要上传到服务器上使用。 但是一般上传是限速的(1-2M)
如果传输到一半时vpn突然掉线了。那岂不是凉凉。
为了最大程度减少断线后的损失。我们这里使用分割（也可以在windows上分段后，去linux上合并解压）
```

## 案例

### 1.准备软件包
```
#可以看到这里的包有2G多,我们将他进行分段
[root@k8s-master01 test]# ls
install_file.zip
 
[root@k8s-master01 test]# du -sh install_file.zip 
2.3G	install_file.zip
```

#### ps 如果没有压缩文件，则手动压缩
```
#语法 
zip  压缩包的名称  要压缩的目录
 
#案例
zip ss.zip core/
```

### 2.压缩
```
zip -s 1024M install_file.zip  --out ziptest
 
#参数含义
-s 1024M         #指定分段的单个文件大小为1G
--out ziptest    #输出的分段文件名称前缀
```

查看
```
#可以看到多出了3个文件
[root@k8s-master01 test]# ll -h
总用量 4.6G
-rw-r--r-- 1 root root 2.3G 11月 26 10:37 install_file.zip
 
-rw-r--r-- 1 root root 1.0G 11月 26 10:49 ziptest.z01
-rw-r--r-- 1 root root 1.0G 11月 26 10:49 ziptest.z02
-rw-r--r-- 1 root root 291M 11月 26 10:50 ziptest.zip
```

### 3 测试合并压缩文件
```
#将原文件清除
mv install_file.zip ..
 
#查看目录
[root@k8s-master01 test]# ls
ziptest.z01  ziptest.z02  ziptest.zip
 
#合并
#这里不用cat了,之前发现如果是大文件cat不好使
zip -F ziptest.zip --out file-large.zip
```

查看
```
#可以看到合并的文件install，然后正常解压即可(unzip 软件包）
[root@k8s-master01 ~]# ll -h
总用量 4.6G
-rw-r--r-- 1 root root 2.3G 11月 26 15:17 file-large.zip
 
-rw-r--r-- 1 root root 1.0G 11月 26 14:43 ziptest.z01
-rw-r--r-- 1 root root 1.0G 11月 26 14:46 ziptest.z02
-rw-r--r-- 1 root root 291M 11月 26 14:51 ziptest.zip
```

### 4. 解压缩
```
unzip file-large.zip 
```

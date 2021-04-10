一、简单说明
===
在实际的使用场景中，我们可能对压缩过的tar包上传到某个服务器或者应用，会涉及超出服务器限制的文件大小。这里我们可以对此文件进行压缩、分片、合并。

二、实际操作
==
1、压缩包分配
这里，我有个7.5G的tar.gz的压缩包，由于上传的服务器的限制，单次只能上传到700M，这里我们对此文件进行分片：
```
[root@yuhaohao test]# ls -alh test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz
-rw-r--r-- 1 root root 7.5G May 18 10:24 test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz

[root@yuhaohao test]# split -b 700M test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz. --verbose
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.aa’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ab’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ac’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ad’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ae’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.af’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ag’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ah’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ai’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.aj’
creating file ‘test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.ak’
```

2、合并

这里我们合并压缩的文件到合并前的目录结构：
```
[root@harbor_reg 1.5.4.1-Debug]# cat test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.a* |tar -zxv 
test-1.5.4.1_patch-1.5.2.1_2020-05-15/
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-hehe-gpu-v1.0.0.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-hehe-v1.0.0.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-gpu-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-g-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
[root@harbor_reg 1.5.4.1-Debug]# ls -alh test-1.5.4.1_patch-1.5.2.1_2020-05-15/
total 18G
drwxr-xr-x 2 root root  284 May 18 10:05 .
drwxr-xr-x 4 root root 4.0K May 18 17:49 ..
-rw------- 1 root root 6.1G May 18 09:59 test-hehe-gpu-v1.0.0.tar
-rw------- 1 root root 2.3G May 18 10:00 test-hehe-v1.0.0.tar
-rw------- 1 root root 516M May 18 10:05 test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
-rw------- 1 root root 2.3G May 18 10:02 test-gpu-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
-rw------- 1 root root 6.1G May 18 10:04 test-g-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
```

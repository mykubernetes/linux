# 一、简单说明

在实际的使用场景中，我们可能对压缩过的tar包上传到某个服务器或者应用，会涉及超出服务器限制的文件大小。这里我们可以对此文件进行压缩、分片、合并。

# 二、用法

split命令格式：
```
split + 参数 + 要分割的文件 + 分割后子文件前缀
```

| 参数 | 解释 |
|------|------|
| -a | 后缀长度，例如-a3表示后缀长度为3 |
| -l | 按照行数将文件分割成多个小文件 |
| -b | 按照字节数将文件分割成多个小文件 |
| -d | 指定后缀编码为数字，默认编码为字母 |

## 2.1、生成测试大文件
```
[root@docker][19:13:12][OK] ~ #head -c 10M < /dev/urandom >cuttingLog
[root@docker][19:13:15][OK] ~ #ll -h
total 10M
-rw-r--r--  1 root root  10M Nov 18 19:13 cuttingLog
```

## 2.2、分割

【1】每100行分成一个文件，后缀为数字，后缀长度为3位，前缀为log.
`split -a3 -l 100 -d cuttingLog log.`

```
[root@docker][19:13:17][OK] ~ #split -a3 -l 100 -d cuttingLog log.
[root@docker][19:15:30][OK] ~ #ll
total 21328
-rw-------. 1 root root     1640 Nov  7 23:43 anaconda-ks.cfg
-rw-r--r--  1 root root 10485760 Nov 18 19:13 cuttingLog
-rw-r--r--  1 root root    23325 Nov 18 19:15 log.000
-rw-r--r--  1 root root    22546 Nov 18 19:15 log.001
-rw-r--r--  1 root root    22925 Nov 18 19:15 log.002
-rw-r--r--  1 root root    27279 Nov 18 19:15 log.003
-rw-r--r--  1 root root    29060 Nov 18 19:15 log.004
-rw-r--r--  1 root root    22118 Nov 18 19:15 log.005
-rw-r--r--  1 root root    25845 Nov 18 19:15 log.006
-rw-r--r--  1 root root    25865 Nov 18 19:15 log.007
-rw-r--r--  1 root root    25474 Nov 18 19:15 log.008
-rw-r--r--  1 root root    22842 Nov 18 19:15 log.009
-rw-r--r--  1 root root    26265 Nov 18 19:15 log.010
...
```

【2】每100行分成一个文件，后缀为字母，后缀长度为3位，前缀为log. 
`split -a3 -l 100 cuttingLog log.`

```
[root@docker][19:16:58][OK] ~ #split -a3 -l 100 cuttingLog log.
[root@docker][19:17:01][OK] ~ #ll
total 21328
-rw-------. 1 root root     1640 Nov  7 23:43 anaconda-ks.cfg
-rw-r--r--  1 root root 10485760 Nov 18 19:13 cuttingLog
-rw-r--r--  1 root root    23325 Nov 18 19:17 log.aaa
-rw-r--r--  1 root root    22546 Nov 18 19:17 log.aab
-rw-r--r--  1 root root    22925 Nov 18 19:17 log.aac
-rw-r--r--  1 root root    27279 Nov 18 19:17 log.aad
-rw-r--r--  1 root root    29060 Nov 18 19:17 log.aae
-rw-r--r--  1 root root    22118 Nov 18 19:17 log.aaf
-rw-r--r--  1 root root    25845 Nov 18 19:17 log.aag
-rw-r--r--  1 root root    25865 Nov 18 19:17 log.aah
-rw-r--r--  1 root root    25474 Nov 18 19:17 log.aai
-rw-r--r--  1 root root    22842 Nov 18 19:17 log.aaj
...
```

 【3】每2M分成一个文件，后缀为字数字，后缀长度为2位，前缀为log.
`split -b 2M -d cuttingLog log.`

```
[root@docker][19:20:26][OK] ~ #split -b 2M -d cuttingLog log.
[root@docker][19:20:29][OK] ~ #ll -h
total 21M
-rw-------. 1 root root 1.7K Nov  7 23:43 anaconda-ks.cfg
-rw-r--r--  1 root root  10M Nov 18 19:13 cuttingLog
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.00
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.01
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.02
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.03
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.04
```
注意：当分割后文件的数量大于后缀能表达的最大文件数时，会报错：`split: output file suffixes exhausted`
例如`split -a1 -b 2048 -d /test/logs.txt /test/logs/log.`这个命令能分割出14个文件，但是使用-a1命令使得后缀只能表示10个文件，所以实际文件数量超出后缀能表达的文件数量，会报错。

## 2.2、合并
```
[root@docker][19:27:03][OK] ~ #cat log.* >cuttingLog_bak
[root@docker][19:27:30][OK] ~ #ll -h
total 31M
-rw-------. 1 root root 1.7K Nov  7 23:43 anaconda-ks.cfg
-rw-r--r--  1 root root  10M Nov 18 19:13 cuttingLog
-rw-r--r--  1 root root  10M Nov 18 19:27 cuttingLog_bak
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.00
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.01
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.02
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.03
-rw-r--r--  1 root root 2.0M Nov 18 19:20 log.04
[root@docker][19:27:32][OK] ~ 
#md5sum cuttingLog*
a583e4c5c9de6618b89aa9fc909cc3c8  cuttingLog
a583e4c5c9de6618b89aa9fc909cc3c8  cuttingLog_bak
```

# 三、实际操作

1、压缩包分配
这里，我有个7.5G的tar.gz的压缩包，由于上传的服务器的限制，单次只能上传到700M，这里我们对此文件进行分片：
```
# ls -alh test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz
-rw-r--r-- 1 root root 7.5G May 18 10:24 test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz

# split -b 700M test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz. --verbose
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
# cat test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar.gz.a* |tar -zxv 
test-1.5.4.1_patch-1.5.2.1_2020-05-15/
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-hehe-gpu-v1.0.0.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-hehe-v1.0.0.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-gpu-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
test-1.5.4.1_patch-1.5.2.1_2020-05-15/test-g-1.5.4.1_patch-1.5.2.1_2020-05-15.tar

# ls -alh test-1.5.4.1_patch-1.5.2.1_2020-05-15/
total 18G
drwxr-xr-x 2 root root  284 May 18 10:05 .
drwxr-xr-x 4 root root 4.0K May 18 17:49 ..
-rw------- 1 root root 6.1G May 18 09:59 test-hehe-gpu-v1.0.0.tar
-rw------- 1 root root 2.3G May 18 10:00 test-hehe-v1.0.0.tar
-rw------- 1 root root 516M May 18 10:05 test-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
-rw------- 1 root root 2.3G May 18 10:02 test-gpu-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
-rw------- 1 root root 6.1G May 18 10:04 test-g-1.5.4.1_patch-1.5.2.1_2020-05-15.tar
```

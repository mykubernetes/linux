
# Linux md5sum 命令

- 经常在网络或设备之间传输文件会遇到一个问题，就是如何确定文件没有在传输过程中损坏。尤其是在网络上这种相对不稳定的环境中更容易出现错误。其实一些网站的文件是有提供MD5值的，我们只需要为下载的文件使用md5sum命令计算校验码然后和网站提供的校验码对比就行，如果md5值一样理论上可以确定这两个文件内容是一样的。同样，不同设备或同一设备上的两个文件，我们也可以对比其md5值来确定它们的内容是否一致。

除了md5sum 还有其他的一些哈希算法也可以对文件进行校验如sha1sum命令使用sha1，用法和md5sum类似。

# MD5

　　MD5即Message-Digest Algorithm 5（信息-摘要算法5），一种被广泛使用的密码散列函数，可以产生出一个128位（16个字符(BYTES)）的散列值（hash value），用于确保信息传输完整一致。是计算机广泛使用的杂凑算法之一（又译摘要算法、哈希算法），主流编程语言普遍已有MD5实现。将数据（如汉字）运算为另一固定长度值，是杂凑算法的基础原理。

MD5被广泛用于加密和解密技术上，它可以说是文件的“数字指纹”。任何一个文件，无论是可执行程序、图像文件、临时文件或者其他任何类型的文件，也不管它体积多大，都有且只有一个独一无二的MD5信息值，并且如果这个文件被修改过，它的MD5值也将随之改变。因此，我们可以通过对比同一文件的MD5值，来校验这个文件是否被“篡改”过。

　　MD5由美国密码学家罗纳德·李维斯特（Ronald Linn Rivest）设计，于1992年公开，用以取代MD4算法。这套算法的程序在 RFC 1321 中被加以规范。

　　将数据（如一段文字）运算变为另一固定长度值，是散列算法的基础原理。

　　1996年后被证实存在弱点，可以被加以破解，对于需要高度安全性的资料，专家一般建议改用其他算法，如SHA-2。2004年，证实MD5算法无法防止碰撞攻击，因此不适用于安全性认证，如SSL公开密钥认证或是数字签名等用途。

# MD5算法具有以下特点：

- 1、压缩性：任意长度的数据，算出的MD5值长度都是固定的。
- 2、容易计算：从原数据计算出MD5值很容易。
- 3、抗修改性：对原数据进行任何改动，哪怕只修改1个字节，所得到的MD5值都有很大区别。
- 4、强抗碰撞：已知原数据和其MD5值，想找到一个具有相同MD5值的数据（即伪造数据）是非常困难的。

从md5的资料可以知道，两个文件的数据就算有一丁点差异，生成的md5码都有很大差别，因此只能用md5码来找完全相同的文件，而不能找相似的文件。对文件进行md5验证的目的除了文件完整性外，也避免由于文件名的更改导致不一样的结果

# md5sum 手册#
```
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　MD5SUM(1)
NAME

　　　md5sum - 计算检验MD5效验码

总览 (SYNOPSIS)
　　　../src/md5sum [OPTION] [FILE]...
　　　../src/md5sum [OPTION] --check [FILE]

描述 (DESCRIPTION)
　　　 显示 或 检验 MD5 效验码. 如果 没有 FILE 或者 FILE 是 - 时, 就从 标准 输入 读入.
-b, --binary      # 以二进制模式读取
-c, --check       # 检验文件的 MD5 值。给定的文件中每一行的内容是 md5sum 的输出结果，即 md5-value  filename（文本输入模式）或 md5-value *filename（二进制输入模式）
--tag             # 创建 BSD 风格的 md5 输出行
-t, --text        # 以文本模式读取（默认）。注意，在 GNU 系统中，-b 与 -t 选项在读取时没有差别。在输出时，文本输入模式在文件名前是两个空格，二进制输入模式在文件名前是一个空格和星号

以下选项只在校验 md5 值时有效
--quiet           #校验成功的文件不打印 OK
--status          #不输出任何校验成功与失败的信息，使用命令返回码来表示是否校验成功，0 成功，非 0 失败
--strict          #遇到非法格式的校验行，命令返回非 0 状态码
-w, --warn        #遇到非法格式的校验行发出告警
```

# 常用示例#
```
### 1）生成文件的 md5 值，以文件 /etc/passwd 为例

[root@ito-yw-host ~]# cp /etc/passwd /etc/passwd.bak
[root@ito-yw-host ~]# md5sum /etc/passwd
fc6a975eb7ac26ddec24e72c95c3c935  /etc/passwd
[root@ito-yw-host ~]# md5sum /etc/passwd.bak 
fc6a975eb7ac26ddec24e72c95c3c935  /etc/passwd.bak
[root@ito-yw-host ~]# echo "123" >> /etc/passwd.bak   
[root@ito-yw-host ~]# md5sum /etc/passwd.bak       
77b8a0e3a67f7aa91320b3436f55bc45  /etc/passwd.bak
```

上面示例中passwd.bak和passwdMD5值一样，说明MD5只与文件内容有关和文件名称无关，只要文件内容不一样，得出来的MD5值完全不一样。就是文件　　　　内容差一个字符不一样，得出的MD5值也完全不一样。

### 2）生成文件的 md5 值到输出文件 passwd.md5
```
[root@ito-yw-host ~]# md5sum /etc/passwd.bak
77b8a0e3a67f7aa91320b3436f55bc45 /etc/passwd.bak
[root@ito-yw-host ~]# md5sum /etc/passwd.bak > passwd.bak.md5
```

### 3）校验文件的 md5 值。使用上面第二步生成的校验行文件。

- -c, --check：从指定文本中读取md5值，然后检测MD5值对应的文件是否完整，这个“指定文本”的格式如下：
```
[root@ito-yw-host ~]# cat passwd.bak.md5
77b8a0e3a67f7aa91320b3436f55bc45  /etc/passwd.bak
```

- 当passwd.bak.md5记录的md5值和实际一致是输出“ok"或”确定“，不一致时输出”FAILED“或”失败“
```
[root@ito-yw-host ~]# md5sum -c passwd.bak.md5
/etc/passwd.bak: 确定
[root@ito-yw-host ~]# echo "1" >> /etc/passwd.bak 
[root@ito-yw-host ~]# md5sum -c passwd.bak.md5    
/etc/passwd.bak: 失败
md5sum: 警告：1 个校验和不匹配
```

### 4）–tag：按照BSD样式输出结果
```
[root@ito-yw-host ~]# md5sum --tag /etc/passwd
MD5 (/etc/passwd) = fc6a975eb7ac26ddec24e72c95c3c935
```

### 5）–quiet：检查MD5值只输出错误信息
```
[root@ito-yw-host ~]# md5sum --quiet -c passwd.bak.md5
/etc/passwd.bak: 失败
md5sum: 警告：1 个校验和不匹配
[root@ito-yw-host ~]# md5sum --quiet -c passwd.md5    ## md5校验ok，没有输出
```

### 6）–status：不打印任何信息，执行结果以状态码形式输出

状态码为0标识校验成功，非 0 失败
```
[root@Centos7.9 ~]# md5sum --status -c passwd.md5        
[root@ito-yw-host ~]# echo $?
0
[root@ito-yw-host ~]# md5sum --status -c passwd.bak.md5       
[root@ito-yw-host ~]# echo $?
1
```

### 7）-w, --warn ：如果检测文本中有，非法的行，不符合md5sum -c需要的格式，则打印出警告信息

不过测试加不加--warn格式不正确时都会有警告信息
```
[root@ito-yw-host ~]# md5sum --warn -c passwd.md5 
/etc/passwd: 确定
[root@ito-yw-host ~]# cat passwd.md5 
fc6a975eb7ac26ddec24e72c95c3c935  /etc/passwd
[root@ito-yw-host ~]# echo "ccccc" >> passwd.md5          
[root@ito-yw-host ~]# cat passwd.md5             
fc6a975eb7ac26ddec24e72c95c3c935  /etc/passwd
ccccc
[root@ito-yw-host ~]# md5sum --warn -c passwd.md5             
/etc/passwd: 确定
md5sum: passwd.md5：2：MD5 的校验和行目格式不适当
md5sum: 警告：1 行的格式不适当
[root@ito-yw-host ~]# md5sum -c passwd.md5        
/etc/passwd: 确定
md5sum: 警告：1 行的格式不适当
```

# Tips

- 1）md5sum 是校验文件内容，与文件名是否相同无关
- 2）md5sum值逐位校验，所以文件越大，校验时间越长
- 3）理论上不同文件md5值可能会相同，但这种概率极低

总结:

通过md5sum来校验生成文件校验码，来发现文件传输（网络传输、复制、本地不同设备间的传输）异常造成的文件内容不一致的情况。

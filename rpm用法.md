LINUX rpm 软件包信息查看
===

rpm简介
---
rpm（英文全拼：redhat package manager） 原本是 Red Hat Linux 发行版专门用来管理 Linux 各项套件的程序，由于它遵循 GPL 规则且功能强大方便，因而广受欢迎。逐渐受到其他发行版的采用。RPM 套件管理方式的出现，让 Linux 易于安装，升级，间接提升了 Linux 的适用度。

1、rpm包安装操作 
```
##安装example.rpm包
# rpm -i example.rpm 

##安装 example.rpm 包并在安装过程中显示正在安装的文件信息
# rpm -iv example.rpm 

##安装 example.rpm 包并在安装过程中显示正在安装的文件信息及安装进度
# rpm -ivh example.rpm 
```
2、rpm包查询操作 
```
##查看tomcat是否被安装
# rpm -qa | grep tomcat

##查看 example.rpm 安装包的信息
# rpm -qip example.rpm

##查看/bin/df文件所在安装包的信息
# rpm -qif /bin/df

##查看/bin/df 文件所在安装包中的各个文件分别被安装到哪个目录下
# rpm -qlf /bin/df
```

语法 参数
---
下面是rpm的基本的语法和选项
```
  1 [root@192 ~]# rpm --help
  2 用法: rpm [选项...]
  3 
  4 查询/验证软件包选项：
  5   -a, --all                        查询/验证所有软件包
  6   -f, --file                       查询/验证文件属于的软件包
  7   -g, --group                      查询/验证组中的软件包
  8   -p, --package                    查询/验证一个软件包
  9   --pkgid                          query/verify package(s) with package identifier
 10   --hdrid                          query/verify package(s) with header identifier
 11   --triggeredby                    query the package(s) triggered by the package
 12   --whatrequires                   query/verify the package(s) which require a dependency
 13   --whatprovides                   查询/验证提供相关依赖的软件包
 14   --nomanifest                     不把非软件包文件作为清单处理
 15 
 16 查询选项（用 -q 或 --query）：
 17   -c, --configfiles                列出所有配置文件
 18   -d, --docfiles                   列出所有程序文档
 19   -L, --licensefiles               list all license files
 20   --dump                           转储基本文件信息
 21   -l, --list                       列出软件包中的文件
 22   --queryformat=QUERYFORMAT        使用这种格式打印信息
 23   -s, --state                      显示列出文件的状态
 24 
 25 验证选项（用 -V 或 --verify）：
 26   --nofiledigest                   不验证文件摘要
 27   --nofiles                        不验证软件包中文件
 28   --nodeps                         不验证包依赖
 29   --noscript                       不执行验证脚本
 30 
 31 安装/升级/擦除选项：
 32   --allfiles                       安装全部文件，包含配置文件，否则配置文件会被跳过。
 33   --allmatches                     移除所有符合 <package> 的软件包(如果 <package> 被指定未多个软件包，常常会导致错误出现)
 34   --badreloc                       对不可重定位的软件包重新分配文件位置
 35   -e, --erase=<package>+           清除 (卸载) 软件包
 36   --excludedocs                    不安装程序文档
 37   --excludepath=<path>             略过以 <path> 开头的文件
 38   --force                          --replacepkgs --replacefiles 的缩写
 39   -F, --freshen=<packagefile>+     如果软件包已经安装，升级软件包
 40   -h, --hash                       软件包安装的时候列出哈希标记 (和 -v 一起使用效果更好)
 41   --ignorearch                     不验证软件包架构
 42   --ignoreos                       不验证软件包操作系统
 43   --ignoresize                     在安装前不检查磁盘空间
 44   -i, --install                    安装软件包
 45   --justdb                         更新数据库，但不修改文件系统
 46   --nodeps                         不验证软件包依赖
 47   --nofiledigest                   不验证文件摘要
 48   --nocontexts                     不安装文件的安全上下文
 49   --noorder                        不对软件包安装重新排序以满足依赖关系
 50   --noscripts                      不执行软件包脚本
 51   --notriggers                     不执行本软件包触发的任何脚本
 52   --nocollections                  请不要执行任何动作集
 53   --oldpackage                     更新到软件包的旧版本(带 --force 自动完成这一功能)
 54   --percent                        安装软件包时打印百分比
 55   --prefix=<dir>                   如果可重定位，便把软件包重定位到 <dir>
 56   --relocate=<old>=<new>           将文件从 <old> 重定位到 <new>
 57   --replacefiles                   忽略软件包之间的冲突的文件
 58   --replacepkgs                    如果软件包已经有了，重新安装软件包
 59   --test                           不真正安装，只是判断下是否能安装
 60   -U, --upgrade=<packagefile>+     升级软件包
 61   --reinstall=<packagefile>+       reinstall package(s)
 62 
 63 所有 rpm 模式和可执行文件的通用选项：
 64   -D, --define=“MACRO EXPR”        定义值为 EXPR 的 MACRO
 65   --undefine=MACRO                 undefine MACRO
 66   -E, --eval=“EXPR”                打印 EXPR 的宏展开
 67   --macros=<FILE:…>                从文件 <FILE:...> 读取宏，不使用默认文件
 68   --noplugins                      don't enable any plugins
 69   --nodigest                       不校验软件包的摘要
 70   --nosignature                    不验证软件包签名
 71   --rcfile=<FILE:…>                从文件 <FILE:...> 读取宏，不使用默认文件
 72   -r, --root=ROOT                  使用 ROOT 作为顶级目录 (default: "/")
 73   --dbpath=DIRECTORY               使用 DIRECTORY 目录中的数据库
 74   --querytags                      显示已知的查询标签
 75   --showrc                         显示最终的 rpmrc 和宏配置
 76   --quiet                          提供更少的详细信息输出
 77   -v, --verbose                    提供更多的详细信息输出
 78   --version                        打印使用的 rpm 版本号
 79 
 80 Options implemented via popt alias/exec:
 81   --scripts                        list install/erase scriptlets from package(s)
 82   --setperms                       set permissions of files in a package
 83   --setugids                       set user/group ownership of files in a package
 84   --setcaps                        set capabilities of files in a package
 85   --restore                        restore file/directory permissions
 86   --conflicts                      list capabilities this package conflicts with
 87   --obsoletes                      list other packages removed by installing this package
 88   --provides                       list capabilities that this package provides
 89   --requires                       list capabilities required by package(s)
 90   --info                           list descriptive information from package(s)
 91   --changelog                      list change logs for this package
 92   --xml                            list metadata in xml
 93   --triggers                       list trigger scriptlets from package(s)
 94   --last                           list package(s) by install time, most recent first
 95   --dupes                          list duplicated packages
 96   --filesbypkg                     list all files from each package
 97   --fileclass                      list file names with classes
 98   --filecolor                      list file names with colors
 99   --fscontext                      list file names with security context from file system
100   --fileprovide                    list file names with provides
101   --filerequire                    list file names with requires
102   --filecaps                       list file names with POSIX1.e capabilities
103 
104 Help options:
105   -?, --help                       Show this help message
106   --usage                          Display brief usage message
```
有时候我们可能需要在安装某些软件包之前查看它的一下基本信息，以使我们对其有个基本了解或判断其安全性确定是否要安装等。如下的这些命令也许会帮到我们，当然首先得有待查看软件的rpm才行。

1、查看一个软件包的用途、版本等信息
---
语法： rpm -qpi file.rpm

举例：
```
[root@192 ~]# rpm -qpi kernel-2.6.32-573.65.2.el6.x86_64.rpm
警告：kernel-2.6.32-573.65.2.el6.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID fd431d51: NOKEY
Name        : kernel
Version     : 2.6.32
Release     : 573.65.2.el6
Architecture: x86_64
Install Date: (not installed)
Group       : System Environment/Kernel
Size        : 134270842
License     : GPLv2
Signature   : RSA/SHA256, 2018年09月20日 星期四 00时07分06秒, Key ID 199e2f91fd431d51
Source RPM  : kernel-2.6.32-573.65.2.el6.src.rpm
Build Date  : 2018年09月19日 星期三 21时49分53秒
Build Host  : x86-029.build.eng.bos.redhat.com
Relocations : (not relocatable)
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
Vendor      : Red Hat, Inc.
URL         : http://www.kernel.org/
Summary     : The Linux kernel
Description :
The kernel package contains the Linux kernel (vmlinuz), the core of any
Linux operating system.  The kernel handles the basic functions
of the operating system: memory allocation, process allocation, device
input and output, etc.
```
 

2、查看一件软件包所包含的文件
---
语法： rpm -qpl   file.rpm

举例：
```
[root@192 ~]# rpm -qpl kernel-2.6.32-573.65.2.el6.x86_64.rpm
/boot/.vmlinuz-2.6.32-573.65.2.el6.x86_64.hmac
/boot/System.map-2.6.32-573.65.2.el6.x86_64
/boot/config-2.6.32-573.65.2.el6.x86_64
/boot/initramfs-2.6.32-573.65.2.el6.x86_64.img
/boot/symvers-2.6.32-573.65.2.el6.x86_64.gz
/boot/vmlinuz-2.6.32-573.65.2.el6.x86_64
/etc/ld.so.conf.d/kernel-2.6.32-573.65.2.el6.x86_64.conf
/lib/modules/2.6.32-573.65.2.el6.x86_64
……略
```

3、查看软件包的文档所在的位置
---
语法： rpm -qpd   file.rpm

举例：
```
[root@192 ~]# rpm -qpd vsftpd-3.0.2-28.el7.x86_64.rpm
警告：vsftpd-3.0.2-28.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID fd431d51: NOKEY
/usr/share/doc/vsftpd-3.0.2/AUDIT
/usr/share/doc/vsftpd-3.0.2/BENCHMARKS
/usr/share/doc/vsftpd-3.0.2/BUGS
/usr/share/doc/vsftpd-3.0.2/COPYING
/usr/share/doc/vsftpd-3.0.2/Changelog
……略
```

4、查看一个软件包的配置文件
--
语法： rpm -qpc   file.rpm

举例：
```
[root@192 ~]# rpm -qpc vsftpd-3.0.2-28.el7.x86_64.rpm
警告：vsftpd-3.0.2-28.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID fd431d51: NOKEY
/etc/logrotate.d/vsftpd
/etc/pam.d/vsftpd
/etc/vsftpd/ftpusers
/etc/vsftpd/user_list
/etc/vsftpd/vsftpd.conf
```

5、查看一个软件包的依赖关系
---
语法： rpm -qpR  file.rpm

举例：
```
[root@192 ~]# rpm -qpR vsftpd-3.0.2-28.el7.x86_64.rpm
警告：vsftpd-3.0.2-28.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID fd431d51: NOKEY
/bin/bash
/bin/sh
/bin/sh
/bin/sh
config(vsftpd) = 3.0.2-28.el7
libc.so.6()(64bit)
libc.so.6(GLIBC_2.14)(64bit)
libc.so.6(GLIBC_2.15)(64bit)
libc.so.6(GLIBC_2.2.5)(64bit)
libc.so.6(GLIBC_2.3)(64bit)
libc.so.6(GLIBC_2.3.4)(64bit)
libc.so.6(GLIBC_2.4)(64bit)
libc.so.6(GLIBC_2.7)(64bit)
libcap.so.2()(64bit)
libcrypto.so.10()(64bit)
libcrypto.so.10(OPENSSL_1.0.1_EC)(64bit)
libcrypto.so.10(libcrypto.so.10)(64bit)
libdl.so.2()(64bit)
libnsl.so.1()(64bit)
libpam.so.0()(64bit)
libpam.so.0(LIBPAM_1.0)(64bit)
libssl.so.10()(64bit)
libssl.so.10(libssl.so.10)(64bit)
libwrap.so.0()(64bit)
logrotate
rpmlib(CompressedFileNames) <= 3.0.4-1
rpmlib(FileDigests) <= 4.6.0-1
rpmlib(PayloadFilesHavePrefix) <= 4.0-1
rtld(GNU_HASH)
rpmlib(PayloadIsXz) <= 5.2-1
```
以上命令可以查看未安装软件包的信息，对于已安装的软件，只需要去掉参数中的字母p就可以了。查看已安装的软件包信息也不需要其rpm包。

 

6、查看某个文件属于哪个rpm包
---
语法： rpm -qf file
```
[root@192 ~]# rpm -qf /usr/bin/iostat
sysstat-10.1.5-19.el7.x86_64
```

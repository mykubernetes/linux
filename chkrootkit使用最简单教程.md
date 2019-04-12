chkrootkit
=========

1、安装  
```
# yum -y install gcc gcc-c++ make wget glibc-static net-tools && wget ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz
# tar zxf chkrootkit.tar.gz
# cd chkrootkit-*
编译
# make sense
```  

2、拷贝命令
```
# cd ..
# cp -r chkrootkit-* /usr/local/chkrootkit
# rm -r chkrootkit-*
#cd /usr/local/chkrootkit/
```  

3、运行
```
# ./chkrootkit -h
Usage: ./chkrootkit [options] [test …]
Options:
-h show this help and exit     -h 显示帮助信息
-V show version information and exit    -V 显示版本信息
-l show available tests and exit   -l 显示测试内容
-d debug   -d   debug模式，显示检测过程的相关命令程序
-q quiet mode    -q 安静模式，只显示有问题的内容
-x expert mode    -x 高级模式，显示所有检测结果
-r dir use dir as the root directory   -r dir 设置指定的目录为根目录
-p dir1:dir2:dirN path for the external commands used by chkrootkit   -p dir1:dir2:dirN 指定chkrootkit检测时使用系统命令的目录
-n skip NFS mounted dirs   -n 跳过NFS连接的目录
```  
当然，如果你把上面的命令写进shell脚本就一键执行就行。  

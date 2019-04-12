安装rkhunter
===========
简介  
Rootkit Hunter  
中文名叫"Rootkit猎手", 它通过执行一系列的测试脚本来确认你的机器是否已经感染rootkits.
安装Rootkit Hunter非常简单, 从网站下载软件包, 解压, 然后以root用户身份运行installer.sh脚本.

二进制可执行文件rkhunter被安装到/usr/local/bin目录, 需要以root身份来运行该程序. 程序运行后, 它主要执行下面一系列的测试:  
1. MD5校验测试, 检测任何文件是否改动.  
2. 检测rootkits使用的二进制和系统工具文件.  
3. 检测特洛伊木马程序的特征码.  
4. 检测大多常用程序的文件异常属性.  
5. 执行一些系统相关的测试 – 因为rootkit hunter可支持多个系统平台.  
6. 扫描任何混杂模式下的接口和后门程序常用的端口.  
7. 检测如/etc/rc.d/目录下的所有配置文件, 日志文件, 任何异常的隐藏文件等等. 例如, 在检测/dev/.udev和/etc/.pwd.lock文件时候, 我的系统被警告.  
8. 对一些使用常用端口的应用程序进行版本测试. 如: Apache Web Server, Procmail等.  


1、更新epel源安装  
```
#rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#yum -y install rkhunter
```  

2、检测
```
# rkhunter -c
```  

3、rkhunter是通过一个含有rootkit名字的数据库来检测系统的rootkits漏洞, 所以经常更新该数据库非常重要, 你可以通过下面命令来更新该数据库:
```
# rkhunter –update
```  

4、在缺省情况下, rkhunter对系统进行已知的一些检测. 但是你也可以通过使用’–scan-knownbad-files’来执行未知的错误检测:
```
# rkhunter -c –scan-knownbad-files
```  

5、每月第一天的下午11:59分执行rkhunter数据库更新工作    
```
59 23 1 * * echo "Rkhunter update check in progress";/usr/local/bin/rkhunter –update
```  

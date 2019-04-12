Clam AntiVirus
============
先安装EPEL源  
```
# rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```  
安装Clam  
```
# yum install -y clamav clamav-updates
```  
更新病毒库  
```
# freshclam 
```  
使用方法：  

1、 全盘扫描：# clamscan -r /  

2、 扫描到病毒后立即删除（慎用）：# clamscan -r / –remove  

3、 扫描到病毒后立即移动到/tmp目录：# clamscan -r / –move=/tmp  

4、 生成扫描日志文件：# clamscan/tmp/1.txt -l /var/log/clamscan.log  

5、 常用选项：  
```
（1） –quiet：只打印错误信息

（2） -i | –infected：只打印被感染的文件

（3） –remove[=yes/no(*)]：移除被感染的文件

（4） –move=DIRECTORY：将被感染的文件移至指定目录

（5） –copy=DIRECTORY：将被感染的文件复制至指定目录

（6） –exclude=REGEX：不扫描与正则表达式匹配的文件

（7） –exclude-dir=REGEX：不扫描与正则表达式匹配的目录

（8） –include=REGEX：只扫描与正则表达式匹配的文件

（9） –include-dir=REGEX：只扫描与正则表达式匹配的目录
```  

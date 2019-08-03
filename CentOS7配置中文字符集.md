1、查看当前字符集  
```
$ echo $LANG
en_US.UTF-8
```  

2、安装字符集  
使用locale命令看看当前系统所使用的字符集  
```
$ locale
LANG=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```  

3、查看系统是否安装中文字符集支持  
```
# locale -a | grep CN
bo_CN
bo_CN.utf8
ug_CN
ug_CN.utf8
zh_CN
zh_CN.gb18030
zh_CN.gb2312
zh_CN.gbk
zh_CN.utf8
```  

4、若没有执行以下命令进行安装  
```
#CentOS6.x：
yum groupinstall chinese-support

#CentOS7.x
yum install -y kde-l10n-Chinese
yum reinstall -y glibc-common

#定义字符集
localedef -c -f UTF-8 -i zh_CN zh_CN.UFT-8
#确认载入成功
locale -a
```  

5、修改系统字符集  
```
修改系统字符集的配置文件
Centos6.x字符集配置文件：/etc/sysconfig/i18n
Centos7.x字符集配置文件：/etc/locale.conf

# echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf
# source /etc/locale.conf
```  

6、临时改变字符集  
```
LANG="<字符集>"
LANG="zh_CN.UTF-8"

#或者把字符集环境变量写到profile
vim /etc/profile
source /etc/profile
```  

7、验证字符集修改  
```
# echo $LANG
zh_CN.UTF-8

# locale
LANG=zh_CN.UTF-8
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="zh_CN.UTF-8"
LC_TIME="zh_CN.UTF-8"
LC_COLLATE="zh_CN.UTF-8"
LC_MONETARY="zh_CN.UTF-8"
LC_MESSAGES="zh_CN.UTF-8"
LC_PAPER="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_ALL=
```  

8、修改ssh终端字符集  
如果按照以上方法设置修改设置中文语言还是不行，注意SSH终端选择的编码，如xshell为例，把终端的编码选择中文，或者UTF8即可。  
如果系统界面依然出现乱码，再安装以下包   
```
yum groupinstall "fonts" -y

如果还是乱码，进入fonts安装路径执行以下命令
# cd /usr/share/fonts/
# fc-cache -fv
```  

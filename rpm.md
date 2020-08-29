1、rpm包安装操作 
```
##安装example.rpm包； 
# rpm -i example.rpm 

##安装 example.rpm 包并在安装过程中显示正在安装的文件信息； 
# rpm -iv example.rpm 

##安装 example.rpm 包并在安装过程中显示正在安装的文件信息及安装进度； 
# rpm -ivh example.rpm 
```
2、rpm包查询操作 
```
##查看tomcat4是否被安装； 
# rpm -qa | grep tomcat4

##查看 example.rpm 安装包的信息； 
# rpm -qip example.rpm

##查看/bin/df文件所在安装包的信息；
# rpm -qif /bin/df

##查看/bin/df 文件所在安装包中的各个文件分别被安装到哪个目录下；  
# rpm -qlf /bin/df
```

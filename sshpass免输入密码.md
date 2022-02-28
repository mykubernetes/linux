# sshpass安装
```
1.在基于 RedHat/CentOS 的系统中，首先需要启用 EPEL 仓库并使用 yum 命令安装它。
# yum install sshpass
2.在 Debian/Ubuntu 和它的衍生版中，你可以使用 apt-get 命令来安装。
$ sudo apt-get install sshpass
3.mac环境
brew install sshpass
4.另外，你也可以从最新的源码安装 sshpass，首先下载源码并从 tar 文件中解压出内容：
$ wget http://sourceforge.net/projects/sshpass/files/latest/download -O sshpass.tar.gz
$ tar -xvf sshpass.tar.gz
$ cd sshpass-1.06
$ ./configure
# sudo make install 
```

# sshpass使用案例
```
# 免密码登录
$ sshpass -p password ssh username@host

# 远程执行命令
$ sshpass -p password ssh username@host <cmd>

# 通过scp上传文件
$ sshpass -p password scp local_file root@host:remote_file 

# 通过scp下载文件
$ sshpass -p password scp root@host:remote_file local_file
```

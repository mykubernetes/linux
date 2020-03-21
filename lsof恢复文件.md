lsof常用参数
---

lsof 如果不加任何参数，就会打开所有被打开的文件，建议加上一下参数来具体定位  
lsof -i 列出所有网络连接  
lsof -i tcp 列出所有tcp连接信息  
lsof -i udp 列出所有udp连接信息  
lsof -i :3306 列出谁在使用某端口  
lsof abc.txt 显示开启文件abc.txt的进程 (谁在使用某个文件)  
lsof -u username 列出某用户打开的文件  
lsof -c abc 显示abc进程现在打开的文件  
lsof -c -p 1234 列出进程号为1234的进程所打开的文件  
lsof -g gid 显示归属gid的进程情况  
lsof +d /usr/local/ 显示目录下被进程开启的文件  
lsof +D /usr/local/ 同上，但是会搜索目录下的目录，时间较长 lsof -d 4 显示使用fd为4的进程  
lsof -i 用以显示符合条件的进程情况  



文件被删除，但是进程还在的文件可以被恢复
```
查看被删除的文件进程号为898
# lsof |grep messages
rsyslogd    898          root    3w      REG              253,0   2550332     321471 /var/log/messages
in:imjour   898   901    root    3w      REG              253,0   2550332     321471 /var/log/messages
rs:main     898   902    root    3w      REG              253,0   2550332     321471 /var/log/messages

发现3为该进程打开的文件
# ll /proc/898/fd/
total 0
lr-x------. 1 root root 64 Mar 21 16:08 0 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 1 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 2 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 3 -> /var/log/messages
lr-x------. 1 root root 64 Mar 21 16:08 5 -> /run/log/journal/7135e589c17244f39b4674b10a5b1706/system@10f5e9be86e9455e81545dd4ed8df88c-0000000000000001-0005849f4360648f.journal
l-wx------. 1 root root 64 Mar 21 16:08 6 -> /var/log/cron
l-wx------. 1 root root 64 Mar 21 16:08 7 -> /var/log/secure
l-wx------. 1 root root 64 Mar 21 16:08 8 -> /var/log/maillog
lr-x------. 1 root root 64 Mar 21 16:08 9 -> /run/log/journal/7135e589c17244f39b4674b10a5b1706/system.journal

删除文件
rm -rf /var/log/messages

再次查看，发现3号被标记为删除
# ll /proc/898/fd/
total 0
lr-x------. 1 root root 64 Mar 21 16:08 0 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 1 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 2 -> /dev/null
l-wx------. 1 root root 64 Mar 21 16:08 3 -> /var/log/messages (deleted)
lr-x------. 1 root root 64 Mar 21 16:08 4 -> anon_inode:inotify
lr-x------. 1 root root 64 Mar 21 16:08 5 -> /run/log/journal/7135e589c17244f39b4674b10a5b1706/system@10f5e9be86e9455e81545dd4ed8df88c-0000000000000001-0005849f4360648f.journal
l-wx------. 1 root root 64 Mar 21 16:08 6 -> /var/log/cron
l-wx------. 1 root root 64 Mar 21 16:08 7 -> /var/log/secure
l-wx------. 1 root root 64 Mar 21 16:08 8 -> /var/log/maillog
lr-x------. 1 root root 64 Mar 21 16:08 9 -> /run/log/journal/7135e589c17244f39b4674b10a5b1706/system.journal

恢复被删除的文件
# less /proc/898/fd/3 > /var/log/messages
或者
# cp /proc/898/fd/3 /var/log/messages
```  

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

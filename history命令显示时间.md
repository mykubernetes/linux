history命令显示历史时间
=====================
```
# export HISTTIMEFORMAT="%y-%m-%d %T "
# history
1  18-12-06 15:06:55 ls
2  18-12-06 15:06:57 pwd
3  18-12-06 15:06:59 history
```  

如果想让这个永久生效，将export HISTTIMEFORMAT="%y-%m-%d %T " 这个添加到~/.bashrc文件中。

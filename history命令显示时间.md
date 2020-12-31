history命令显示历史时间
---
1、history命令显示历史时间
```
# export HISTTIMEFORMAT="%y-%m-%d %T "
# history
1  18-12-06 15:06:55 ls
2  18-12-06 15:06:57 pwd
3  18-12-06 15:06:59 history
```  

永久生效
```
# vim /etc/profile
export HISTTIMEFORMAT="%y-%m-%d %T "
或者
export HISTTIMEFORMAT='%F %T '

# source /etc/profile
```

2、可以细化，实现登陆过系统的用户、IP地址、操作命令以及操作时间一一对应
```
# vim /etc/profile
export HISTTIMEFORMAT="%F %T `who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'` `whoami` "

# source /etc/profile
```

```
# history
1 2020-12-12 00:30:17 192.168.18.111 root vim /etc/profile
2 2020-12-12 00:31:21 192.168.18.111 root source /etc/profile
3 2020-12-12 00:32:18 192.168.18.111 root history
```


修改bash源码，支持syslog记录
---

https://github.com/samuelcolvin/bash

```
# wget https://github.com/samuelcolvin/bash/archive/bash-4.4.tar.gz
# tar xvf bash-4.4.tar.gz
# cd bash-bash-4.4

# 修改源码：bashhist.c
# vim bashhist.c
bash_syslog_history (line)             #搜索这个
     const char *line;
{
  char trunc[SYSLOG_MAXLEN];
  static int first = 1;

  if (first)
    {
      openlog (shell_name, OPENLOG_OPTS, SYSLOG_FACILITY);
      first = 0;
    }

  if (strlen(line) < SYSLOG_MAXLEN)
    syslog (SYSLOG_FACILITY|SYSLOG_LEVEL, "HISTORY: PID=%d UID=%d %s User=%s CMD=%s", getpid(), current_user.uid, current_user.user_name line);
  else
    {
      strncpy (trunc, line, SYSLOG_MAXLEN);
      trunc[SYSLOG_MAXLEN - 1] = '\0';
      syslog (SYSLOG_FACILITY|SYSLOG_LEVEL, "HISTORY (TRUNCATED): PID=%d UID=%d %s User=%s CMD=%s", getpid(), current_user.uid, current_user.user_name trunc);
    }
}
#endif


# 修改源码config-top.h，取消/#define SYSLOG_HISTORY/这行的注释
# vim config-top.h
if defined (SYSLOG_HISTORY)
  define SYSLOG_FACILITY LOG_USER
  define SYSLOG_LEVEL LOG_INFO
  define OPENLOG_OPTS LOG_PID
endif


# 编译安装

./configure --prefix=/usr/local/bash
```
- 可以修改/etc/passwd中用户shell环境，也可以用编译好的文件直接替换原有的bash二进制文件，但最好对原文件做好备份

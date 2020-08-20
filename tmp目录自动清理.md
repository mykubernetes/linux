CentOS7下，系统使用systemd管理易变与临时文件，与之相关的系统服务有3个：
```
systemd-tmpfiles-setup.service  ：Create Volatile Files and Directories
systemd-tmpfiles-setup-dev.service：Create static device nodes in /dev
systemd-tmpfiles-clean.service ：Cleanup of Temporary Directories
```
配置文件也有3个地方：
```
/etc/tmpfiles.d/*.conf
/run/tmpfiles.d/*.conf
/usr/lib/tmpfiles.d/*.conf
```
/tmp目录的清理规则主要取决于/usr/lib/tmpfiles.d/tmp.conf文件的设定，默认的配置内容为：
```
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
 
# See tmpfiles.d(5) for details
 
# Clear tmp directories separately, to make them easier to override
v /tmp 1777 root root 7d
v /var/tmp 1777 root root 30d
 
# Exclude namespace mountpoints created with PrivateTmp=yes
x /tmp/systemd-private-%b-*
X /tmp/systemd-private-%b-*/tmp
x /var/tmp/systemd-private-%b-*
X /var/tmp/systemd-private-%b-*/tmp
```
如不想让系统自动清理/tmp下以tomcat开头的目录，那么增加下面这条内容到配置文件中即可：
```
x /tmp/tomcat.*
```

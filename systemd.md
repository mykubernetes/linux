# 一、systemd 简介

- systemd  是 Linux 系统工具，用来启动 守护进程，已成为大多数发行版的标准配置。

历史上，Linux 的启动一直采用init进程。下面的命令用来启动服务。
```
$ /etc/init.d/apache2 start
# 或者
$ service apache2 start
```
这种方法有两个缺点:
- 一是启动时间长。init进程是串行启动，只有前一个进程启动完，才会启动下一个进程。
- 二是启动脚本复杂。init进程只是执行启动脚本，不管其他事情。脚本需要自己处理各种情况，这往往使得脚本变得很长。

Systemd 就是为了解决这些问题而诞生的。它的设计目标是，为系统的启动和管理提供一套完整的解决方案。

根据 Linux 惯例，字母d是守护进程（daemon）的缩写。 Systemd 这个名字的含义，就是它要守护整个系统。

使用了 Systemd，就不需要再用 init了。Systemd 取代了 initd，成为系统的第一个进程（PID 等于 1），其他进程都是它的子进程。
```
$ systemctl --version    //查看 Systemd 的版本。
```

Systemd 的优点是功能强大，使用方便，缺点是体系庞大，非常复杂。事实上，现在还有很多人反对使用 Systemd，理由就是它过于复杂，与操作系统的其他部分强耦合，违反”keep simple, keep stupid”的Unix 哲学

Systemd 并不是一个命令，而是一组命令，涉及到系统管理的方方面面。
```
POST --> Boot Sequence --> Bootloader --> kernel + initramfs(initrd) --> rootfs--> /sbin/init
    init:CentOS 5: SysV init
    CentOS 6: Upstart
    CentOS 7: Systemd
```

配置文件：
- /usr/lib/systemd/system: 每个服务最主要的启动脚本设置，类似于之前的/etc/init.d/
- /run/systemd/system：系统执行过程中所产生的服务脚本，比上面目录优先运行
- /etc/systemd/system：管理员建立的执行脚本，类似于/etc/rc.d/rcN.d/Sxx类的功能，比上面目录优先运行

Unit类型:
- Systemctl –t help 查看unit类型
- Service unit: 文件扩展名为.service, 用于定义系统服务
- Target unit: 文件扩展名为.target，用于模拟实现运行级别
- Device unit: .device, 用于定义内核识别的设备
- Mount unit: .mount, 定义文件系统挂载点
- Socket unit: .socket,用于标识进程间通信用的socket文件，也可在系统启动时，延迟启动服务，实现按需启动
- Scope Unit：不是由 Systemd 启动的外部进程
- Slice Unit：进程组
- Snapshot unit: .snapshot, 管理系统快照
- Swap unit: .swap, 用于标识swap设备
- Automount unit: .automount，文件系统的自动挂载点
- Path unit: .path，用于定义文件系统中的一个文件或目录使用,常用于当文件系统变化时，延迟激活服务，如：spool 目录

# 管理服务
```
管理系统服务：CentOS 7: service unit
注意：能兼容早期的服务脚本
命令：systemctl COMMAND name.service

启动：service name start ==> systemctl start name.service
停止：service name stop ==> systemctl stop name.service
重启：service name restart ==> systemctl restart name.service
状态：service name status ==> systemctl status name.service

条件式重启：已启动才重启，否则不做操作
service name condrestart ==> systemctl try-restart name.service

重载或重启服务：先加载，再启动
systemctl reload-or-restart name.service

重载或条件式重启服务：
systemctl reload-or-try-restart name.service

禁止自动和手动启动：
systemctl mask name.service

取消禁止：
systemctl unmask name.service
```

# 服务查看
```
查看某服务当前激活与否的状态：
systemctl is-active name.service

查看所有已经激活的服务：
systemctl list-units –type|-t service

查看所有服务：
systemctl list-units –type service –all|-a
```

# chkconfig命令的对应关系：
```
设定某服务开机自启：
chkconfig name on ==> systemctl enable name.service

设定某服务开机禁止启动：
chkconfig name off ==> systemctl disable name.service

查看所有服务的开机自启状态：
chkconfig –list ==> systemctl list-unit-files –type service

用来列出该服务在哪些运行级别下启用和禁用
chkconfig sshd–list ==>ls /etc/systemd/system/*.wants/sshd.service

查看服务是否开机自启：
systemctl is-enabled name.service

其它命令：查看服务的依赖关系：
systemctl list-dependencies name.service

杀掉进程：
systemctl kill unitname
```

# 服务状态
```
systemctl list-unit-files --type service --all显示状态
    loaded:Unit:配置文件已处理
    active(running):一次或多次持续处理的运行
    active(exited):成功完成一次性的配置
    active(waiting):运行中，等待一个事件
    inactive:不运行
    enabled:开机启动
    disabled:开机不启动
    static:开机不启动，但可被另一个启用的服务激活
```
> 注意，从配置文件的状态无法看出，该 Unit 是否正在运行。这必须执行前面提到的systemctl status命令。一旦修改配置文件，就要让 SystemD 重新加载配置文件，然后重新启动，否则修改不会生效。

# systemctl 命令示例
```
显示所有单元状态
systemctl或systemctl list-units

只显示服务单元的状态
systemctl –type=service ==>systemctl -t=service

显示sshd服务单元
systemctl –l status sshd.service

验证sshd服务当前是否活动
systemctl is-active sshd

启动，停止和重启sshd服务
systemctl start sshd.service
systemctl stop sshd.service
systemctl restart sshd.service

重新加载配置
systemctl reload sshd.service

列出活动状态的所有服务单元
systemctl list-units –type=service

列出所有服务单元
systemctl list-units –type=service –all

查看服务单元的启用和禁用状态
systemctl list-unit-files –type=service

列出失败的服务
systemctl –failed –type=servicesy

列出依赖的单元
systemctl list-dependencies sshd

验证sshd服务是否开机启动
systemctl is-enabled sshd

禁用network，使之不能自动启动,但手动可以
systemctl disable network

启用network
systemctl enable network

禁用network，使之不能手动或自动启动
systemctl mask network

启用network
systemctl unmask network
```

## systemd-analyze
```
# 查看启动耗时
$ systemd-analyze                                                                                       

# 查看每个服务的启动耗时
$ systemd-analyze blame

# 显示瀑布状的启动过程流
$ systemd-analyze critical-chain

# 显示指定服务的启动流
$ systemd-analyze critical-chain atd.service
```

## hostnamectl查看当前主机的信息。
```
# 显示当前主机的信息
$ hostnamectl

# 设置主机名。
$ hostnamectl set-hostname rhel7
```

## localectl查看本地化设置。
```
# 查看本地化设置
$ localectl

# 设置本地化参数。
$ localectl set-locale LANG=en_GB.utf8
$ localectl set-keymap en_GB  
```

## timedatectl查看当前时区设置。
```
# 查看当前时区设置
$ timedatectl

# 显示所有可用的时区
$ timedatectl list-timezones                                                                                   

# 设置当前时区
$ timedatectl set-timezone America/New_York
$ timedatectl set-time YYYY-MM-DD
$ timedatectl set-time HH:MM:SS
```

## loginctl查看当前登录的用户。
```
# 列出当前session
$ loginctl list-sessions

# 列出当前登录用户
$ loginctl list-users

# 列出显示指定用户的信息
$ loginctl show-user ruanyf
```

# systemd文件介绍

- https://linuxops.org/blog/linux/system_service_config.html
- https://www.freedesktop.org/software/systemd/man/systemd.unit.html

在/usr/lib/systemd/system目录下包含了各种unit文件，有service后缀的服务unit，有target后缀的开机级别unit等。服务又分为系统服务（system）和用户服务（user）。

## service unit文件格式
- /etc/systemd/system：系统管理员和用户使用
- /usr/lib/systemd/system：发行版打包者使用
- 以“#” 开头的行后面的内容会被认为是注释
- 相关布尔值，1、yes、on、true 都是开启，0、no、off、false 都是关闭
- 时间单位默认是秒，所以要用毫秒（ms）分钟（m）等须显式说明
- service unit file文件通常由三部分组成：
  - [Unit]：定义与Unit类型无关的通用选项；用于提供unit的描述信息、unit行为及依赖关系等
  - [Service]：与特定类型相关的专用选项；此处为Service类型
  - [Install]：定义由“systemctlenable”以及”systemctldisable“命令在实现服务启用或禁用时用到的一些选项


- [Unit]段的常用选项
  - Description：描述信息,可以自己定义
  - Documentation：文档地址
  - Requires：依赖到的其它units，强依赖，被依赖的units无法激活时，当前unit也无法激活
  - Wants：依赖到的其它units，弱依赖
  - Conflicts：定义units间的冲突关系
  - Condition…：当前 Unit 运行必须满足的条件，否则不会运行
  - Assert…：当前 Unit 运行必须满足的条件，否则会报启动失败
  - After：定义unit的启动次序，表示当前unit应该晚于哪些unit启动，其功能与Before相反
  - BindsTo：与Requires类似，它指定的 Unit 如果退出，会导致当前 Unit 停止运行
  - Before：如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之后启动

- [Service]段的常用选项
  - type：定义影响ExecStart及相关参数的功能的unit进程启动类型
    - type=simple：默认值，这个daemon主要由ExecStart接的指令串来启动，启动后常驻于内存中
    - type=forking：由ExecStart启动的程序透过spawns延伸出其他子程序来作为此daemon的主要服务。原生父程序在启动结束后就会终止
    - type=oneshot：与simple类似，不过这个程序在工作完毕后就结束了，不会常驻在内存中
    - type=dbus：与simple类似，但这个daemon必须要在取得一个D-Bus的名称后，才会继续运作.因此通常也要同时设定BusNname= 才行
    - type=notify：在启动完成后会发送一个通知消息。还需要配合NotifyAccess 来让Systemd 接收消息
    - type=idle：与simple类似，要执行这个daemon必须要所有的工作都顺利执行完毕后才会执行。这类的daemon通常是开机到最后才执行即可的服务
  - EnvironmentFile：环境环境配置文件，文件中的每一行都是一个环境变量的定义。
  - Environment：为服务添加环境变量。
  - ExecStart：指明启动服务的命令，命令需要绝对路径
  - ExecStop：指明停止unit要运行的命令或脚本(停止当前服务时执行的命令)
  - ExecStartPre：服务ExecStart启动前执行的命令，命令需要绝对路径，可以有多个。(启动当前服务之前执行的命令)
  - ExecStartPost：服务ExecStart启动后执行的命令，命令需要绝对路径，也可以有多个。(启动当前服务之后执行的命令)
  - ExecStopPost：停止服务后执行的命令，命令需要绝对路径，也可以有多个。
  - ExecReload：重启当前服务时执行的命令
  - TimeoutSec：定义 Systemd 停止当前服务之前等待的秒数
  - TimeoutStartSec：启动服务时的等待的秒数，如果超过这个时间服务任然没有执行完所有的启动命令，则 systemd 会认为服务自动失败。
  - TimeoutStopSec：停止服务时的等待的秒数，如果超过这个时间服务仍然没有停止，systemd 会使用 SIGKILL 信号强行杀死服务的进程。
  - RestartSec：自动重启当前服务间隔的秒数
  - Restart：当设定Restart=1 时，则当次daemon服务意外终止后，会再次自动启动此服务(定义何种情况 Systemd 会自动重启当前服务，可能的值包括always（总是重启）、no 、on-success、on-failure、on-abnormal、on-abort、on-watchdog),默认值为 no。
  - User：运行服务的用户
  - Group：指定运行服务的用户组。
  - RestartSec：如果服务需要被重启，这个参数的值为服务被重启前的等待秒数。
  - ExecReload：重新加载服务所需执行的主要命令。
  - Environment：为服务添加环境变量。
  - Nice：服务的进程优先级，值越小优先级越高，默认为0。-20为最高优先级，19为最低优先级。
  - WorkingDirectory：指定服务的工作目录。
  - RootDirectory：指定服务进程的根目录（ / 目录），如果配置了这个参数后，服务将无法访问指定目录以外的任何文件。

- [Install]段的常用选项： `[Install]通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动。它的主要字段如下。`
  - Alias：别名，可使用systemctlcommand Alias.service
  - RequiredBy：被哪些units所依赖，强依赖(它的值是一个或多个 Target，当前 Unit 激活时，符号链接会放入/etc/systemd/system目录下面以 Target 名 + .required后缀构成的子目录中)
  - WantedBy：被哪些units所依赖，弱依赖(它的值是一个或多个 Target，当前 Unit 激活时（enable）符号链接会放入/etc/systemd/system目录下面以 Target 名 + .wants后缀构成的子目录中)
  - Also：安装本服务的时候还要安装别的相关服务


## 服务Unit文件示例：
```
# vim /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server               # 描述服务
After=network.target remote-fs.target nss-lookup.target       # 描述服务类别
[Service]                                                     # 服务运行参数的设置
Type=forking                                                  # 是后台运行的形式
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf  #服务的具体运行命令
ExecReload=/usr/local/nginx/sbin/nginx -s reload              # 重启命令
ExecStop=/usr/local/nginx/sbin/nginx -s stop                  # 停止命令
[Install]
WantedBy=multi-user.target
```
- systemctl daemon-reload
- systemctl start bak
  - 启动计算机的时候，需要启动大量的 Unit。如果每一次启动，都要一一写明本次启动需要哪些 Unit，显然非常不方便。Systemd 的解决方案就是 Target。
  - 简单说，Target 就是一个 Unit 组，包含许多相关的 Unit 。启动某个 Target 的时候，Systemd 就会启动里面所有的 Unit。从这个意义上说，Target 这个概念类似于”状态点”，启动某个 Target 就好比启动到某种状态。
  - 传统的init启动模式里面，有 RunLevel 的概念，跟 Target 的作用很类似。不同的是，RunLevel 是互斥的，不可能多个 RunLevel 同时启动，但是多个 Target 可以同时启动。

## 常用命令
```
systemctl start nginx.service           #启动nginx服务
systemctl enable nginx.service          #设置开机自启动
systemctl disable nginx.service         #停止开机自启动
systemctl status nginx.service          #查看服务当前状态
systemctl restart nginx.service         #重新启动服务
systemctl list-units --type=service     #查看所有已启动的服务
```

# 运行级别
```
 target units：
     unit配置文件：.target
     ls /usr/lib/systemd/system/*.target
     systemctl list-unit-files --type target  --all
 运行级别：
 0  ==> runlevel0.target -> poweroff.target
 1  ==> runlevel1.target -> rescue.target
 2  ==> runlevel2.target -> multi-user.target
 3  ==> runlevel3.target -> multi-user.target
 4  ==> runlevel4.target -> multi-user.target
 5  ==> runlevel5.target -> graphical.target
 6  ==> runlevel6.target -> reboot.target

（1）默认的 RunLevel（在/etc/inittab文件设置）现在被默认的 Target 取代，位置是/etc/systemd/system/default.target，通常符号链接到graphical.target（图形界面）或者multi-user.target（多用户命令行）。

（2）启动脚本的位置，以前是/etc/init.d目录，符号链接到不同的 RunLevel 目录 （比如/etc/rc3.d、/etc/rc5.d等），现在则存放在/lib/systemd/system和/etc/systemd/system目录。

（3）配置文件的位置，以前init进程的配置文件是/etc/inittab，各种服务的配置文件存放在/etc/sysconfig目录。现在的配置文件主要存放在/lib/systemd目录，在/etc/systemd目录里面的修改可以覆盖原始设置。

 查看依赖性：
 systemctl list-dependencies graphical.target

 级别切换：
 initN ==> systemctl isolate name.target
 systemctl isolate multi-user.target
 注：只有/lib/systemd/system/*.target文件中AllowIsolate=yes 才能切换(修改文件需执行systemctl daemon-reload才能生效)

 查看target：
 runlevel;   who -r
 systemctl list-units --type target

 获取默认运行级别：
 /etc/inittab==> systemctl get-default
 修改默认级别：
 /etc/inittab==> systemctl set-default name.target
 systemctl set-default multi-user.target
 ls –l /etc/systemd/system/default.target

 其它命令
 切换至紧急救援模式（单用户状态）：
 systemctl rescue 
 切换至emergency模式： 
 systemctl emergency
 其它常用命令：
 传统命令init，poweroff，halt，reboot都成为systemctl的软链接
 关机：systemctl halt、systemctl poweroff
 重启：systemctl reboot
 挂起：systemctl suspend
 休眠：systemctl hibernate
 休眠并挂起：systemctl hybrid-sleep
```


# journalctl功能强大，用法非常多。
```
# 查看所有日志（默认情况下 ，只保存本次启动的日志）
$ journalctl

# 查看内核日志（不显示应用日志）
$ journalctl -k

# 查看系统本次启动的日志
$ journalctl -b
$ journalctl -b -0

# 查看上一次启动的日志（需更改设置）
$ journalctl -b -1

# 查看指定时间的日志
$ journalctl --since="2012-10-30 18:17:16"
$ journalctl --since "20 min ago"
$ journalctl --since yesterday
$ journalctl --since "2015-01-10" --until "2015-01-11 03:00"
$ journalctl --since 09:00 --until "1 hour ago"

# 显示尾部的最新10行日志
$ journalctl -n

# 显示尾部指定行数的日志
$ journalctl -n 20

# 实时滚动显示最新日志
$ journalctl -f

# 查看指定服务的日志
$ journalctl /usr/lib/systemd/systemd

# 查看指定进程的日志
$ journalctl _PID=1

# 查看某个路径的脚本的日志
$ journalctl /usr/bin/bash

# 查看指定用户的日志
$ journalctl _UID=33 --since today

# 查看某个 Unit 的日志
$ journalctl -u nginx.service
$ journalctl -u nginx.service --since today

# 实时滚动显示某个 Unit 的最新日志
$ journalctl -u nginx.service -f

# 合并显示多个 Unit 的日志
$ journalctl -u nginx.service -u php-fpm.service --since today

# 查看指定优先级（及其以上级别）的日志，共有8级
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug
$ journalctl -p err -b

# 日志默认分页输出，--no-pager 改为正常的标准输出
$ journalctl --no-pager

# 以 JSON 格式（单行）输出
$ journalctl -b -u nginx.service -o json

# 以 JSON 格式（多行）输出，可读性更好
$ journalctl -b -u nginx.serviceqq
-o json-pretty

# 显示日志占据的硬盘空间
$ journalctl --disk-usage

# 指定日志文件占据的最大空间
$ journalctl --vacuum-size=1G

# 指定日志文件保存多久
$ journalctl --vacuum-time=1years
```

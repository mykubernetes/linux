https://linuxops.org/blog/linux/system_service_config.html

在/usr/lib/systemd/system目录下包含了各种unit文件，有service后缀的服务unit，有target后缀的开机级别unit等。服务又分为系统服务（system）和用户服务（user）。

# systemd文件介绍

系统启动和服务器守护进程管理器， 负责在系统启动或运行时，激活系统资源，服务器进程和其它进程

- service文件通常由三部分组成
  - [Unit]：定义与Unit类型无关的通用选项；用于提供unit的描述信息、unit行为及依赖关系等
  - [Service]：与特定类型相关的专用选项；此处为Service类型
  - [Install]：定义由“systemctl enable”以及"systemctl disable“命令在实现服务启用或禁用时用到的一些选项

- Unit介绍
  - Description：描述信息，可以自己定义
  - After：定义unit的启动次序，表示当前unit应该晚于哪些unit启动，其功能与Before相反
  - Requires：依赖到的其它units，强依赖，被依赖的units无法激活时，当前unit也无法激活

- Service介绍
  - Type：服务的类型，常用的有 simple（默认类型） 和 forking。默认的 simple 类型可以适应于绝大多数的场景，因此一般可以忽略这个参数的配置。而如果服务程序启动后会通过 fork 系统调用创建子进程，然后关闭应用程序本身进程的情况，则应该将 Type 的值设置为 forking，否则 systemd 将不会跟踪子进程的行为，而认为服务已经退出。
  - EnvironmentFile：环境环境配置文件，文件中的每一行都是一个环境变量的定义。
  - Environment：为服务添加环境变量。
  - ExecStart：指明启动服务的命令，命令需要绝对路径
  - ExecStop：指明停止服务的命令，命令需要绝对路径
  - ExecStartPre：服务启动前执行的命令，命令需要绝对路径，可以有多个。
  - ExecStartPost：服务启动后执行的命令，命令需要绝对路径，也可以有多个。
  - ExecStopPost：停止服务后执行的命令，命令需要绝对路径，也可以有多个。
  - TimeoutStartSec：启动服务时的等待的秒数，如果超过这个时间服务任然没有执行完所有的启动命令，则 systemd 会认为服务自动失败。
  - TimeoutStopSec：停止服务时的等待的秒数，如果超过这个时间服务仍然没有停止，systemd 会使用 SIGKILL 信号强行杀死服务的进程。
  - Restart：这个值用于指定在什么情况下需要重启服务进程。常用的值有 no，on-success，on-failure，on-abnormal，on-abort 和 always。默认值为 no。
  - User：运行服务的用户
  - Group：指定运行服务的用户组。
  - RestartSec：如果服务需要被重启，这个参数的值为服务被重启前的等待秒数。
  - ExecReload：重新加载服务所需执行的主要命令。
  - Environment：为服务添加环境变量。
  - Nice：服务的进程优先级，值越小优先级越高，默认为0。-20为最高优先级，19为最低优先级。
  - WorkingDirectory：指定服务的工作目录。
  - RootDirectory：指定服务进程的根目录（ / 目录），如果配置了这个参数后，服务将无法访问指定目录以外的任何文件。


1.建立服务文件
```
vim /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
[Install]
WantedBy=multi-user.target
```
- Description:描述服务
- After:描述服务类别
- [Service]服务运行参数的设置
- Type=forking是后台运行的形式
- ExecStart为服务的具体运行命令
- ExecReload为重启命令
- ExecStop为停止命令
- PrivateTmp=True表示给服务分配独立的临时空间

注意：启动、重启、停止命令全部要求使用绝对路径

2.常用命令
```
systemctl start nginx.service           #启动nginx服务
systemctl enable nginx.service          #设置开机自启动
systemctl disable nginx.service         #停止开机自启动
systemctl status nginx.service          #查看服务当前状态
systemctl restart nginx.service         #重新启动服务
systemctl list-units --type=service     #查看所有已启动的服务
```

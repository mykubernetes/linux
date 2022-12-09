crontab 是运维过程中常用的定时任务执行工具

一般情况下在有新的定时任务要执行时，使用crontab -e ，将打开一个vi编辑界面，配置好后保存退出，但是在自动化运维的过程中往往需要使用shell脚本或命令自动添加定时任务。接下来结束三种（Centos）自动添加的crontab 任务的方法：

# 一、添加

## 方法一：

编辑 /var/spool/cron/用户名 文件，如：
```
echo "* * * * * hostname >> /tmp/tmp.txt" >> /var/spool/cron/root
```
- 优点：简单
- 缺点：需要root权限

## 方法二：

编辑 /etc/crontab 文件,
```
echo "* * * * * root hostname >> /tmp/tmp.txt" >> /etc/crontab
```
需要注意的是，与常用的crontab 有点不同，/etc/crontab 需指定用名。而且该文件定义为系统级定时任务 不建议添加非系统类定时任务，编辑该文件也需要root权限

## 方法三：

利用crontab -l 加 crontab file 两个命令实现自动添加
```
crontab -l > conf && echo "* * * * * hostname >> /tmp/tmp.txt" >> conf && crontab conf && rm -f conf
```
由于crontab file会覆盖原有定时任务，所以使用 crontab -l 先导出原有任务到临时文件 “conf” 再追加新定时任务

- 优点：不限用户，任何有crontab权限的用户都能执行
- 缺点：稍微复杂

# 二、删除

crontab -r ：表示删除用户的定时任务，当执行此命令后，所有用户下面的定时任务会被删除

## 一, 删某一项cron任务

方法1(仅适用root,不推荐)
修改/var/spool/cron/root文件

这个方法有以下问题：
1, 只有root用户可以修改,其它用户均没有权限,因为/var/spool/cron这个目录的属主及属组均是root,且目录权限是700, 因此其它用户没有权限进入此目录去修改自己的/var/spool/cron/username文件.

方法2
如果某个用户要删除自己的cron任务, 那么只需要执行
```
crontab -l

crontab -l | grep -v 'config-edit.163.com/config_dir/newsyn' | crontab -

crontab -l | grep -v 'tomcatRoot/jd_product/data/jd_product.txt' | crontab -
```

如果root需要删除某个用户的cron任务, 那么
```
crontab -u USERNAME -l

crontab -u USERNAME -l | grep -v 'config-edit.163.com/config_dir/newsyn'  | crontab -u USERNAME -

crontab -u USERNAME -l | grep -v 'tomcatRoot/jd_product/data/jd_product.txt'  | crontab -u USERNAME -
```

提示: -u参数仅有root可以调用.

也可以这么做
```
crontab -l | grep -v 'config-edit.163.com/config_dir/newsyn' > cron.base
crontab cron.base
```

或者使用脚本：remove_crontab.sh
```
temp_file=`mktemp` 
crontab -l > $temp_file

grep "bash /home/zcy/script/restart.sh" $temp_file > /dev/null 2>&1
if [ "$?" == "0" ];then
    sed -i '/bash \/home1\/zcy\/script\/restart.sh/d' $temp_file
    crontab $temp_file
fi
 
rm $temp_file
```

## 二, 增加一项cron任务
```
#普通用户可以执行
(crontab -l ; echo "*/5 * * * * perl /home/mobman/test.pl") | crontab -
 
#root用户可以执行
(crontab -U USERNAME -l ; echo "*/5 * * * * perl /home/mobman/test.pl") | crontab -u USERNAME -
```

## 三, 删除所有cron任务(清除cron)
```
crontab -r
crontab -r -u USERNAME
```

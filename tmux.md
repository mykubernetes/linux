# 一、安装。
```
yum -y install tmux
```

# 二、简单使用

## 1、新建会话
```
# tmux new -s test -d
```
- 表示新建一个名为 test 的 session，并放在后台运行。

## 2、查看会话
```
# tmux ls
doc: 1 windows (created Sat Dec 29 17:06:45 2018) [186x40]
test: 1 windows (created Sat Dec 29 17:34:12 2018) [186x40]
```

## 3、进入会话
```
# tmux a -t test
```
a 是 attach 的简写

## 4、退出而不关闭

登到某一个会话后，依次按键`Ctrl + b`然后按`d`，这样就会退化该会话，但不会关闭会话。 如果直接`Ctrl + d`，就会在退出会话的通话也关闭了该会话！

## 5、销毁会话。
```
[root@eryajf vhost]$tmux ls
doc: 1 windows (created Sat Dec 29 17:06:45 2018) [186x40]
test: 1 windows (created Sat Dec 29 17:34:12 2018) [160x30]
 
[root@eryajf vhost]$tmux kill-session -t test
 
[root@eryajf vhost]$tmux ls
doc: 1 windows (created Sat Dec 29 17:06:45 2018) [186x40]
```

## 6、重命名会话。
```
# tmux ls
doc: 1 windows (created Sat Dec 29 17:06:45 2018) [186x40]
test: 1 windows (created Sat Dec 29 18:15:24 2018) [160x30]
 
# tmux rename -t test eryajf
 
# tmux ls
doc: 1 windows (created Sat Dec 29 17:06:45 2018) [186x40]
eryajf: 1 windows (created Sat Dec 29 18:15:24 2018) [160x30]
```

## 7、创建会话并执行命令。

此处举一个简单的例子：
```
# tmux new -d -s test && tmux send -t test 'for i in `seq 1000`;do curl 192.168.111.16 && sleep 1;done' ENTER

# tmux ls
test: 1 windows (created Sat Dec 29 18:22:50 2018) [186x40]
```

然后进去看一眼：
```
# tmux a -t test
 
for i in `seq 1000`;do curl 192.168.111.16 && sleep 1;done

# for i in `seq 1000`;do curl 192.168.111.16 && sleep 1;done
{"timestamp":"2018-12-29 18:22:51","status":404,"error":"Not Found","message":"No message available","path":"/"}{"timestamp":"2018-12-29 18:22:52","status":404,"error":"Not Found","message":"No message available","path":"/"}{"timestamp":"2018-12-29 18:22:53","status":404,"error":"Not Found","message":"No message available","path":"/"}{"timestamp":"2018-12-29 18:22:54","status":404,"error":"Not Found","message":"No message available","path":"/"}
```
- 可以看到刚刚的命令还在持续输出当中。


# 三、快捷键汇总

Tmux 窗口有大量的快捷键。所有快捷键都要通过前缀键唤起。默认的前缀键是`Ctrl+b`，即先按下`Ctrl+b`，快捷键才会生效。

举例来说，帮助命令的快捷键是`Ctrl+b ?`。它的用法是，在 Tmux 窗口中，先按下`Ctrl+b`，再按下`?`，就会显示帮助信息。

然后，按下`ESC`键或`q`键，就可以退出帮助。

- 系统指令

| 前缀 | 指令 | 描述 |
|------|-----|-----|
| Ctrl+b | ? | 显示快捷键帮助文档 |
| Ctrl+b | d | 断开当前会话 |
| Ctrl+b | D | 选择要断开的会话 |
| Ctrl+b | Ctrl+z | 挂起当前会话 |
| Ctrl+b | r | 强制重载当前会话 |
| Ctrl+b | s |  显示会话列表用于选择并切换 |
| Ctrl+b | : | 进入命令模式，此时可直接输入ls等命令 |
| Ctrl+b | [ | 进入复制模式，按q退出 |
| Ctrl+b | ] | 粘贴复制模式中复制的文本 |
| Ctrl+b | ~ | 列出信息缓存 |

- 窗口指令

| 前缀 | 指令 | 描述 |
|------|-----|-----|
| Ctrl+b | c | 新建窗口 |
| Ctrl+b | & | 关闭当前窗口（关闭前需输入y or n确认 ） |
| Ctrl+b | 0~9 | 切换到指定窗口 |
| Ctrl+b | p | 切换到上一窗口 |
| Ctrl+b | n | 切换到下一窗口 |
| Ctrl+b | w | 打开窗口列表，用于切换窗口 |
| Ctrl+b | , | 重命名当前窗口 |
| Ctrl+b | . | 修改当前窗口编号（适用于窗口重新排序） |
| Ctrl+b | f | 快速定位到窗口（输入关键字匹配窗口名称） |

- 面板指令

| 前缀 | 指令 | 描述 |
|------|-----|-----|
| Ctrl+b | " | 当前面板上下一分为二，下侧新建面板 |
| Ctrl+b | % | 氮气面板左右一分为二，右侧新建面板 |
| Ctrl+b | x | 关闭氮气面板（关闭前输入y or n确认） |
| Ctrl+b | z | 最大化当前面板，再重复一次按键后恢复正常（1.8版本新增） |
| Ctrl+b | ! | 将当前面板移动到新窗口打开（原窗口中存在两个及以上的面板有效） |
| Ctrl+b | ; | 切换到最后一次使用的面板 |
| Ctrl+b | q | 显示面板编号，在编号消失前输入对应的数字可切换到相应的面板 |
| Ctrl+b | { | 向前置换当前面板 |
| Ctrl+b | } | 向后置换当前面板 |
| Ctrl+b | Ctrl+o | 顺时针旋转当前窗口中的所有面板 |
| Ctrl+b | 方向键 | 移动光标切换面板 |
| Ctrl+b | o | 选择下一面板 |
| Ctrl+b | 空格键 | 在自带的面板布局中循环切换 |
| Ctrl+b | Alt+方向键 | 以5个单元格为单位调整当前面板边缘 |
| Ctrl+b | Ctrl+方向键 | 以1个单元格为单位调整当前面板边缘（Mac下被系统快捷键覆盖） |
| Ctrl+b | t | 显示时钟 |


























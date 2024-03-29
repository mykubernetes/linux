git下载地址  
https://gitforwindows.org/

下载git小乌龟地址,需要先安装git才能安装git小乌龟  
https://tortoisegit.org/download/  

官网：  
https://git-scm.com/book/zh/v2  

# 常用到四个专业名词：
- Workspace：工作区
- Index / Stage：暂存区
- Repository：仓库区（或本地仓库）
- Remote：远程仓库

# 一、新建代码库
```
$ git init                        # 在当前目录新建一个Git代码库
$ git init [project-name]         # 新建一个目录，将其初始化为Git代码库
$ git clone [url]                 # 下载一个项目和它的整个代码历史
```

# 二、配置
> Git的设置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）。
```
$ git config --list               # 显示当前的Git配置
$ git config -e [--global]        # 编辑Git配置文件

# 设置提交代码时的用户信息
$ git config [--global] user.name "[name]"
$ git config [--global] user.email "[email address]"
```

# 三、在暂存区增加/删除文件
```
$ git add [file1] [file2] ...           # 把指定的文件添加到暂存区中
$ git add [dir]                         # 添加指定目录到暂存区，包括子目录
$ git add .                             # 添加当前目录的所有文件到暂存区

# 添加每个变化前，都会要求确认
# 对于同一个文件的多处变化，可以实现分次提交
$ git add -p
$ git rm [file1] [file2] ...               # 删除工作区文件，并且将这次删除放入暂存区
$ git rm --cached [file]                   # 停止追踪指定文件，但该文件会保留在工作区
$ git mv [file-original] [file-renamed]    # 改名文件，并且将这个改名放入暂存区
```

# 四、代码提交
```
$ git commit -m [message]                   # 提交暂存区到仓库区
$ git commit [file1] [file2] ... -m [message]          # 提交暂存区的指定文件到仓库区
$ git commit -a                             # 提交工作区自上次commit之后的变化，直接到仓库区
$ git commit -v                             # 提交时显示所有diff信息

# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
$ git commit --amend -m [message]
$ git commit --amend [file1] [file2] ...    # 重做上一次commit，并包括指定文件的新变化
```

# 五、分支
```
$ git branch                                # 列出所有本地分支
$ git branch -r                             # 列出所有远程分支
$ git branch -a                             # 列出所有本地分支和远程分支
$ git branch -v                             # 列出本地的所有分⽀并显⽰最后⼀次提交，当前所在分⽀以 "*" 标出
$ git branch [branch-name]                  # 新建一个分支，新的分支基于上一次提交建立，但依然停留在当前分支
$ git checkout -b [branch]                  # 新建一个分支，并切换到该分支
$ git branch [branch] [commit]              # 新建一个分支，指向指定commit
$ git branch --track [branch] [remote-branch]     # 新建一个分支，与指定的远程分支建立追踪关系
$ git checkout [branch-name]                # 切换到指定分支，并更新工作区
$ git checkout -                            # 切换到上一个分支
$ git branch --set-upstream [branch] [remote-branch]      # 建立追踪关系，在现有分支与指定的远程分支之间
$ git merge [branch]                        # 合并指定分支到当前分支
$ git cherry-pick [commit ID]               # 把一个已经commit的记录合并进当前分支
$ git branch -d [branch-name]               # 删除分支

# 修改分支名称
$ git branch -m [src-branch-name] [new-branch-name]  # 如果不指定原分支名称则为当前所在分支
$ git branch -M [src-branch-name] [new-branch-name]  # 强制修改分支名称

# 删除远程分支
$ git push origin --delete [branch-name]
$ git branch -dr [remote/branch]            # 删除指定的本地分支
$ git branch -D [branch-name]               # 强制删除指定的本地分支
```

# 六、标签
```
$ git tag                                   # 列出所有tag
$ git tag [tag]                             # 新建一个tag在当前commit
$ git tag [tag] [commit]                    # 新建一个tag在指定commit
$ git tag -d [tag]                          # 删除本地tag
$ git push origin :refs/tags/[tagName]      # 删除远程tag
$ git show [tag]                            # 查看tag信息
$ git push [remote] [tag]                   # 提交指定tag
$ git push [remote] --tags                  # 提交所有tag
$ git checkout -b [branch] [tag]            # 新建一个分支，指向某个tag
```

# 七、查看信息
```
$ git status                                # 显示有变更的文件
$ git log                                   # 显示当前分支的版本历史
$ git log --stat                            # 显示commit历史，以及每次commit发生变更的文件
$ git log -S [keyword]                      # 搜索提交历史，根据关键词
$ git log [tag] HEAD --pretty=format:%s     # 显示某个commit之后的所有变动，每个commit占据一行
$ git log [tag] HEAD --grep feature         # 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件

# 显示某个文件的版本历史，包括文件改名
$ git log --follow [file]
$ git whatchanged [file]

$ git log -p [file]                         # 显示指定文件相关的每一次diff
$ git log -5 --pretty --oneline             # 显示过去5次提交
$ git shortlog -sn                          # 显示所有提交过的用户，按提交次数排序
$ git blame [file]                          # 显示指定文件是什么人在什么时间修改过
$ git diff                                  # 显示暂存区和工作区的差异
$ git diff --cached [file]                  # 显示暂存区和上一个commit的差异
$ git diff HEAD                             # 显示工作区与当前分支最新commit之间的差异
$ git diff [first-branch]...[second-branch]      # 显示两次提交之间的差异
$ git diff --shortstat "@{0 day ago}"       # 显示今天你写了多少行代码
$ git show [commit]                         # 显示某次提交的元数据和内容变化
$ git show --name-only [commit]             # 显示某次提交发生变化的文件
$ git show [commit]:[filename]              # 显示某次提交时，某个文件的内容
$ git reflog                                # 显示当前分支的最近几次提交
```

# 八、远程同步
```
$ git fetch [remote]                       # 下载远程仓库的所有变动
$ git remote -v                            # 显示所有远程仓库
$ git remote show [remote]                 # 显示某个远程仓库的信息
$ git remote add [shortname] [url]         # 增加一个新的远程仓库，并命名
$ git pull [remote] [branch]               # 取回远程仓库的变化，并与本地分支合并
$ git push [remote] [branch]               # 上传本地指定分支到远程仓库
$ git push [remote] --force                # 强行推送当前分支到远程仓库，即使有冲突
$ git push [remote] --all                  # 推送所有分支到远程仓库
```

# 九、撤销
```
$ git checkout [file]                      # 恢复暂存区的指定文件到工作区
$ git checkout [commit] [file]             # 恢复某个commit的指定文件到暂存区和工作区
$ git checkout .                           # 恢复暂存区的所有文件到工作区
$ git reset [file]                         # 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
$ git reset --hard                         # 重置暂存区与工作区，与上一次commit保持一致
$ git reset [commit]                       # 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
$ git reset --hard [commit]                # 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
$ git reset --keep [commit]                # 重置当前HEAD为指定commit，但保持暂存区和工作区不变

# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
$ git revert [commit]

# 暂时将未提交的变化移除，稍后再移入
$ git stash
$ git stash pop
```

# 十、其他
```
$ git archive                               # 生成一个可供发布的压缩包
```

常见操作
```
git config --global user.name "[name]"             #设置全局用户名
git config --global user.email "[email address]"   #设置全局邮箱
git config --global --list   #列出用户全局设置
git add {index.html / .}     #添加指定为文件、目录或当前目录下所有数据到暂存区
git rm --cached [file]       #会直接从暂存区删除文件，工作区则不做出改变
git commit -m '注释信息'     #提交文件到本地仓库
git status                   #查看工作区的状态
git push                     #提交代码到服务器
git pull                     #获取代码到本地
git log                      #查看操作日志
vim .gitignore               #定义忽略文件上传至gitlib
git reset --hard HEAD^^      #git版本回滚，HEAD为当前版本，加一个^为上一个版本，^^为上上一个版本
git reflog                   #获取每次提交的ID,可以使用--hard 根据提交的ID进行版本回退
git reset --hard 5ae4b06     #回退到指定id的版本
git branch                   #查看当前所处的分支
git checkout -b develop      #创建并切换到一个新分支
git checkout devlop          #切换分支
```

参考:
- https://blog.51cto.com/u_15077548/4553175
- https://www.cnblogs.com/hgzero/p/12890875.html
- https://blog.csdn.net/wittylamb/article/details/116504559
- https://blog.csdn.net/m0_46168595/article/details/114839387
- https://www.runoob.com/git/git-tutorial.html

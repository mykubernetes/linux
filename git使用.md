官网：  
https://git-scm.com/book/zh/v2  

1. 在 Git 命令⾏⽅式下，⽤ init 创建⼀个 Git 仓库。  
``` $ git init repo_name ```  
2. cd 到 repo 中。  
``` $ cd repo_name ```  
3. 配置 global 和 local 两个级别的 user.name 和 user.email。  
```
$ git config --global user.name 'your_global_name'
$ git config --global user.email 'your_global_eamil@.' 
显示所有配置信息
$ git config --global list
```  
4. 创建空的 commit  
``` $ git commit --allow-empty -m 'Initial' ```  
5. ⽤ log 看 commit 信息，Author 的 name 和 email 是什么？  
``` $ git log ```  

本地仓库使用方法  
```
git add            加入暂存区  
git status         查看状态  
git status -s      状态概览  
git diff           尚未暂存的文件  
git diff --staged  暂存区文件
git commint        提交更新
git reset          回滚
git rm             从版本库中移除
git rm --cached    从暂存区中移除
git mv             重命名
git log            查看历史提交
git log --oneline  查看简易版历史提交
git log -n4        查看最近4个历史提交
```
分支
```
git branch                增加一个分支
git branch -v             
git branch --merged       查看合并的分支
git branch --no-merged    查看未合并的分支
git branch -d 
git checkout              切换指针
git merge                 合并分支
git log
git stash
git tag
```
远程仓库
```
git clone
git pull
git fetch
git push origin master
```

```
# 安装安全插件 
yum -y install yum-plugin-security

# 显示所有与安全相关的更新
yum --security check-update

# 列出所有已修复的错误
yum updateinfo list bugzillas

# 咨询摘要
yum updateinfo summary

# 将具有安全信息的所有包升级到最新的可用包
yum --security update

# 将具有安全信息的所有包升级到上一次安全更新
# (与最新可能的更新相反)
yum --security update-minimal

# 帮助
man 8 yum-security
```  

man手册
```
NAME
     yum security plugin

SYNOPSIS
     yum [options] [command] [package ...]

DESCRIPTION
   This plugin extends yum to allow lists and updates to be limited using security relevant criteria

   added yum commands are:

      yum update-minimal

   This  works  like  the  update  command,  but if you have the the package foo-1 installed and 
   have foo-2 and foo-3 available with updateinfo.xml then update-minimal will update you to foo-3.

      yum updateinfo info
      yum updateinfo list
      yum updateinfo summary

   all of the last three take these sub-commands:

      yum updateinfo * all
      yum updateinfo * available
      yum updateinfo * installed
      yum updateinfo * updates

   and then:

      * <advisory> [advisory...]
      * <package>
      * bugzillas
      * cves
      * enhancement
      * security
      * new-packages
```  

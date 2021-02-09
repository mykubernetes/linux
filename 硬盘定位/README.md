服务器硬盘定位方法
---

1、前提条件  
目前支持 LSI SAS2308 和 LSI SAS3008服务器。（Avago的卡）(Avago 收购了Broadcom, LSI  后来Avago又更名为Broadcom)  
可以使用以下方法确认HBA卡型号。  
命令1：
```
#cat /sys/class/scsi_host/host*/version_product
```
命令2：
```
#lspci | grep SAS
```

2、工具  
- 如果是 2308的卡使用：sas2ircu
- 如果是 3008的卡使用：sas3ircu  (用于LSI SAS3 Controllers)

其他卡可以用这两个工具试一下。
```
#./sas2ircu  list
或
#./sas3ircu  list
```

3、查看硬盘串号  
```
#如果找 sdf的串号，可以尝试以下三个命令。

# hdparm -I /dev/sdf | grep 'Serial Number' 
# smartctl -i /dev/sdf | grep 'Serial Number'
# ll /dev/disk/by-id/ | grep sdf
```

4、查看控制器编号
```
#./sas3ircu list
编号是0 （一般都是0）
```

5、查看槽位
```
#./sas3ircu 0 display | grep -B 10 -A 4 Z840Z1M1
Enclosure #        : 2
Slot #             ：2
······
Serial No          : Z840Z1M1
```

6、操作定位灯
```
开灯：
# ./sas3ircu  0 locate 2:2 on
其中的  2:2 来自上个命令找到的槽位号
```


MegaCli 安装及常用命令
---
1.安装
```
#rpm -ivh MegaCli-8.05.06-1.noarch.rpm  安装在/opt下
```
2.常用命令
```
# ./MegaCli64  -LDInfo -Lall -aALL 查raid级别
# ./MegaCli64 -AdpAllInfo -aALL 查raid卡信息
# ./MegaCli64 -PDList -aALL 查看硬盘信息
# ./MegaCli64 -AdpBbuCmd -aAll 查看电池信息
# ./MegaCli64 -FwTermLog -Dsply -aALL 查看raid卡日志
# ./MegaCli64 -adpCount 【显示适配器个数】
# ./MegaCli64 -AdpGetTime –aALL 【显示适配器时间】
# ./MegaCli64 -AdpAllInfo -aAll    【显示所有适配器信息】
# ./MegaCli64 -LDInfo -LALL -aAll    【显示所有逻辑磁盘组信息】
# ./MegaCli64 -PDList -aAll    【显示所有的物理信息】
# ./MegaCli64 -cfgdsply -aALL  【显示Raid卡型号，Raid设置，Disk相关信息】
```

LSI StorCLI64 工具安装和使用教程
---

https://www.cnblogs.com/chong93/p/10470032.html

https://www.cnblogs.com/luxiaodai/p/9878747.html

1、确认硬件类型

确认当前Raid卡是否可以通过 StorCLI64 来管理,先使用 lspci 查看当前设备的描述信息
```
lspci -k
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3108 [Invader] (rev 02)
        Subsystem: Super Micro Computer Inc Device 0809
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas
```
可以看到使用硬件类型为 LSI Logic / Symbios Logic MegaRAID SAS-3 3108, 系统使用的内核驱动为 megaraid_sas

2、下载安装包
官网https://www.broadcom.com

联想官网https://download.lenovo.com/pccbbs/thinkservers/ul_avago_storcli_1.18.11_anyos.zip

```
./storcli64 /c0 show                                  ##可查看Virtual Drives与Physical Drives
./storcli64 /c0/v0 show
./storcli64 /call/vall show
./storcli64 /c0/e252 show
./storcli64 /c0/eall/sall show all | grep Error       ##查看物理盘是否有异常
./opt/MegaRAID/storcli/storcli64  /c0/v0 start cc            #raid的校验
```
- /c 控制器号 输出结果中的Controller 值
- /v  RAID号
- /e 背板号  输出结果EID值
- /f 外部配置
- /s 槽位号 输出结果的Slt值

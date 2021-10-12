linux系统下ipmitool添加BMC帐号密码

需求：已知BMC帐号id2为root管理员帐号，添加id5bmc帐号

工具：ipmitool version 1.8.14

系统：CentOS release 6.6 (Final)

1，通过yum安装ipmitool安装源
```
# yum install ipmitool
```

2，手动安装ipmitool
```
rpm -ivh OpenIPMI-tools-2.0.16-11.el5.x86_64.rpm

/sbin/modprobe ipmi_msghandler
/sbin/modprobe ipmi_devintf
/sbin/modprobe ipmi_poweroff
/sbin/modprobe ipmi_watchdog
/sbin/modprobe ipmi_si
```

3，新建ip.csv文件，将BMC的userid（第一列），username（第二列），userpassword（第三列），用户名权限（第四列）
```
user_id,user_name,user_password,user_priv
2,root,123456,2
3,yewu,1234567,3
5,bmc,12345678,4
```

4，编辑ipmitool_adduser_inband.sh
```
#!/bin/bash

#版本和编辑日期
VERSION=1.0.0
MODIFY_DATE=20170830

#帮助信息函数
function printHelp()
{
    echo "Tool Version:$VERSION($MODIFY_DATE)"
    echo "Usage:$0 -i user_conf_File"
}

#如果脚本执行时加上-h参数，则打印帮助信息
case $1 in
            -h|--help)
            printHelp
            exit 0
                ;;
    esac

#获取执行脚本时的-i选项参数，把参数赋给user_conf_FILE
#若脚本的选项参数不是-i，则直接退出
while getopts ":i:" opt
do
    case $opt in
        i)
USER_CONF_FILE=$OPTARG
            echo "user config file is "$USER_CONF_FILE
            ;;
        *) 
            echo "argument error"
            exit 1;;
    esac
done

#判断有没有给USER_CONF赋值，没有则直接退出
if [ ${#USER_CONF_FILE} -eq 0 ]
then
    echo "please assign config file. detail info check -h"
    exit 0
fi

#脚本把日志输出到add_user_result.log文件
LOG_FILE="add_user_result.log"

declare -i i=0

#循环读取文件
for LINE in `cat $USER_CONF_FILE`;
do
{

    ((i=i+1))
    
    if [ $i -eq 1 ]
    then
        continue
    fi

    #简单的判断某行的有效性，如果读取到某行的长度小于10，则直接退出
    if [ ${#LINE} -lt 10 ]
    then
        exit 0;
    fi
    
    #把变量清空，给变量赋值
    USER_ID=""
    USER_NAME=""
    USER_PASSWD=""
    USER_PRIV=""
    
    USER_ID=`echo $LINE | awk -F, '{print $1}'`
    USER_NAME=`echo $LINE | awk -F, '{print $2}'`
    USER_PASSWD=`echo $LINE  | awk -F, '{print $3}'`
    USER_PRIV=`echo $LINE | awk -F, '{print $4}' | sed 's/\r//g'`
        
#    echo "user password $USER_PASSWD"
    #判断从文件中读取到的数据是否是空，若是，则直接退出，脚本停止运行
    if [ ${#USER_ID} -eq 0 ] || [ ${#USER_NAME} -eq 0 ] || [ ${#USER_PASSWD} -eq 0 ] || 
       [ ${#USER_PRIV} -eq 0 ]
    then
        echo "please check data valid of file $USER_CONF_FILE file "
        exit 0
    fi
    
    #增加用户名，密码并设置对应权限
    ipmitool user set name $USER_ID $USER_NAME
    ipmitool user set password $USER_ID $USER_PASSWD
    ipmitool user priv $USER_ID $USER_PRIV 1
    ipmitool user priv $USER_ID $USER_PRIV 8
    ipmitool channel setaccess 1 $USER_ID callin=on ipmi=on link=on privilege=$USER_PRIV 
    ipmitool channel setaccess 8 $USER_ID callin=on ipmi=on link=on privilege=$USER_PRIV 
    ipmitool user enable $USER_ID
    
}
done

echo "ipmitool user list 1" | tee -a $LOG_FILE
ipmitool user list 1 | tee -a $LOG_FILE
echo "ipmitool user list 8" | tee -a $LOG_FILE
ipmitool user list 8

echo "add all user name success" | tee -a $LOG_FILE
```

5，执行ipmitool_adduser_inband.sh -i ip.csv
```
# ./ipmitool_adduser_inband.sh -i ip.csv 
user config file is ip.csv
```

6，查看执行后的结果
```
# ipmitool user list 1
ID  Name             Callin  Link Auth  IPMI Msg   Channel Priv Limit
2   root           true    true       true       USER
3   yewu          　 true    true       true       OPERATOR
5   bmc          true    true       true       ADMINISTRATOR
```

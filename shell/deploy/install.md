```
#!/bin/bash

function tips() {
  echo "请输入agent代理服务地址或者IP、端口 "
  echo "USAGE: -s 代理地址:端口;代理地址:端口 或者 -h agent代理服务地址 -p agent代理服务端口"
  echo "e.g.: $0 -h 127.0.0.1 -p 22008"
  echo "e.g.: $0 -s 127.0.0.1:22008;127.0.0.1:22009"
  exit 1
}

while getopts ":h:p:s:" opt
do
    case $opt in
        h)
        host=$OPTARG;;
        p)
        port=$OPTARG;;
        s)
        addr=$OPTARG;;
        *)
        tips;;
    esac
done

if [ -z "$addr" ]; then
  for ((i=1;i<=3;i++)) do
    if [ -z "$host" ]; then
      read -e -p "请输入Agent代理服务器IP: " host
    else
      break
    fi
  done
  if [ -z "$host" ]; then
    tips
    exit 1
  fi

  if [ -z "$port" ]; then
    read -e -p "请输入Agent代理服务器端口，默认22008: " port
  fi
  if [ -z "$port" ];then
    port=22008
  fi
fi

baseDir=/usr/local/ops
workpath=${baseDir}/agent
if [ -d $workpath ]; then
    /etc/init.d/ops_agent stop  
    chkconfig --del zxops_agent
    rm -fr /etc/init.d/zxops_agent
    rm -fr $workpath
fi

function checkRun() {
    $1
    if [[ $? -ne 0 ]]; then
        echo "$1 failed"
        exit 1
    fi
}

checkRun "mkdir -p $workpath"
checkRun "cp -rf control.sh $workpath"
checkRun "cp -rf Agent $workpath"
checkRun "chmod a+x $workpath/control.sh"
checkRun "chmod a+x $workpath/Agent"
ln -s $workpath/control.sh /etc/init.d/ops_agent   # 启动停止脚本
chkconfig --add ops_agent
chkconfig --level 2345 ops_agent on
checkRun "cd $workpath"

# 新增agent定时任务
old=$(crontab -l | grep -v ops_agent)
cat <<EOF | sed -e '/^$/d' | crontab -
$old
*/1 * * * * /etc/init.d/zxops_agent checkdown >/dev/null 2>&1
EOF

if [ -z "$addr" ]; then
  echo "Success!!! 安装目录: $workpath Agent代理地址: $host:$port"
else
  echo "Success!!! 安装目录: $workpath Agent代理地址: $addr"
fi
./control.sh restart -h "$host" -p "$port" -s "$addr"
```

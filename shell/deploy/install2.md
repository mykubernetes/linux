```
#!/bin/bash
usage()
{
  cat << EOF
install 

Usage: bash install.sh --service ${ServiceName} --ip {IpAddr}
       -h | --help          : Show message
       --service            : deploy service name "zabbix | prometheus | all"
       --ip                 : download service ip addr

Examples:
       bash install.sh --service zabbix --ip 127.0.0.1

EOF
}

BASEDIR=$(dirname "$0")
cd $BASEDIR
BASEDIR=`pwd`

while (($#)); do
  case "$1" in
       -h | --help) usage; exit 0;;
       --service) service=${2}; shift 2;;
       --ip) ip=${2}; shift 2;;
       *)
         usage
         echo "!!!ERROR: Unknown option"
         exit 3
       ;;
  esac
done

if [ -z ${service} ]; then
   usage
   echo "!!!ERROR: --service is missing!"
   exit 1
fi

if [ -z ${ip} ]; then
   usage
   echo "!!!ERROR: --ip is missing!"
   exit 1
fi

zabbix() {

count=`ps -ef |grep -v grep  | grep zabbix |wc -l`
if [ -d /usr/local/zabbix ];then
  echo "zabbix is deploy"
  exit 1
elif [ ${count} != 0 ];then
  echo "zabbix process exist"
  exit 2
else 
echo "deploy zabbix"
# 下载mave
wget http://${ip}:12380/zabbix.tar.gz -q -O /tmp/zabbix.tar.gz
# 解压mave到/usr/local
tar xf /tmp/zabbix.tar.gz -C /usr/local/
#启动mave
/usr/local/zabbix/bin/start > /dev/null 2>&1 &
#删除下载安装包
rm -rf /tmp/zabbix.tar.gz
fi
}

prometheus() {

count=`ps -ef |grep -v grep | grep prometheus |wc -l`
if [ -d /usr/local/prometheus ];then
  echo "prometheus is deploy"
  exit 1
elif [ ${count} != 0 ];then
  echo "prometheus process exist"
  exit 2
else
echo "deploy promehteus"
# 下载mave
wget --no-check-certificate http://${ip}/prometheus.tar.gz -q -O /tmp/prometheus.tgz
# 解压prometeus到tmp目录下
tar xf /tmp/prometheus.tgz -C /tmp
# 进入promehteus
cd /tmp/prometheus
# 修改文件权限
chmod a+x ./install.sh
# 执行安装脚本
bash install.sh -h ${ip} -p 22001 
#删除下载安装包
rm -rf /tmp/promehteus.tgz
fi
}

install() {
  case "${service}" in
       zabbix) zabbix;;
       prometheus) promehteus;;
       all) zabbix; prometheus;;
  esac
}

install
```

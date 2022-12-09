```
#!/bin/bash
source /etc/profile

WORKSPACE=$(cd $(dirname $0)/; pwd)
cd $WORKSPACE

apppath=/usr/local/agent
app=Agent
pidfile=/var/run/agent.pid
logfile=/dev/null

pid=0
option=$1
shift 1
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
        echo "暂不支持该参数";;
    esac
done

function check_pid {

    if [ -f $pidfile ]; then
       pid=$(cat $pidfile)
       if [ -n "$pid" ]; then
          running=`ps -p $pid | grep -v "PID TTY" | wc -l`
          if [ $running -gt 0 ]; then
            return $running
          fi
       fi
    fi

    pid=$(pidof Agent)
    if [ -n "$pid" ]; then
      running=`ps -p $pid | grep -v "PID TTY" | wc -l`
      return $running
    fi

    return $pid
}

function start {
    check_pid
    running=$?
    if [ $running -gt 0 ]; then
        echo -n "Agent Is Running Already, pid=$pid"
        exit 0
    fi

    cd $apppath
    if [[ -n "$addr" ]]; then
      nohup ./$app  -addr "$addr" > $logfile 2>&1 &
    elif [[ -n "$host" && -n "$port" ]]; then
      nohup ./$app  -h "$host" -p "$port" > $logfile 2>&1 &
    else
      nohup ./$app  > $logfile 2>&1 &
    fi

    pid=$!
    echo $pid > $pidfile
    if [ $? -ne 0 ]; then
        echo "Start Failed!!!"
        kill -9 $pid
        exit 1
    fi

    check_pid
    running=$?
    if [ $running -gt 0 ]; then
        echo "Start Success, pid=$pid"
        exit 0
    fi
    echo "Start Failed"
}

function stop {
    check_pid
    running=$?
    if [ $running -gt 0 ]; then
        kill $pid
        echo "Stop Success!!!"
    fi
}

function restart {
    stop
    sleep 1
    start
}

function status {
    check_pid
    running=$?
    if [ $running -gt 0 ]; then
        echo "running"
    else
        echo "failed"
    fi
}

function checkdown() {
    check_pid
    running=$?
    if [ $running -gt 0 ]; then
        echo "running"
    else
        echo "Stoped, To Starting..."
        start
    fi
}


function removeCron() {
# 新增agent定时任务
old=$(crontab -l | grep -v agent)
cat <<EOF | sed -e '/^$/d' | crontab -
$old
EOF
}

function uninstall() {
    if [ -d $apppath ]; then
        removeCron
        chkconfig --del agent
        rm -fr $apppath
        rm -fr /etc/init.d/agent
        rm -fr /etc/agent.conf
        stop
        rm -rf $pidfile
    fi
    echo "Uninstall Success!!!"
}

function help {
    echo "$0 start|stop|restart|status|uninstall"
}

case "$option" in
    "start")
        start;;
    "stop")
        stop;;
    "restart")
        restart;;
    "status")
        status;;
    "checkdown")
        checkdown;;
    "uninstall")
        uninstall;;
    *)
        help;;
esac
```

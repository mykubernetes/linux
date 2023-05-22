```shell
$ ls
checklist.sh  servicelist.txt
```

服务列表
```shell
$ cat servicelist.txt 
aiops-kfk01=zookeeper kafka redis-server
aiops-kfk02=zookeeper kafka redis-server
aiops-kfk03=zookeeper kafka redis-server
aiops-kfk04=zookeeper kafka
aiops-kfk05=zookeeper kafka
```

脚本
```shell
$ cat checklist.sh 
#!/bin/bash
host=$(cat servicelist.txt |awk -F= '{print $1}')
hostName=$(hostname)
for i in ${host}
do
  if [[ "${i}" == "${hostName}" ]];then
  service=$(sed "/${i}=/!d;s/.*=//" servicelist.txt |sed 's/\r//g')
    for j in $service
    do  
       JPS=$(jps -v |grep -i $j |grep -v grep |wc -l)
       process=$(ps -ef | grep $j |grep -v grep |wc -l)
      if
        [[ $JPS -gt 0 ]]; then
        echo $j up
        continue
      fi

      if
        [[ $process -gt 0 ]]; then
        echo $j up
      else
        echo $j down
      fi
    done
  fi
done
```

执行结果
```shell
$ sh checklist.sh 
zookeeper up
kafka up
redis-server up
```

# hadoop服务重启脚本
```
#!/bin/bash

cat > /dev/null << EOF
#servicelist_start
aiops-hp01=resourcemanager journalnode datanode dfszkfailovercontroller nodemanager jobhistoryserver
aiops-hp02=resourcemanager journalnode datanode dfszkfailovercontroller nodemanager
aiops-hp03=journalnode datanode nodemanager
aiops-hp04=nodemanager datanode
aiops-hp05=nodemanager datanode
aiops-hp06=nodemanager datanode
aiops-hp07=nodemanager datanode
aiops-hp08=nodemanager datanode
aiops-hp09=nodemanager datanode
#servicelist_stop
EOF

cat > /dev/null << EOF
#service_start
resourcemanager=/app/hadoop-2.8.5/sbin/yarn-daemon.sh start resourcemanager
journalnode=/app/hadoop-2.8.5/sbin/hadoop-daemon.sh start journalnode
datanode=/app/hadoop-2.8.5/sbin/hadoop-daemon.sh start datanode
dfszkfailovercontroller=/app/hadoop-2.8.5/sbin/hadoop-daemon.sh start zkfc
nodemanager=/app/hadoop-2.8.5/sbin/yarn-daemon.sh start nodemanager
jobhistoryserver=/app/hadoop-2.8.5/sbin/mr-jobhistory-daemon.sh start historyserver
#service_stop
EOF


process (){
host=$(cat $0 | awk -F\= '/^#servicelist_start/,/^#servicelist_stop/{print $1}' |grep -v servicelist)
#service=$(cat $0 | awk -F\= '/^#service_start/,/^#service_stop/{print $2}')
hostName=$(hostname)
for i in ${host}
do
  if [[ "${i}" == "${hostName}" ]];then
  service=$(sed "/${i}=/!d;s/.*=//" $0 |sed 's/\r//g')
    for j in $service
    do  
       JPS=$(jps -v |grep -i $j |grep -v grep |wc -l)
       process=$(ps -ef | grep $j |grep -v grep |wc -l)
      if
        [[ $JPS -gt 0 ]]; then
        echo $j up
        continue
      fi
      if
        [[ $process -gt 0 ]]; then
        echo $j up
      else
        echo $j down

        if [[ "$j" == "dfszkfailovercontroller" ]];then
           j=zkfc
        elif
           [[ "$j" == "jobhistoryserver" ]];then
           j=historyserver
        fi
        service=$(cat $0 | awk -F\= '/^#service_start/,/^#service_stop/{print $2}' |grep $j)
        /bin/bash $service
      fi
    done
  fi
done
}

process
```

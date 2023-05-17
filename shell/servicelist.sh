```
$ ls
checklist.sh  servicelist.txt
```

服务列表
```
$ cat servicelist.txt 
aiops-kfk01=zookeeper kafka redis-server
aiops-kfk02=zookeeper kafka redis-server
aiops-kfk03=zookeeper kafka redis-server
aiops-kfk04=zookeeper kafka
aiops-kfk05=zookeeper kafka
```

脚本
```
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
```
$ sh checklist.sh 
zookeeper up
kafka up
redis-server up
```

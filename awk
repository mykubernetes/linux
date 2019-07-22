https://mp.weixin.qq.com/s?__biz=MzAwNTM5Njk3Mw==&mid=2247486759&idx=1&sn=72fc2dfe7422f7e9caa6b583173f27d5&chksm=9b1c0da5ac6b84b356ac960bc12a75c8c4d8cadcec6cc40c0d9008d3783b93e4f53c6db4105a&mpshare=1&scene=23&srcid=#rd

统计访问IP次数：
# awk '{a[$1]++}END{for(v in a)print v,a[v]}' access.log
统计访问访问大于100次的IP：
# awk '{a[$1]++}END{for(v ina){if(a[v]>100)print v,a[v]}}' access.log
统计访问IP次数并排序取前10：
# awk '{a[$1]++}END{for(v in a)print v,a[v]|"sort -k2 -nr |head -10"}' access.log
统计时间段访问最多的IP：
# awk'$4>="[02/Jan/2017:00:02:00" &&$4<="[02/Jan/2017:00:03:00"{a[$1]++}END{for(v in a)print v,a[v]}'access.log
统计上一分钟访问量：
# date=$(date -d '-1 minute'+%d/%d/%Y:%H:%M)
# awk -vdate=$date '$4~date{c++}END{printc}' access.log
统计访问最多的10个页面：
# awk '{a[$7]++}END{for(vin a)print v,a[v]|"sort -k1 -nr|head -n10"}' access.log
统计每个URL数量和返回内容总大小：
# awk '{a[$7]++;size[$7]+=$10}END{for(v ina)print a[v],v,size[v]}' access.log
统计每个IP访问状态码数量：
# awk '{a[$1" "$9]++}END{for(v ina)print v,a[v]}' access.log
统计访问IP是404状态次数：
# awk '{if($9~/404/)a[$1" "$9]++}END{for(i in a)print v,a[v]}' access.log

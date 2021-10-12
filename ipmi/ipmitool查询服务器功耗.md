# ipmitool查询服务器功耗

通过ipmitool查看服务器功耗
```
ipmitool -H $ip -I lanplus -U $user -P $password sdr elist | grep "Pwr Consumption"
Pwr Consumption  | 77h | ok  |  7.1 | 420 Watts
```

使用脚本批量查看功耗输入到log.csv
```
user=user
password=password
while read ip; do
echo -n ${ip}, >> log.csv
ipmitool -H $ip -I lanplus -U $user -P $password sdr elist | grep "Pwr Consumption" | awk -F"|" '{print $5}' >> log.csv
done < ./ip.conf
```

ip.conf
```
192.168.100.80
192.168.100.81
192.168.100.82
```

log.csv
```
192.168.100.80, 224 Watts
192.168.100.81, 406 Watts
192.168.100.82, 406 Watts
```

戴尔服务器执行racadm查看功耗
```
racadm -r $ip -u $username -p $password --nocertwarn get System.Power

#Avg.LastDay=399 W | 1362 Btu/hr               #最近24小时                              
#Avg.LastHour=411 W | 1403 Btu/hr　　　　　　　　#最近1小时
#Avg.LastWeek=367 W | 1253 Btu/hr　　　　　　　　#最近168小时
#Cap.ActivePolicy.BtuHr=N/A
#Cap.ActivePolicy.Name=N/A
#Cap.ActivePolicy.Watts=N/A
Cap.BtuHr=2017 btu/hr
Cap.Enable=Disabled
#Cap.MaxThreshold=648 W | 2213 Btu/hr
#Cap.MinThreshold=304 W | 1036 Btu/hr
Cap.Percent=83
Cap.Watts=591 W
#EnergyConsumption=3124.331 KWh | 10663342 Btu
#EnergyConsumption.Clear=******** (Write-Only)
#EnergyConsumption.StarttimeStamp=Thu Jan 14 09:35:44 2016
HotSpare.Enable=Disabled
HotSpare.PrimaryPSU=PSU1
#Max.Amps=2.6 Amps
#Max.Amps.Timestamp=Thu Jan 14 09:41:54 2016
#Max.Headroom=308 W | 1051 Btu/hr
#Max.LastDay=440 W | 1502 Btu/hr
#Max.LastDay.Timestamp=Wed Aug 02 00:43:36 2017
#Max.LastHour=440 W | 1502 Btu/hr
#Max.LastHour.Timestamp=Wed Aug 02 00:43:36 2017
#Max.LastWeek=445 W | 1519 Btu/hr
#Max.LastWeek.Timestamp=Sat Jul 29 06:30:16 2017
#Max.Power=592 W | 2020 Btu/hr
#Max.Power.Timestamp=Thu Jan 14 09:41:55 2016
#Max.PowerClear=******** (Write-Only)
#Min.LastDay=363 W | 1239 Btu/hr
#Min.LastDay.Timestamp=Tue Aug 01 17:20:46 2017
#Min.LastHour=383 W | 1307 Btu/hr
#Min.LastHour.Timestamp=Wed Aug 02 00:55:16 2017
#Min.LastWeek=282 W | 962 Btu/hr
#Min.LastWeek.Timestamp=Wed Jul 26 16:12:08 2017
PFCEnable=Disabled
#Realtime.Amps=1.7 Amps
#Realtime.Headroom=496 W | 1693 Btu/hr
#Realtime.Power=404 W | 1379 Btu/hr
#RedundancyCapabilities=Not Redundant,Input Power Redundant
RedundancyPolicy=Input Power Redundant
#Status=1
```
 

戴尔服务器执行racadm查看BIOS对CPU节能模式设置，看到SysProfile=Custom 说明是自定义不是节能模式
```
racadm -r $ip -u $username -p $password --nocertwarn get bios.sysprofilesettings | grep "SysProfile"
SysProfile=Custom
```

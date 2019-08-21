1、内存工具  
```
# free
total used free shared buff/cache available
Mem: 1016260 292976 80964 13744 642320 505912
Swap: 2097148 4 2097144
```  
- Total：总内存容量
- Used：被应用程序所使用的内存容量
- Free：没有被任何东西所使用的内存
- Buff/cache：被借用来当缓存的容量（应用程序需要时，可以立刻还给应用程序）
- Available：随时可以被应用程序调用的容量（可用内存）

```
# cat /proc/meminfo
MemTotal: 1016260 kB #总内存
MemFree: 717068 kB #剩余内存
MemAvailable: 674628 kB #可用内存
Buffers: 0 kB
Cached: 55900 kB
SwapCached: 80 kB
Active: 89596 kB #最近经常被使用的内存，非必要不会回收该内存
Inactive: 125464 kB #最近不常使用的内存
Active(anon): 51568 kB
Inactive(anon): 120560 kB
Active(file): 38028 kB
Inactive(file): 4904 kB
Unevictable: 0 kB
Mlocked: 0 kB
SwapTotal: 2097148 kB
SwapFree: 2096372 kB
Dirty: 0 kB #脏数据（内存缓存与磁盘不同步的数据）
```  

```
# sync #同步脏数据到硬盘
# echo "3" > /proc/sys/vm/drop_caches #释放干净的磁盘缓存空间（脏数据不会释放）
```  


```
# vmstat
procs --------------------memory------------------swap----------io--------system------------cpu---------
r b swpd free buff cache si so bi bo in cs us sy id wa st
1 0 0 3483988 221444 2367344 0 0 4 19 1 0 2 0 97 0 0
```  


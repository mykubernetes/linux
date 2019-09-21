
1、MD5文件比较  
```
md5sum md5-file1 -c md5-file2 --status
```  

2、获取页面响应状态码
```
curl -I -o /dev/null -s -w %{http_code} http://localhost:80
```  


一、生成CA根证书
---
1、准备ca配置文件，得到ca.conf
```
# vim ca.conf
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
 
[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = CN
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = JiangSu
localityName                = Locality Name (eg, city)
localityName_default        = NanJing
organizationName            = Organization Name (eg, company)
organizationName_default    = Sheld
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_max              = 64
commonName_default          = Ted CA Test
```

2、生成ca秘钥，得到ca.key
```
# openssl genrsa -out ca.key 4096
```

3、生成ca证书签发请求，得到ca.csr
```
# openssl req -new -sha256 -out ca.csr -key ca.key -config ca.conf
```
配置文件中已经有默认值了，shell交互时一路回车就行。

4、生成ca根证书，得到ca.crt
```
# openssl x509 -req -days 3650 -in ca.csr -signkey ca.key -out ca.crt
```

二、生成服务端证书
---
1、配置文件

准备配置文件，得到server.conf，内容如下：
```
# vim server.conf
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = CN
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = JiangSu
localityName                = Locality Name (eg, city)
localityName_default        = NanJing
organizationName            = Organization Name (eg, company)
organizationName_default    = Sheld
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_max              = 64
commonName_default          = www.ted2018.com
     
[ req_ext ]
subjectAltName = @alt_names
     
[alt_names]
DNS.1   = www.ted-go.com
DNS.2   = www.ted2018.com
IP      = 192.168.93.145
```
Chrome 58以后不再使用CN校验地址（就是就是浏览器地址栏URL中的那个地址host）了，而是使用SAN，注意配置里写对，IE 11还是使用CN。

2、服务端密钥

生成秘钥，得到server.key，命令如下：
```
# openssl genrsa -out server.key 2048
```

3、服务端CSR
```
# openssl req -new -sha256 -out server.csr -key server.key -config server.conf
```
配置文件中已经有默认值了，shell交互时一路回车就行。

4、服务端证书

用CA证书生成终端用户证书，得到server.crt
```
# openssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt -extensions req_ext -extfile server.conf
```

# 自建CA认证和证书

## 一些概念：

PKI：Public Key Infrastructure
- 签证机构：CA（Certificate Authority）
- 注册机构：RA（Register Authority）
- 证书吊销列表：CRL（Certificate Revoke Lists）
- 证书存取库

X.509：
- 定义了证书的结构和认证协议的标准。包括版本号、序列号、签名算法、颁发者、有效期限、主体名称、主体公钥、CRL分发点、扩展信息、发行者签名等

获取证书的两种方法：
- 使用证书授权机构
- 生成签名请求（csr）
- 将csr发送给CA
- 从CA处接收签名
- 自签名的证书
- 自已签发自己的公钥重点介绍一下自建CA颁发机构和自签名。

## 自建CA颁发机构和自签名
实验用两台服务器，一台做ca颁发证书，一台去请求签名证书。

证书申请及签署步骤：
- 1、生成申请请求
- 2、CA核验
- 3、CA签署
- 4、获取证书

我们先看一下openssl的配置文件：/etc/pki/tls/openssl.cnf
```
####################################################################
[ ca ]
default_ca  = CA_default        # The default ca section(默认的CA配置，是CA_default,下面第一个小节就是)
####################################################################
[ CA_default ]
dir     = /etc/pki/CA              # Where everything is kept （dir变量）
certs       = $dir/certs           # Where the issued certs are kept（认证证书目录）
crl_dir     = $dir/crl             # Where the issued crl are kept（注销证书目录）
database    = $dir/index.txt       # database index file.（数据库索引文件）
new_certs_dir   = $dir/newcerts    # default place for new certs.（新证书的默认位置）
certificate = $dir/cacert.pem      # The CA certificate（CA机构证书）
serial      = $dir/serial          # The current serial number（当前序号，默认为空，可以指定从01开始）
crlnumber   = $dir/crlnumber       # the current crl number（下一个吊销证书序号）
                                   # must be commented out to leave a V1 CRL
crl     = $dir/crl.pem             # The current CRL（下一个吊销证书）
private_key = $dir/private/cakey.pem   # The private key（CA机构的私钥）
RANDFILE    = $dir/private/.rand   # private random number file（随机数文件）
x509_extensions = usr_cert         # The extentions to add to the cert
# Comment out the following two lines for the "traditional"
# (and highly broken) format.
name_opt    = ca_default           # Subject Name options（被颁发者，订阅者选项）
cert_opt    = ca_default           # Certificate field options（认证字段参数）
# Extension copying option: use with caution.
# copy_extensions = copy
# Extensions to add to a CRL. Note: Netscape communicator chokes on V2 CRLs
# so this is commented out by default to leave a V1 CRL.
# crlnumber must also be commented out to leave a V1 CRL.
# crl_extensions    = crl_ext
default_days    = 365              # how long to certify for （默认的有效期天数是365）
default_crl_days= 30               # how long before next CRL
default_md  = sha256               # use SHA-256 by default
preserve    = no                   # keep passed DN ordering
# A few difference way of specifying how similar the request should look
# For type CA, the listed attributes must be the same, and the optional
# and supplied fields are just that :-)
policy      = policy_match         # 是否匹配规则
# For the CA policy
[ policy_match ]
countryName     = match            # 国家名是否匹配，match为匹配
stateOrProvinceName = match        # 州或省名是否需要匹配
organizationName    = match        # 组织名是否需要匹配
organizationalUnitName  = optional # 组织的部门名字是否需要匹配
commonName      = supplied         # 注释
emailAddress        = optional     # 邮箱地址
# For the 'anything' policy
# At this point in time, you must list all acceptable 'object'
# types.
[ policy_anything ]
countryName     = optional
stateOrProvinceName = optional
localityName        = optional
organizationName    = optional
organizationalUnitName  = optional
commonName      = supplied
emailAddress        = optional
####################################################################
```

重点关注下面的几个参数：
```
dir             = /etc/pki/CA           # Where everything is kept （dir变量）
certs           = $dir/certs            # Where the issued certs are kept（认证证书目录）
database        = $dir/index.txt        # database index file.（数据库索引文件）
new_certs_dir   = $dir/newcerts         # default place for new certs.（新证书的默认位置）
certificate     = $dir/cacert.pem       # The CA certificate（CA机构证书）
serial          = $dir/serial           # The current serial number（当前序号，默认为空，可以指定从01开始）
private_key     = $dir/private/cakey.pem# The private key（CA机构的私钥）
```


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

参考：
- https://www.zybuluo.com/mrz1/note/1011025

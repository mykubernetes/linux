官网https://stedolan.github.io/jq/manual/

# 查看`jq`帮助信息
```
# jq --help
#jq-命令行JSON处理器[1.6版]
jq - commandline JSON processor [version 1.6]

Usage:  jq [options] <jq filter> [file...]
        jq [options] --args <jq filter> [strings...]
        jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

#jq是用于处理JSON输入的工具，将给定的过滤器应用于
#其JSON文本输入，并以JSON形式生成过滤器的结果
#标准输出。
#最简单的过滤器是。，它将jq的输入复制到其输出
#未经修改（除格式外，但请注意使用的是IEEE754
#内部的数字表示，以及所有暗示的内容）。

例子:

        $ echo '{"foo": 0}' | jq .
        {
                "foo": 0
        }

一些选项包括：
  -c	紧凑而不是漂亮的输出；
  -n	使用“ null”作为单个输入值；
  -e	根据输出设置退出状态代码；
  -s	将所有输入读取（吸取）到数组中；对它应用过滤器；
  -r	输出原始字符串，而不是JSON文本；
  -R	读取原始字符串，而不是JSON文本；
  -C	为JSON着色;
  -M	单色（不要为JSON着色）；
  -S	对输出对象的排序键；
  --tab	使用制表符进行缩进；
  --arg v	将变量$ a设置为值<v>;
  --argjson v	将变量$ a设置为JSON值<v>;
  --slurpfile	将f变量$ a设置为从<f>读取的JSON文本数组；
  --rawfile	将f变量$ a设置为包含<f>内容的字符串；
  --args	其余参数是字符串参数，而不是文件；
  --jsonargs	其余参数是JSON参数，而不是文件；
  --        终止参数处理;

有关更多选项，请参见手册页。
```

option
- -s: 把读取的 jsonl 视作数组来处理 (如 group, sort 只能以数组作为输入)
- -c: 不对输出的 json 做格式化，一行输出


filter

filter 各种转换操作就很多了，如 get，map，filter，map，pick，uniq，group 等操作
- .: 代表自身
- .a.b: 相当于 _.get(input, 'a.b')
- select(bool): 相当于 _.filter(boolFn)
- map_values: 相当于 _.map，不过 jq 无法单独操作 key
- sort
- group_by

# 正确的json格式可以解析出结果
```
# cat json_raw.txt 
{"name":"Google","location":{"street":"1600 Amphitheatre Parkway","city":"Mountain View","state":"California","country":"US"},"employees":[{"name":"Michael","division":"Engineering"},{"name":"Laura","division":"HR"},{"name":"Elise","division":"Marketing"}]}

# cat json_raw.txt |jq .
{
  "name": "Google",
  "location": {
    "street": "1600 Amphitheatre Parkway",
    "city": "Mountain View",
    "state": "California",
    "country": "US"
  },
  "employees": [
    {
      "name": "Michael",
      "division": "Engineering"
    },
    {
      "name": "Laura",
      "division": "HR"
    },
    {
      "name": "Elise",
      "division": "Marketing"
    }
  ]
}
```

# 不正确的json格式，使用jq时会报错
```
# cat json_err.txt
{"name":"Google","location":{"street":"1600 Amphitheatre Parkway","city":"Mountain View","state":"California","country":"US"},"employees":[{"name":"Michael","division":"Engineering"}{"name":"Laura","division":"HR"},{"name":"Elise","division":"Marketing"}]

# 所以这个JSON是错误的，jq轻松的可以轻松的检查出来：
# cat json_err.txt |jq .
parse error: Expected separator between values at line 1, column 183
```

解析不存在的元素，会返回null
```
# echo '{"foo": 42, "bar": "less interesting data"}' | jq .nofoo
null
```

# 从json内容提取

1、获取指定字段的值
```
# cat json_raw.txt |jq .name
"Google"
```

2、使用逗号分隔，取多个字段的值；返回值以换行分隔
```
# cat json_raw.txt |jq ".name,.location"
"Google"
{
  "street": "1600 Amphitheatre Parkway",
  "city": "Mountain View",
  "state": "California",
  "country": "US"
}
```

3、提取employees数组的全部元素
```
# cat json_raw.txt |jq ".employees[]"
{
  "name": "Michael",
  "division": "Engineering"
}
{
  "name": "Laura",
  "division": "HR"
}
{
  "name": "Elise",
  "division": "Marketing"
}
```

4、提取employees数组的多个元素
```
# cat json_raw.txt |jq ".employees[0,2]"
{
  "name": "Michael",
  "division": "Engineering"
}
{
  "name": "Elise",
  "division": "Marketing"
}
```

# JSON 数组解析

1、从数组中提取单个数据
```
[root@localhost ~]# echo '[{"a":1,"b":2},{"c":3,"d":4}]' | jq .[0]
{
  "a": 1,
  "b": 2
}
```

2、从数组中提取所有数据
```
[root@localhost ~]# echo '[{"a":1,"b":2},{"c":3,"d":4}]' | jq .[]
{
  "a": 1,
  "b": 2
}
{
  "c": 3,
  "d": 4
}
```

3、过滤多个值
```
[root@localhost ~]# echo '[{"a":1,"b":2},{"c":3,"d":4}]' | jq .[0,1]
{
  "a": 1,
  "b": 2
}
{
  "c": 3,
  "d": 4
}
```

```
# 1、解析到数组的数据
# cat json_raw.txt | jq '.employees'
[
  {
    "name": "Michael",
    "division": "Engineering"
  },
  {
    "name": "Laura",
    "division": "HR"
  },
  {
    "name": "Elise",
    "division": "Marketing"
  }
]

# 2、从数组中通过索引找到需要的数据
# cat json_raw.txt | jq '.employees[1]'
{
  "name": "Laura",
  "division": "HR"
}

# 3、通过索引找到对应的值
# cat json_raw.txt | jq '.employees[1].name'
"Laura"
```

# 数据重组成数组
```
# echo '{"a":1,"b":2,"c":3,"d":4}' | jq '[.a,.b]'
[
  1,
  2
]

```

# 数据重组成对象
```
# echo '{"a":1,"b":2,"c":3,"d":4}' | jq '{"tmp":.b}'
{
  "tmp": 2
}

# echo '{"a":1,"b":2,"c":3,"d":4}' | jq '{a,b}'
{
  "a": 1,
  "b": 2
}

# cat json_raw.txt | jq '.location | {street,city}'
{
  "street": "1600 Amphitheatre Parkway",
  "city": "Mountain View"
}
```

# 管道使用
```
echo '[{"a":1,"b":2},{"a":3,"d":4}]' | jq '.[] | .a'
1
3
```









# 使用`keys`函数，获取JSON中的 key 元素
```
# 1、json文件
# cat json_raw.txt | jq .
{
  "name": "Google",
  "location": {
    "street": "1600 Amphitheatre Parkway",
    "city": "Mountain View",
    "state": "California",
    "country": "US"
  },
  "employees": [
    {
      "name": "Michael",
      "division": "Engineering"
    },
    {
      "name": "Laura",
      "division": "HR"
    },
    {
      "name": "Elise",
      "division": "Marketing"
    }
  ]
}

# 2、通过json文件解析出key
# cat json_raw.txt | jq 'keys'
[
  "employees",
  "location",
  "name"
]
```

# has函数，判断是否存在某个key
```
# cat json_raw.txt | jq 'has("name")'
true
# cat json_raw.txt | jq 'has("noexisted")'
false
```

# 示例

紧凑输出json数据
```
[root@linux-man src]# jq -c . test.json
[{"lon":113.30765,"name":"广州市","code":"4401","lat":23.422825},{"lon":113.59446,"name":"韶关市","code":"4402","lat":24.80296}]
```

根据输出结果设置命令退出状态码
```
[root@linux-man src]# jq -c -e  '.[0]|{names}|.names' test.json
null
[root@linux-man src]# echo $?
1
```

读取所有输出到一个数组(也就是所在json数据最外层套一个数组)
```
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq -r .
{
  "safd": "fsafd"
}
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq -s .
[
  {
    "safd": "fsafd"
  }
]
```

输出原始字符串，而不是一个JSON格式
```
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq  .[]
"fsafd"
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq -r .[]
fsafd
```

单色显示
```
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq  .
{
  "safd": "fsafd"
}
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq  -M .
{
  "safd": "fsafd"
}
```

排序对象
```
[root@linux-man src]# jq . test.json 
[
  {
    "lon": 113.30765,
    "name": "广州市",
    "code": "4401",
    "lat": 23.422825
  },
  {
    "lon": 113.59446,
    "name": "韶关市",
    "code": "4402",
    "lat": 24.80296
  }
]
[root@linux-man src]# jq -S . test.json 
[
  {
    "code": "4401",
    "lat": 23.422825,
    "lon": 113.30765,
    "name": "广州市"
  },
  {
    "code": "4402",
    "lat": 24.80296,
    "lon": 113.59446,
    "name": "韶关市"
  }
]
```

以table缩进
```
[root@linux-man src]# echo '{"safd":"fsafd"}' | jq  --tab .
{
    "safd": "fsafd"
}
```

获取上面地理json数据里的name值
```
[root@linux-man src]# jq '.[]|{name}' test.json 
{
  "name": "广州市"
}
{
  "name": "韶关市"
}
```

获取第一个name值
```
[root@linux-man src]# jq '.[0]|{name}' test.json 
{
  "name": "广州市"
}
```

只打印出第一个map的值：
```
[root@linux-man src]# jq '.[0]|.[]' test.json 
113.30765
"广州市"
"4401"
23.422825
```

打印出一个map的name值
```
[root@linux-man src]# jq '.[0]|.name' test.json 
"广州市"
```

打印出一个map的name值并已普通字符串显示
```
[root@linux-man src]# jq -r '.[0]|.name' test.json 
广州市
```

原始数据
---
```
{
"firstName": "John",
"lastName": "Smith",
"age": 25,
"address": {
"streetAddress": "21 2nd Street",
"city": "New York",
"state": "NY",
"postalCode": "10021"
},
"phoneNumber": [
{
"type": "home",
"number": "212 555-1234"
},
{
"type": "fax",
"number": "646 555-4567"
}
],
"gender": {
"type": "male"
}
}
```

1、格式化输出
```
# cat 1.txt | jq .
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021"
  },
  "phoneNumber": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
    }
  ],
  "gender": {
    "type": "male"
  }
```


2、. (_.get)
```
$ cat demo.jsonl | jq '.name'
"shanyue"
"shuifeng"


# cat 1.txt | jq .address
{
  "streetAddress": "21 2nd Street",
  "city": "New York",
  "state": "NY",
  "postalCode": "10021"
}
```

3、解析数组中的元素
```
获取电话信息
# cat 1.txt | jq  .phoneNumber[]
{
  "type": "home",
  "number": "212 555-1234"
}
{
  "type": "fax",
  "number": "646 555-4567"
}

获取第一个电话号码
# cat 1.txt | jq  .phoneNumber[0]
{
  "type": "home",
  "number": "212 55
```


3、{} (_.pick)
```
$ cat demo.jsonl| jq '{name, friendname: .friend.name}'
{
  "name": "shanyue",
  "friendname": "shuifeng"
}
{
  "name": "shuifeng",
  "friendname": "shanyue"
}
```

select (_.filter)
```
# cat 1.txt | jq  '.phoneNumber[] | select(.type == "home") | .number'
"212 555-1234"

$ cat demo.jsonl| jq 'select(.age > 24) | {name}'
{
  "name": "shuifeng"
}
```

map_values (_.map)
```
$ cat demo.jsonl| jq '{age} | map_values(.+10)'
{
  "age": 34
}
{
  "age": 35
}
```

sort_by (_.sortBy)

sort_by 需要先把 jsonl 转化为 json 才能进行
```
# 按照 age 降序排列
# -s: jsonl to json
# -.age: 降序
# .[]: json to jsonl
# {}: pick
$ cat demo.jsonl | jq -s '. | sort_by(-.age) | .[] | {name, age}'
{
  "name": "shuifeng",
  "age": 25
}
{
  "name": "shanyue",
  "age": 24
}

# 按照 age 升序排列
$ cat demo.jsonl | jq -s '. | sort_by(.age) | .[] | {name, age}'
{
  "name": "shanyue",
  "age": 24
}
{
  "name": "shuifeng",
  "age": 25
}
```


将CSV数据转换为json

csv数据
```
cat  >> 1.csv  << EOF
1478,john,38
1529,lucy,25
1673,iris,22
EOF
```

转换格式
```
# jq -R -c 'split(",")|{"uid":.[0],"name":.[1],"age":.[2]|tonumber}' 1.csv
{"uid":"1478","name":"john","age":38}
{"uid":"1529","name":"lucy","age":25}
{"uid":"1673","name":"iris","age":22}
```



6、将json转csv

测试数据
```
cat >> jsonData.json << EOF
{"productId":"2723","click":60,"view":300,"deal":2,"day":"20130919"}
{"productId":"2728","click":130,"view":800,"deal":10,"day":"20130919"}
{"productId":"3609","click":50,"view":400,"deal":3,"day":"20130919"}
{"productId":"3783","click":375,"view":1200,"deal":50,"day":"20130919"}
{"productId":"3522","click":87,"view":573,"deal":15,"day":"20130919"}
EOF
```

转换格式
```
# jq -r '[.productId+"_"+.day,(.click|tostring),(.view|tostring),(.deal|tostring)]|join(",")' jsonData.json
2723_20130919,60,300,2
2728_20130919,130,800,10
3609_20130919,50,400,3
3783_20130919,375,1200,50
3522_20130919,87,573,15


jq -r '[.productId+"_"+.day,(.click|tostring),(.view|tostring),(.deal|tostring)]|@csv' jsonData.json
"2723_20130919","60","300","2"
"2728_20130919","130","800","10"
"3609_20130919","50","400","3"
"3783_20130919","375","1200","50"
"3522_20130919","87","573","15"
```



# jq 增删改

以输入t.json为例：
```
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ]
}
```

修改字段
```
$ jq '.F1=100' t.json  
{
  "F1": 100,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ]
}

$ jq '.F5[1].F52="new value"' t.json                  
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "new value"
    }
  ]
}
```

增加字段
```
$ jq '.F3="new value"' t.json        
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ],
  "F3": "new value"
}

$ jq '.F5[1].F53="new value"' t.json 
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522",
      "F53": "new value"
    }
  ]
}
```

增加数组和map
```
$ jq '.F5[2]={"F51": 513, "F52": "F523"}' t.json      
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    },
    {
      "F51": 513,
      "F52": "F523"
    }
  ]
}
```

如果数组是简单类型：
```
$ jq . t.json
{
  "F3": [
    "F31",
    "F32"
  ]
}
$ jq '.F3[2]="F33"' t.json
{
  "F3": [
    "F31",
    "F32",
    "F33"
  ]
}
```

增加数组元素

- 利用length函数得到数组的长度，然后把值设置到当前位置。

```
$ jq '.F3[.F3|length]="NEWValue"' t.json
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ],
  "F3": [
    "NEWValue"
  ]
}
```

删除

- 使用del函数删除元素，包括基本元素，对象和数组元素。
```
$ jq 'del(.F1)' t.json 
{
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ]
}

$ jq 'del(.F5[1].F52)' t.json    
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512
    }
  ]
}
```

删除一个数组成员：
```
$ jq 'del(.F5[1])' t.json    
{
  "F1": 9,
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    }
  ]
}
```

删除数组成员
```
$ cat t.json
{
  "F": [
    "F0",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5"
  ]
}
$ jq 'del(.F)' t.json  # delete field F
{}
$ jq 'del(.F[])' t.json  # delete members of field F
{
  "F": []
}
$ jq 'del(.F[0])' t.json  # delete member of fields F[0]
{
  "F": [
    "F1",
    "F2",
    "F3",
    "F4",
    "F5"
  ]
}
$ jq 'del(.F[0,2,4])' t.json  # delete member of fields F[0], F[2], and F[4]
{
  "F": [
    "F1",
    "F3",
    "F5"
  ]
}
```

执行多次修改

- 使用("|")连接多个命令。
- 连接符("|")功能类似shell里面的("|")，把前面命令的输出作为后面命令的输入。

```
$ jq 'del(.F1) | del(.F5[1])' t.json              
{
  "F2": "F21",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    }
  ]
}
```

修改多个字段:
```
$ jq '.F1="New F1" | .F2="New F2"' t.json
{
  "F1": "New F1",
  "F2": "New F2",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ]
}
```

或者：
```
$ jq '. +{F1: "New Fa", F2: "New F2"}' t.json
{
  "F1": "New Fa",
  "F2": "New F2",
  "F5": [
    {
      "F51": 511,
      "F52": "F521"
    },
    {
      "F51": 512,
      "F52": "F522"
    }
  ]
}
```

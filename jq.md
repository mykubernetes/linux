官网https://stedolan.github.io/jq/manual/


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

demo.jsonl，jsonl 即每行都是一个 json，常用在日志格式中
```
{"name": "shanyue", "age": 24, "friend": {"name": "shuifeng"}}
{"name": "shuifeng", "age": 25, "friend": {"name": "shanyue"}}
```

由于在后端 API 中会是以 json 的格式返回，再次创建一个样例 demo.json
```
[
  {"name": "shanyue", "age": 24, "friend": {"name": "shuifeng"}},
  {"name": "shuifeng", "age": 25, "friend": {"name": "shanyue"}}
]
```

json格式转jsonl格式
```
$ cat demo.json | jq '.[]'
{
  "name": "shanyue",
  "age": 24,
  "friend": {
    "name": "shuifeng"
  }
}
{
  "name": "shuifeng",
  "age": 25,
  "friend": {
    "name": "shanyue"
  }
}
```

jsonl格式转json格式
```
# -s: 代表把 jsonl 组成数组处理
$ cat demo.jsonl | jq -s '.'
[
  {
    "name": "shanyue",
    "age": 24,
    "friend": {
      "name": "shuifeng"
    }
  },
  {
    "name": "shuifeng",
    "age": 25,
    "friend": {
      "name": "shanyue"
    }
  }
]
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

官网https://stedolan.github.io/jq/manual/


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

. (_.get)
```
$ cat demo.jsonl | jq '.name'
"shanyue"
"shuifeng"
```

{} (_.pick)
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

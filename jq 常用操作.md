https://stedolan.github.io/jq/manual/

# 基本操作

jq 的命令行使用方法如下:
```
$ jq -h
jq - commandline JSON processor [version 1.5]
Usage: jq [options] <jq filter> [file...]
```

## 输出原始的 JSON 数据

默认不指定 filter 就会原样输出，也可以使用 `.` 过滤器

1、`.`
```
$ echo '{"url": "mozillazg.com"}' |jq .
{
  "url": "mozillazg.com"
}
```

## object 操作

1、获取某个`key`的值

`.key, .foo.bar, .["key"]`

```
$ echo '{"url": "mozillazg.com"}' |jq .url
"mozillazg.com"
$ echo '{"url": "mozillazg.com"}' | jq '.["url"]'
"mozillazg.com"
```

2、可以在后面加个问号表示当输入不是 object 时不会报错`.key?`

```
$ echo '1' |jq '.a'
jq: error (at <stdin>:1): Cannot index number with string "a"
$ echo '1' |jq '.a?'
```
- ? 规则适合所有正确的 filter，在 filter 最后加上 ? 可以忽略错误信息

3、所有的`key`组成的数组

`keys`
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq keys
[
  "name",
  "url"
]
```

4、所有的 value

`.[]`
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq .[]
"mozillazg.com"
"mozillazg"
```

5、所有的 value 组成的数组

`[.[]]`
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq [.[]]
[
  "mozillazg.com",
  "mozillazg"
]
```

## 数组操作

1、取出所有元素

`.[]`
```
$ echo '[{"name": "tom"}, {"name": "mozillazg"}]' |jq .[]
{
  "name": "tom"
}
{
  "name": "mozillazg"
}
```

2、切分(slice)

`.[1]`, `.[0:2]`
```
$ echo '[{"name": "tom"}, {"name": "mozillazg"}, {"name": "jim"}]' |jq .[1]
{
  "name": "mozillazg"
}
$ echo '[{"name": "tom"}, {"name": "mozillazg"}, {"name": "jim"}]' |jq .[0:2]
[
  {
    "name": "tom"
  },
  {
    "name": "mozillazg"
  }
]
```

操作 object 组成的数组

比如取出数组元素中 name 的值：
```
$ echo '[{"name": "foo"},{"name": "bar"},{"name": "foobar"}]' |jq .[].name
"foo"
"bar"
"foobar"
```

也可以用下面会提到的管道操作：
```
$ echo '[{"name": "foo"},{"name": "bar"},{"name": "foobar"}]' |jq '.[]|.name'
"foo"
"bar"
"foobar"
```

如果要将结果重新组成数组，可以这样:
```
$ echo '[{"name": "foo"},{"name": "bar"},{"name": "foobar"}]' |jq [.[].name]
[
  "foo",
  "bar",
  "foobar"
]
```

也可以使用下面会提到的 map:
```
$ echo '[{"name": "foo"},{"name": "bar"},{"name": "foobar"}]' |jq 'map(.name)'
[
  "foo",
  "bar",
  "foobar"
]
```

## 使用多个 filter

`,`
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '.url, .name'
"mozillazg.com"
"mozillazg"
```

# 高级操作

## 管道（对处理后的结果做二次或多次处理）

可以通过 | 实现类似管道的功能:
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '.|.url'
"mozillazg.com"
```

```
$ echo '{"url": "mozillazg.com", "tests": [{"foobar": "v1"}, {"foobar": "v2"}]}' |jq '.tests |.[] |.foobar'
"v1"
"v2"
```

## 也可以直接用 shell 的 | 实现:
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '.' | jq '.url'
"mozillazg.com"

$ echo '{"url": "mozillazg.com", "tests": [{"foobar": "v1"}, {"foobar": "v2"}]}' |jq '.tests' | jq '.[]' | jq '.foobar'
"v1"
"v2"
```

- 获取内容的长度(字符串，数组的长度)

## `length`可以获取字符串或数组的长度:
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '.url|length'
13

$ echo '["mozillazg.com", "mozillazg"]' |jq '.|length'
2
```


## `map`

map(foo) 可以实现对数组的每一项进行操作，然后合并结果的功能:
```
$ echo '["mozillazg.com", "mozillazg"]' | jq 'map(length)'
[
  13,
  9
]
```

## `filter(select)`

select(foo) 可以实现对输入项进行判断，只返回符合条件的项:
```
$ echo '["mozillazg.com", "mozillazg"]' | jq 'map(select(.|length > 9))'
[
  "mozillazg.com"
]
```

## 字符串插值，拼接

可以使用 \(foo) 实现字符串插值功能:
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '"hi \(.name)"'
"hi mozillazg"
```
注意要用双引号包围起来，表示是一个字符串。


使用 + 实现字符串拼接:
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '"hi " + .name'
"hi mozillazg"
```

## 输出字符串原始值而不是字符串 JSON 序列化后的值

使用 -r 选项输出字符串原始值而不是 json 序列化后的值:
```
$ echo '{"value": "{\"url\": \"mozillazg.com\"}"}' |jq .value
"{\"url\": \"mozillazg.com\"}"

echo '{"value": "{\"url\": \"mozillazg.com\"}"}' |jq -r .value
{"url": "mozillazg.com"}
```

## `if/elif/else`

- 可以使用 if .. then .. elif .. then .. else .. end 实现条件判断:
```
$ echo '[0, 1, 2, 3]' \
| jq 'map(if . == 0 then "zero" elif . == 1 then "one" elif . == 2 then "two" else "many" end)'
[
  "zero",
  "one",
  "two",
  "many"
]
```

## 构造 object 或数组

- 可以通过 {} 和 [] 构造新的 object 或 数组。

### object:
```
$ echo '["mozillazg.com", "mozillazg"]' |jq '{name: .[1]}'
{
  "name": "mozillazg"
}
```

### 数组
```
$ echo '{"url": "mozillazg.com", "name": "mozillazg"}' |jq '[.name, .url]'
[
  "mozillazg",
  "mozillazg.com"
]
```

```
$ echo '{"name": "mozillazg", "ages": [1, 2]}' | jq '{name, age: .ages[]}'
{
  "name": "mozillazg",
  "age": 1
}
{
  "name": "mozillazg",
  "age": 2
}
```

### 数组 join

`join`
```
$ echo '["mozillazg.com", "mozillazg"]' | jq '.|join(" | ")'
"mozillazg.com | mozillazg"
jq play: https://jqplay.org/s/1ckAfiLKA3
```

### 字符串 split

`split`
```
$ echo '"mozillazg.com | mozillazg"' |jq 'split(" | ")'
[
  "mozillazg.com",
  "mozillazg"
]
```

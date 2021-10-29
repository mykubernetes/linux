# 0. Prefice(前言)

JQ是一个命令行工具，主要用于处理json文本。语法很简单，如下：
```
jq [options...] filter [files...]
```

JQ可以对json文本执行多种操作，包括选择、遍历、删减等等。例如 jq ´map(.price) | add´ 表示遍历输入的数组，并将其中每个元素的price累加起来。默认情况下，jq从stdin中读取json数据流，多个数据流使用空格分隔。还有一些命令行参数，主要用于控制输出和输出的格式，filter是jq语言编写的，主要用于操作输入的数据。

# 1. Filter(过滤器)   

filter 相当于jq程序，有很多内置的filter用于从对象中提取字段、或者将一个数字转换为字符串或者其它的功能。

filter 可以用不同的方式组合，比如可以通过管道将一个filter的输出当做另一个filter的输入，或者收集一个filter的输出，存到一个数组里。有些filter能够生成多个结果，比如枚举出json数组中的每个元素，通过管道将元素依次传输给第二个filter。其它语言中通过循环和迭代实现的功能在jq中可以通过组合多个filter来实现。

# 2. Options(可选项)

## --slurp/-s:

如果有多个json输入流，默认情况下，会对每个输入执行JQ命令，如果使用该参数，则会将所有输入放到一个数组里，然后执行一次JQ命令。
```
[root@localhost ~]# echo "1" "2" "3" |jq
1
2
3
[root@localhost ~]# echo "1" "2" "3" |jq --slurp .
[
  1,
  2,
  3
]
```

## --raw-input/-R

默认情况下，输入必须是json格式文本，如果使用该选项，则将每行文本当做一个普通的字符串。
```
[root@localhost ~]# echo "string" |jq .
parse error: Invalid numeric literal at line 2, column 0
[root@localhost ~]#
[root@localhost ~]#
[root@localhost ~]# echo "string" |jq --raw-input .
"string"
```

## --null-input/-n 

将null作为输入，该选项忽略任何输入，仅仅将null当做输入传给filter。正如下面的例子，如果没有null-input,这时候第一个参数是"one"，因为没有任何操作会被忽略，"inputs"表示剩余的输入，因此第一个用例输出"two, three"，如果使用了null-input，这时候忽略的就是参数null，其余输入就会被读取到"inputs"里面，如示例三。
```
[root@localhost ~]# cat file 
one
two
three
[root@localhost ~]# 
[root@localhost ~]# jq --raw-input '[inputs]' file
[
  "two",
  "three"
]
[root@localhost ~]# jq --raw-input --null-input  '[inputs]' file
[
  "one",
  "two",
  "three"
]
```

## --compact-output / -c:

默认情况下，jq 的输出是可读性好的格式，如果使用该选项，则输出则会变得紧凑。
```
[root@localhost ~]# jq . threeCountry.json 
[
  {
    "name": "Yemen",
    "dial_code": "+967",
    "code": "YE"
  },
  {
    "name": "Zambia",
    "dial_code": "+260",
    "code": "YM"
  },
  {
    "name": "Zimbabwe",
    "dial_code": "+263",
    "code": "YW"
  }
]
[root@localhost ~]# 
[root@localhost ~]# jq --compact-output '.' threeCountry.json 
[{"name":"Yemen","dial_code":"+967","code":"YE"},{"name":"Zambia","dial_code":"+260","code":"YM"},{"name":"Zimbabwe","dial_code":"+263","code":"YW"}]
[root@localhost ~]# 
```

## --colour-output / -C

默认情况下，如果输出到stdout，是有颜色的。使用该选项可以强制输出颜色，即便是输出到管道或者文件中。
```
[root@localhost ~]# echo "{\"key\":\"value\"}" |jq .
{
  "key": "value"
}
[root@localhost ~]# echo "{\"key\":\"value\"}" |jq . > withoutColor.json
[root@localhost ~]# echo "{\"key\":\"value\"}" |jq -C . > withColor.json
[root@localhost ~]# ls -al withColor.json withoutColor.json 
-rw-r--r--. 1 root root 83 Oct 29 16:42 withColor.json
-rw-r--r--. 1 root root 21 Oct 29 16:42 withoutColor.json
[root@localhost ~]# 
[root@localhost ~]# cat withoutColor.json 
{
  "key": "value"
}
[root@localhost ~]# cat withColor.json 
{
  "key": "value"
}
[root@localhost ~]# 
```

## --monochrome-output / -M

禁止输出颜色
```
[root@localhost ~]# echo "{\"key\":\"value\"}" |jq .
{
  "key": "value"
}
[root@localhost ~]# echo "{\"key\":\"value\"}" |jq -M .
{
  "key": "value"
}
```

## --ascii-output / -a:

非ASCII字符通常当做utf8字符输出，使用该选项可以强制输出ascii字符。
```
[root@localhost ~]# echo "{\"key\":\"中国\"}" |jq  .
{
  "key": "中国"
}
[root@localhost ~]# 
[root@localhost ~]# echo "{\"key\":\"中国\"}" |jq  --ascii-output  .
{
  "key": "\u4e2d\u56fd"
}
[root@localhost ~]#
```

## --raw-output / -r

如果输出是一个字符串，默认情况下对包含一对双引号，如果使用该选项，则仅仅输出字符串文本。
```
[root@localhost ~]# echo "{\"key\":\"中国\"}" |jq  .key
"中国"
[root@localhost ~]# 
[root@localhost ~]# echo "{\"key\":\"中国\"}" |jq --raw-output  .key
中国
[root@localhost ~]# 
```

## --arg name value

- 传递变量到jq程序里


# 3. Basic Filters(基础过滤器)

## '.'

- . 是最基本的过滤器，对输出不做任何处理，原样输出。通常用来输出一些可读性强的格式。
```
[root@localhost ~]# echo "{\"key\":\"中国\"}" 
{"key":"中国"}
[root@localhost ~]# echo "{\"key\":\"中国\"}" | jq .
{
  "key": "中国"
}
```

## .Attr

- Attr是JSON对象的属性名，这个过滤器用于打印指定key的值，如果不存在对应的key，则输出NULL
```
[root@localhost ~]# echo "{\"key\":\"中国\"}" | jq .key
"中国"
[root@localhost ~]# 
[root@localhost ~]# echo "{\"key\":\"中国\"}" | jq .Nokey
null
[root@localhost ~]#
```

## .[]

- 打印数组内容，括号内可以指定索引或者指定范围，索引从0开始。
```
[root@localhost ~]# cat threeCountry.json | jq .[]
{
  "name": "Yemen",
  "dial_code": "+967",
  "code": "YE"
}
{
  "name": "Zambia",
  "dial_code": "+260",
  "code": "YM"
}
{
  "name": "Zimbabwe",
  "dial_code": "+263",
  "code": "YW"
}
[root@localhost ~]# cat threeCountry.json | jq .[0]
{
  "name": "Yemen",
  "dial_code": "+967",
  "code": "YE"
}
[root@localhost ~]# cat threeCountry.json | jq .[0].name
"Yemen"
[root@localhost ~]# 
```

## ,

- 可以使用逗号连接多个过滤器，这种情况下，每个过滤器分别执行，结果也会并列展示出来
```
[root@localhost ~]# cat threeCountry.json | jq .[0].name
"Yemen"
[root@localhost ~]# cat threeCountry.json | jq '.[0].name,.[0].code'
"Yemen"
"YE"
[root@localhost ~]#
```

## |

- 管道符用于连接两个过滤器，功能上类似与Unix shell 管道，左侧过滤器执行结果会被当做右侧过滤器的输入，如果左侧过滤器产生多个结果，则右侧过滤器会分别执行。
```
[root@localhost ~]# cat threeCountry.json | jq '.[0] | .name'
"Yemen"
[root@localhost ~]# 
[root@localhost ~]# cat threeCountry.json | jq '.[] | .name'
"Yemen"
"Zambia"
"Zimbabwe"
[root@localhost ~]# 
```

# 4. Types And Values(数据类型和值)

jq支持和json一致的数据集，包括数字、字符串、布尔值、数组、对象和null

## 数组 []

- 和json一样，[]也用于构造一个数组，数组的元素可以是任意的jq表达式，表达式的结果将会组成一个数组，可以使用[]构造任何数组。
```
[root@localhost ~]# cat file |jq --raw-input
"one"
"two"
"three"
[root@localhost ~]# 
[root@localhost ~]# cat file |jq --raw-input '[.]'
[
  "one"
]
[
  "two"
]
[
  "three"
]
[root@localhost ~]# 
```

```
[root@localhost ~]# echo [1,2,3] | jq '.[0]'
1
[root@localhost ~]# 
[root@localhost ~]# echo [1,2,3] | jq '[.[0]]'
[
  1
]
[root@localhost ~]# 
```


## 对象·{}

- 和json一样，{}用于构造对象，如果对象的key是大小写敏感的，则双引号可以省略，值可以是任意的jq表达式(如果是复杂的表达式，还需要使用括号括起来)，可以使用这个符号从输入中选取指定的字段。如果某个表达式生成多个结果，则对象也可能生成多个。如果key被括号括起来，则key也会被当做一个表达式。
```
[root@localhost ~]# jq '{foo:.bar}'
{"bar":42,"baz":43}
{
  "foo": 42
}
```

```
[root@localhost ~]# jq '{user: .user, title: .titles}'
{"user":"stedolan","titles":["JQ Primer", "More JQ"]}
{
  "user": "stedolan",
  "title": [
    "JQ Primer",
    "More JQ"
  ]
}
```

```
[root@localhost ~]# jq '{user: .user, title: .titles[]}'
{"user":"stedolan","titles":["JQ Primer", "More JQ"]}
{
  "user": "stedolan",
  "title": "JQ Primer"
}
{
  "user": "stedolan",
  "title": "More JQ"
}
^C
[root@localhost ~]# 
[root@localhost ~]# jq '{(.user): .titles}'
{"user":"stedolan","titles":["JQ Primer", "More JQ"]}
{
  "stedolan": [
    "JQ Primer",
    "More JQ"
  ]
}
```

# 5. Builtin Operators And Functions(内置运算符和函数)

一些jq操作符(例如+)，对根据参数的不同执行不同的操作(比如数组、数字、字符串等)。但是jq不会执行任何隐式的类型转换，如果两个参数类型不一致，会直接报错。

## 加号 +

加号需要两个filter，输入会分别被过滤器执行，输出结果会根据过滤器结果类型相加起来。

- 如果是数字，则按照算数相加。
```
[root@localhost ~]# echo 10 |jq .
10
[root@localhost ~]# 
[root@localhost ~]# echo 10 |jq '. + 100' 
110
[root@localhost ~]#
```

- 如果是数组，则会拼接成一个大数组，
```
[root@localhost ~]# echo [1,2,3] |jq .
[
  1,
  2,
  3
]
[root@localhost ~]# 
[root@localhost ~]# echo [1,2,3] |jq '. + [4,5,6]'
[
  1,
  2,
  3,
  4,
  5,
  6
]
[root@localhost ~]# 
```

- 如果是字符串，则会拼接起来。
```
[root@localhost ~]# echo "Hello" |jq -R
"Hello"
[root@localhost ~]# echo "Hello" |jq -R '. + "World"'
"HelloWorld"
[root@localhost ~]#
```

- 如果是对象，则对象会被合并，如果有相同的key，则以右侧的过滤器中的key为最终结果。
```
[root@localhost ~]# jq '.[0], .[1]' threeCountry.json 
{
  "name": "Yemen",
  "dial_code": "+967",
  "code": "YE",
  "language": "EN"
}
{
  "name": "Zambia",
  "dial_code": "+260",
  "code": "YM"
}
[root@localhost ~]# jq '.[0]+.[1]' threeCountry.json 
{
  "name": "Zambia",
  "dial_code": "+260",
  "code": "YM",
  "language": "EN"
}
```

- 如果有一个结果是null，则返回另一个结果。
```
[root@localhost ~]# jq '.[0]+ null' threeCountry.json 
{
  "name": "Yemen",
  "dial_code": "+967",
  "code": "YE",
  "language": "EN"
}
[root@localhost ~]# 
```

## 减号 - 

- 和算术减法类似，减号也可以用在数组上，用于将数组1中所有在数组2中出现的元素删除。
```
[root@localhost ~]# echo 10 | jq '. + 100'
110
[root@localhost ~]# echo 10 | jq '. - 100'
-90
[root@localhost ~]#
```

```
[root@localhost ~]# echo [1,2,3,4,5,6] | jq '. + [4,5,6]'
[
  1,
  2,
  3,
  4,
  5,
  6,
  4,
  5,
  6
]
[root@localhost ~]# 
[root@localhost ~]# echo [1,2,3,4,5,6] | jq '. - [4,5,6]'
[
  1,
  2,
  3
]
[root@localhost ~]# 
```

## 乘法*、除法 /、取余%

- 这些操作符只作用于数字。
```
[root@localhost ~]# echo 10  | jq '. * 100'
1000
[root@localhost ~]# echo 10  | jq '. / 100'
0.1
[root@localhost ~]# echo 10  | jq '. % 100'
10
[root@localhost ~]# 
```

## length

该函数获取不同类型值的长度。

- 如果是字符串，则输出unicode代码点数量。也可以使用utf8bytelength 输出字符数量
```
[root@localhost ~]# jq '.[1].name' threeCountry.json 
"中国"
[root@localhost ~]# jq '.[1].name | length' threeCountry.json 
2
[root@localhost ~]# jq '.[1].name | utf8bytelength' threeCountry.json 
6
[root@localhost ~]#
```

- 如果是数组，则输出数组元素个数
```
[root@localhost ~]# echo [1,3,5,7,9] | jq length
5
[root@localhost ~]#
```

- 如果是对象，则输出key-value 组的个数
```
[root@localhost ~]# jq '.[0]' threeCountry.json 
{
  "name": "Yemen",
  "dial_code": "+967",
  "code": "YE"
}
[root@localhost ~]# 
[root@localhost ~]# jq '.[0] | length' threeCountry.json 
3
[root@localhost ~]# 
```

- 如果是null，则为0
```
[root@localhost ~]# jq --null-input length
0
[root@localhost ~]# 
```
 

## keys

- 如果输入是个对象，则输出一个包含该对象所有key的数组。
```
[root@localhost ~]# jq '.[0]' threeCountry.json 
{
  "name": "Afghanistan",
  "dial_code": "+93",
  "code": "AF"
}
[root@localhost ~]# jq '.[0] | keys' threeCountry.json 
[
  "code",
  "dial_code",
  "name"
]
[root@localhost ~]# 
```

- 如果输入是个数组，则输出该数组合法的索引。
```
[root@localhost ~]# echo [1,3,5,7,9] | jq keys
[
  0,
  1,
  2,
  3,
  4
]
[root@localhost ~]#
```

## has

- has函数返回一个对象是否有指定的key，或者一个数组在指定的索引上是否含有元素。
```
[root@localhost ~]# jq '.[0]' threeCountry.json 
{
  "name": "Afghanistan",
  "dial_code": "+93",
  "code": "AF"
}
[root@localhost ~]# 
[root@localhost ~]# jq '.[0] | has("name")' threeCountry.json 
true
[root@localhost ~]# jq '.[0] | has("code")' threeCountry.json 
true
[root@localhost ~]# jq '.[0] | has("language")' threeCountry.json 
false
[root@localhost ~]#
```

```
[root@localhost ~]# echo [1,3,5,7,9] | jq 'has(0)'
true
[root@localhost ~]# echo [1,3,5,7,9] | jq 'has(5)'
false
[root@localhost ~]# echo [1,3,5,7,9] | jq 'has(4)'
true
[root@localhost ~]# 
```

## to_entries, from_entries, with_entries

- 这些函数在对象和包含key-value的数组中转换，如果to_entries接受一个对象，则对于对象中每一个k:v，则输出的数组中将包含{"key": k, "value": v}.
```
[root@localhost ~]# jq '.[0] | to_entries' threeCountry.json 
[
  {
    "key": "name",
    "value": "Afghanistan"
  },
  {
    "key": "dial_code",
    "value": "+93"
  },
  {
    "key": "code",
    "value": "AF"
  }
]
[root@localhost ~]#
```

## from_entries

- 正好做相反的事情，with_entries 等价于 to_entries|map(foo)|from_entries
```
[root@localhost ~]# jq '.[0] | to_entries' threeCountry.json 
[
  {
    "key": "name",
    "value": "Afghanistan"
  },
  {
    "key": "dial_code",
    "value": "+93"
  },
  {
    "key": "code",
    "value": "AF"
  }
]
[root@localhost ~]# jq '.[0] | to_entries' threeCountry.json | jq 'from_entries'
{
  "name": "Afghanistan",
  "dial_code": "+93",
  "code": "AF"
}
[root@localhost ~]# 
```

## select

- select(filter)，如果filter返回true,则结果与输入一致，否则不输出。
```
[root@localhost ~]# jq 'map(select(. >= 2))'
[1,5,3,0,7]
[
  5,
  3,
  7
]
^C
[root@localhost ~]# 
```

## empty

- empty不返回任何结果，包括null也不返回。
```
[root@localhost ~]# jq '1,empty,2'
null
1
2
```

## map(filter)

- map是个遍历操作，对输出数组的每个元素执行filter，并将输出放到一个数组里。等价于 '.[]|filter'
```
[root@localhost ~]# echo [1,2,4] | jq 'map(. + 100)'
[
  101,
  102,
  104
]
[root@localhost ~]#
```

## add

- add函数将输入当做一个数组，根据数组的元素类型执行相应的操作，包括累加、字符串拼接、合并等。
```
[root@localhost ~]# echo [1,2,4] |jq 'add'
7
[root@localhost ~]# echo [\"hello\",\"world\"] |jq add
"helloworld"
[root@localhost ~]#
```

## range

- range函数用于生成一组连续的数字，range(4;10)产生6个数字，从4开始，直到10(10本身不包括在内)。生成的数组将作为独立的输出。
```
[root@localhost ~]# jq 'range(1;4)'
null
1
2
3
```

## tonumber

- 这是个类型转换函数，该函数将输入当做数字，如果输入不是标准的数字形式会报错。
```
[root@localhost ~]# echo "101" | jq tonumber
101
[root@localhost ~]# 
[root@localhost ~]# echo "101a" | jq tonumber
parse error: Invalid numeric literal at line 2, column 0
[root@localhost ~]#
```


## tostring

- 同上，也是个类型转换函数，将输入当做字符串。


## type

- 该函数将输入的类型当做字符串输出，可能是null，boolean、number、string、array、object的一种。
```
[root@localhost ~]# echo [0, false, [], {}, null, \"hello\"]
[0, false, [], {}, null, "hello"]
[root@localhost ~]# 
[root@localhost ~]# echo [0, false, [], {}, null, \"hello\"] |jq type
"array"
[root@localhost ~]# 
[root@localhost ~]# echo [0, false, [], {}, null, \"hello\"] |jq 'map(type)'
[
  "number",
  "boolean",
  "array",
  "object",
  "null",
  "string"
]
[root@localhost ~]#
```

## sort、sort_by
 
 - 是个排序函数，输入必须是数组类型。sort_by用于根据某一个字段来排序或者基于filter,sort_by(filter)会根据filter结果来进行排序。
```
[root@localhost ~]# echo [1,3,2,4,9,6] | jq sort
[
  1,
  2,
  3,
  4,
  6,
  9
]
[root@localhost ~]# 
```

```
[root@localhost ~]# jq . threeCountry.json 
[
  {
    "name": "Yemen",
    "dial_code": "+967",
    "code": "YE",
    "language": "EN"
  },
  {
    "name": "Zambia",
    "dial_code": "+260",
    "code": "YM"
  },
  {
    "name": "Zimbabwe",
    "dial_code": "+263",
    "code": "YW"
  }
]
[root@localhost ~]# jq 'sort_by(.dial_code)' threeCountry.json 
[
  {
    "name": "Zambia",
    "dial_code": "+260",
    "code": "YM"
  },
  {
    "name": "Zimbabwe",
    "dial_code": "+263",
    "code": "YW"
  },
  {
    "name": "Yemen",
    "dial_code": "+967",
    "code": "YE",
    "language": "EN"
  }
]
[root@localhost ~]# 
```

## group_by(.attr)

- 分组，类似于mysql,将输入当做一个数组，指定一个属性，具有相同值的会被分到同一个数组中。
```
[root@localhost ~]# jq 'group_by(.foo)'
[{"foo":1, "bar":10}, {"foo":3, "bar":100}, {"foo":1, "bar":1}]
[
  [
    {
      "foo": 1,
      "bar": 10
    },
    {
      "foo": 1,
      "bar": 1
    }
  ],
  [
    {
      "foo": 3,
      "bar": 100
    }
  ]
]
```

## min, max, min_by, max_by

- 前两个就是取最大值和最小值，后两个可以根据指定属性取。
```
[root@localhost ~]# echo [10,3,56,-28,0] | jq min
-28
[root@localhost ~]# echo [10,3,56,-28,0] | jq max
56
[root@localhost ~]# 
[root@localhost ~]# jq 'min_by(.foo)'
[{"foo":1, "bar":14}, {"foo":2, "bar":3}]
{
  "foo": 1,
  "bar": 14
}
```

## unique

- 该函数输入是一个数组，输出一个不含重复元素的数组
```
[root@localhost ~]# echo [1,3,5,3,2,1,5] | jq .
[
  1,
  3,
  5,
  3,
  2,
  1,
  5
]
[root@localhost ~]# echo [1,3,5,3,2,1,5] | jq uniqe
jq: error: uniqe/0 is not defined at <top-level>, line 1:
uniqe
jq: 1 compile error
[root@localhost ~]# echo [1,3,5,3,2,1,5] | jq unique
[
  1,
  2,
  3,
  5
]
[root@localhost ~]#
```

## reverse

- 函数用于将数组翻转
```
[root@localhost ~]# echo [1,2,3,4,5] |jq .
[
  1,
  2,
  3,
  4,
  5
]
[root@localhost ~]# echo [1,2,3,4,5] |jq reverse
[
  5,
  4,
  3,
  2,
  1
]
[root@localhost ~]#
```

## contains(v)

- 如果输入包含v，则该函数返回true。
```
[root@localhost ~]# jq 'contains("bar")'
"foobar"    
true
```

```
[root@localhost ~]# jq 'contains(["baz","bar"])'
["foobar","foobaz","blarp"]                      
true
```

```
[root@localhost ~]# jq 'contains(["bazzzzzz","bar"])'
["foobar", "foobaz","blarp"]
false
```

```
[root@localhost ~]# jq 'contains({foo: 12, bar: [{barp: 12}]})'
{"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]}
true
```

```
[root@localhost ~]# jq 'contains({foo: 12, bar: [{barp: 15}]})'
{"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]}
false
```

## recurse

- 该函数主要用于搜索递归类型结构数据。
```
[root@localhost ~]# jq .
{"name": "/", "children": [
{"name": "/bin", "children": [
{"name": "/bin/ls", "children": []},
{"name": "/bin/sh", "children": []}]},
{"name": "/home", "children": [
{"name": "/home/stephen", "children": [
{"name": "/home/stephen/jq", "children": []}]}]}]}
{
  "name": "/",
  "children": [
    {
      "name": "/bin",
      "children": [
        {
          "name": "/bin/ls",
          "children": []
        },
        {
          "name": "/bin/sh",
          "children": []
        }
      ]
    },
    {
      "name": "/home",
      "children": [
        {
          "name": "/home/stephen",
          "children": [
            {
              "name": "/home/stephen/jq",
              "children": []
            }
          ]
        }
      ]
    }
  ]
}
```

```
[root@localhost ~]# jq 'recurse(.children[]) | .name'
{"name": "/", "children": [
{"name": "/bin", "children": [
{"name": "/bin/ls", "children": []},
{"name": "/bin/sh", "children": []}]},
{"name": "/home", "children": [
{"name": "/home/stephen", "children": [
{"name": "/home/stephen/jq", "children": []}]}]}]}
"/"
"/bin"
"/bin/ls"
"/bin/sh"
"/home"
"/home/stephen"
"/home/stephen/jq"
```

## 字符串替换 \(x)

- 在一个字符串中，可以加入一个反斜杠开头的表达式：'\express'，则这个表达式的结果将会插入到字符串中。
```
[root@localhost ~]# jq '"The input was \(.), which is one less than \(.+1)"'
42
"The input was 42, which is one less than 43"
```





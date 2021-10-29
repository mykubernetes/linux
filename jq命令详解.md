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

```






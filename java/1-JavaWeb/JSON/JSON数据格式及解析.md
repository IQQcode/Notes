![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315200504.png)

### JSON简介

**什么是JSON?**

- JSON 指的是 JavaScript 对象表示法（**J**ava**S**cript **O**bject **N**otation）
- JSON 是轻量级的**文本数据交换格式**
- JSON 独立于语言：JSON 使用 Javascript语法来描述数据对象，但是 JSON 仍然独立于语言和平台。JSON 解析器和 JSON 库支持许多不同的编程语言
- JSON 具有自我描述性，更易理解

**JSON能干嘛？**

* JSON现在多用于**存储** 和 **交换文本信息**的语法
* 进行数据的**传输**

**JSON 文件**

- JSON 文件的文件类型是 `.json`
- JSON 文本的 MIME 类型是 "application/json"

### JSON vs XML

JSON能干的事，XML也能干呀？有啥子区别？

- JSON 比 XML 更小、更快，更易解析

------------------------------

【JSON 与 XML 的*相同*之处】

1. JSON 和 XML 数据都是 "自我描述" ，都易于理解

2. JSON 和 XML 数据都是有层次的结构

3. JSON 和 XML 数据可以被大多数编程语言使用

【JSON 与 XML 的*不同*之处】

1. JSON 不需要结束标签

2. JSON 更加简短

3. JSON 读写速度更快

4. JSON 可以使用数组

> **最大的不同是**：XML 需要使用 XML 解析器来解析，JSON 可以使用标准的 JavaScript 函数来解析
> 
> - `JSON.parse()`：将一个 JSON 字符串转换为 JavaScript 对象
> - `JSON.stringify()`：于将 JavaScript 值转换为 JSON 字符串

------------------------------------------------------

**为什么 JSON 比 XML 更好？**

1. XML 比 JSON 更难解析

2. JSON 可以直接使用现有的 JavaScript 对象解析

3. 针对 AJAX 应用，JSON 比 XML 数据加载更快，而且更简单

### JSON语法

#### 【基本规则】

* 数据在`键-值`对中：json数据是由键值对构成的
  * `键` 用引号(单双都行)引起来，也可以不使用引号
  * `值` 取值类型：
    1. 数字（整数或浮点数）
    2. 字符串（在双引号中）
    3. 逻辑值（true 或 false）
    4. 数组（在方括号中）`{"persons":[{},{}]}`
    5. 对象（在花括号中）`{"address":{"school"："西安"....}}`
    6. null
* 数据由逗号分隔：多个键值对由逗号分隔
* 花括号保存对象：使用`{}`定义json 格式
* 方括号保存数组：`[]`

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img1.png)

多层级JSON:

```json
//JSON对象里面可以嵌套多层对象(数组或对象)，嵌套层数未知

var JSONS = {
"id": "123456",
"username": "root",
"persons": [
    { "name": "Tom", "age": 23, "major": "Java" },
    { "name": "Jack", "major": "python" },
    { "name": "Sun", "major": "go", "gender": "man" }
    ],
    "华中地区": {
        "长三角":
            [{ "城市名": "武汉", "发展年限": 80, "简称": "火炉" },
            { "城市名": "宜昌", "发展年限": 79, "简称": "宜家" },
            { "城市名": "咢州", "发展年限": 78, "简称": "小咢" }]
    }
};
```

#### 获取数据

**1. json对象.键名**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img2.png)

**2. json对象["键名"]**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img3.png)

**3. 数组对象[索引]**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img3.png)

#### 遍历获取数据

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img4.png)

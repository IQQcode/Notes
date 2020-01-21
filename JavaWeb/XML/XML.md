## XML

### 1.XML简介

<kbd>[**W3School参考**](https://www.w3school.com.cn/xml/index.asp)</kbd>

> **XML 被设计用来传输和存储数据**
>
> **HTML 被设计用来显示数据**

概念：Extensible Markup Language可扩展标记语言

- 可扩展：标签都是自定义的

什么是 XML?

- XML 指可扩展标记语言（*EX*tensible *M*arkup *L*anguage）
- XML 是一种*标记语言*，很类似 HTML
- XML 的设计宗旨是*传输数据*，而非显示数据
- XML 标签没有被预定义。您需要*自行定义标签*。
- XML 被设计为具有*自我描述性*。
- XML 是 *W3C 的推荐标准*

功能：

存储数据1.配文件

2.在网络中传输

xml与html的区别

1.xml标签都是自定义的，html标签是预定义。

2.xm1的语法严格，html语法松散

3.xml存储数据的，html是展示数据

*W3C：万维网联盟

### 2.语法

基本语法：

1. xml文档的后缀名.xml
2. xml第一行必须定义为文档声明
3. xml文档中有且仅有一个根标签
4. 属性值必须使用引号（单双都可）引起来
5. 标签必须正确关闭
6. xml标签名称区分大小写



### 3.组成部分

**I. 文档声明**

1.格式：<2xml属性列表？>

2.属性列表：

- version：版本号，必须的属性
- encoding：编码方式。告知解析引擎当前文档使用的字符集，默认值：ISO-8859-1
- standalone：是否独立了



取值：

yes：不依赖其他文件

no：依赖其他文件

**II. 指令**

- 结合CSS样式
- `<?xml-stylesheet type="text/css" href="a.css"?>`

**III. 标签**

标签命名规则：

- 名称可以包含字母、数字以及其他的字符
- 名称不能以数字或者标点符号开始
- 名称不能以字母xml（或者XML、Xml等）开始
- 名称不能包含空格

**IV. 属性**

- ID属性值唯一

**V. 文本**

- CDATA区：在该区域中的数据会被原样展示
- 格式：`<![ CDATA[数据 ] ] >`

### 4.实体引用

在 XML 中，一些字符拥有特殊的意义。

如果你把字符` "<" `放在 XML 元素中，会发生错误，这是因为解析器会把它当作新元素的开始

这样会产生 XML 错误：

```xml
<message>if salary < 1000 then</message>
```

为了避免这个错误，请用==实体引用==来代替 "<" 字符：

```xml
<message>if salary &lt; 1000 then</message> 
```

在 XML 中，有 5 个预定义的实体引用：

| &lt;   | <    | 小于   |
| ------ | ---- | ------ |
| &gt;   | >    | 大于   |
| &amp;  | &    | 和号   |
| &apos; | '    | 单引号 |
| &quot; | "    | 引号   |

**注释：**在 XML 中，只有字符 "<" 和 "&" 确实是非法的。大于号是合法的，但是用实体引用来代替它是一个好习惯。







### 5.XML约束

约束：规定xml文档的书写规则

![image-20200120101608543](C:\Users\j2726\AppData\Roaming\Typora\typora-user-images\image-20200120101608543.png)



XML约束分类：

- DTD：一种简单的约束技术

- Schema：一种复杂的约束技术

--------------------------------------------------



**DTD：引人dtd文档到xml文档中**

- 内部dtd：捋约束规则定义在xml文档中

- 外部dtd：将约束的规则定义在外部的dtd文件中

本地：<!DOCTYPE 根标签名 SYSTEM "dtd文件位置">

网络：<!DOCTYPE 根标签名 PUBLIC "dtd文件名称" "dtd文件位置URL">



**Schema**

引人：

1. 填写xm1文档的根元素
2. 引入xsi前缀.xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
3. 引入xsd文件命名空间 `xsi:schemalocation`="https://github.com/IQQcode student.xsd"
4. 为每一个xsd约束声明一个前缀，作为标识 xmlns="https://github.com/IQQcode"

```xml
<students xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="https://github.com/IQQcode"
          xsi:schemaLocation="https://github.com/IQQcode student.xsd">
    <student number="IQQCode_0001">
        <name>Mr.Q</name>
        <age>120</age>
        <sex>male</sex>
    </student>

    <student number="IQQCode_0002">
        <name>IQQcode</name>
        <age>120</age>
        <sex>female</sex>
    </student>
</students>
```



### 6.XML解析

解析：操作xml文档，将文档中的数据读取到内存中

操作xml文档

1. 解析（读取）：将文档中的数据读取到内存中

2. 写入：将内存中的数据保存到xml文档中，持久化的存储



**解析xml的方式**

1. DOM：捋标记语言文档一次性加载进内存，在内存中形成一颗dom树

- 优点：操作方便，可以对文档进行CRUD的所有操作

- 缺点：占内存

2. SAX：逐行读取，基于事件驱动的。

- 优点：不占内存。

- 缺点：只能读取，不能增删测



#### xml常见的解析器

1. JAXP:sun公司提供的解析器，支持DON和SAX两种思想

2. DoM4J：一款非常优秀的解析器

3. Jsoup：是一款Java的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jouery的操作方法来取出和操作数据。

4.PULL：Android操作系统内置的解析器，SAX方式。




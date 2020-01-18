## XML

### 1.XML简介

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

**IV. 属性**

**V. 文本**
## XML

### 1.XML简介

<kbd>[**W3School参考**](https://www.w3school.com.cn/xml/index.asp)</kbd><kbd>[**菜鸟教程**](https://www.runoob.com/xml/xml-intro.html)</kbd>

> [**W3C万维网联盟**](https://baike.sogou.com/v58743.htm?fromTitle=W3C)
>
> [W3C组织](https://baike.sogou.com/lemma/ShowInnerLink.htm?lemmaId=15651&ss_c=ssc.citiao.link)是对网络标准制定的一个[非赢利组织](https://baike.sogou.com/lemma/ShowInnerLink.htm?lemmaId=342100&ss_c=ssc.citiao.link)，像HTML、XHTML、CSS、XML的标准就是由W3C来定制。W3C会员（大约500名会员）包括生产技术产品及服务商、内容供应商、团体用户、研究实验室、标准制定机构和政府部门，一起协同工作，致力在[万维网](https://baike.sogou.com/lemma/ShowInnerLink.htm?lemmaId=17200&ss_c=ssc.citiao.link)发展方向上达成共识。 自从Web诞生以来，Web的每一步发展、技术成熟和应用领域的拓展，都离不开成立于1994年10月的W3C(World Wide Web Consortium，[万维网联盟](https://baike.sogou.com/lemma/ShowInnerLink.htm?lemmaId=7873940&ss_c=ssc.citiao.link))的努力。W3C是专门致力于创建Web相关技术标准并促进Web向更深、更广发展的国际组织。

概念：e**X**tensible **M**arkup **L**anguage可扩展标记语言。XML 被设计用来结构化、存储以及传输信息。

- 可扩展：标签都是自定义的

**什么是 XML?**

- XML 指可扩展标记语言（*EX*tensible *M*arkup *L*anguage）
- XML 是一种*标记语言*，很类似 HTML
- XML 的设计宗旨是==传输数据==，而非显示数据
- XML 标签没有被预定义。需要*自行定义标签*。
- XML 被设计为具有*自我描述性*。
- XML 是 *W3C 的推荐标准*

功能：

- 存储数据
- 1. 配置文件

- 2. 在网络中传输

### 2.xml与html的区别

> **XML 被设计用来传输和存储数据**
>
> **HTML 被设计用来显示数据**

1. xml标签都是自定义的，html标签是预定义

2. xml的语法严格，html语法松散

3. xml存储数据的，html是展示数据

**XML 是对 HTML 的补充**

XML 不会替代 HTML，理解这一点很重要。在大多数 Web 应用程序中，XML 用于传输数据，而 HTML 用于格式化并显示数据。

> 对 XML 最好的描述是：
>
> **XML 是独立于软件和硬件的信息传输工具**

### 3.语法

基本语法：

1. xml文档的后缀名`.xml`
2. xml第一行必须定义为文档声明
3. xml文档中有且仅有一个根标签
4. 属性值必须使用引号（单双都可）引起来
5. 标签必须正确关闭
6. xml标签名称区分大小写

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<users>
    <user id='1'>
        <name>zhangsan</name>
        <age>23</age>
        <gerder>male</gerder>
    </user>

    <user id='2'>
        <name>zhangsan</name>
        <age>23</age>
        <gerder>female</gerder>
        <code>
            <!-- if(a< b && a>c) -->
            if(a &lt; b &amp;&amp;  a &gt; c) { }

            <![CDATA[
                if(a < b && a > c) { }
            ]]]>
        </code>
    </user>
</users>
```



### 4.组成部分

**I. 文档声明**

1.格式：`<?xml属性列表?>`

2.属性列表：

- version：版本号，必须的属性
- encoding：编码方式。告知解析引擎当前文档使用的字符集，默认值：ISO-8859-1
- standalone：是否独立了

-------------------------------

`<?xml version="1.0" encoding="UTF-8" standalone="no" ?>`

standalone取值：

- yes：不依赖其他文件

- no：依赖其他文件

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



### 5.实体引用

在 XML 中，一些字符拥有特殊的意义。

如果把字符` "<" `放在 XML 元素中，会发生错误，这是因为解析器会把它当作新元素的开始

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



### 6.XML约束

约束：规定xml文档的书写规则

![image-20200122174622715](C:\Users\j2726\AppData\Roaming\Typora\typora-user-images\image-20200122174622715.png)

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

引人xml文件：

1. 填写xml文档的根元素
2. 引入xsi 前缀. `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`
3. 引入xsd文件命名空间 `xsi:schemalocation="https://github.com/IQQcode student.xsd"`
4. 为每一个xsd约束声明一个前缀，作为标识 `xmlns="https://github.com/IQQcode"`

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

**web.xml**文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
</web-app>
```

![](C:\Users\j2726\Pictures\Snipaste_2020-01-22_12-48-41.png)

### 7.XML解析

解析：操作xml文档，将文档中的数据读取到内存中

操作xml文档

1. 解析（读取）：将文档中的数据读取到内存中

2. 写入：将内存中的数据保存到xml文档中，持久化的存储

**解析xml的方式**

1. DOM：将标记语言文档一次性加载进内存，在内存中形成一颗dom树

- 优点：操作方便，可以对文档进行CRUD的所有操作

- 缺点：占内存

2. SAX：逐行读取，基于事件驱动的。

- 优点：不占内存。

- 缺点：只能读取，不能增删测

**XML 树结构**

![image-20200122175215019](C:\Users\j2726\AppData\Roaming\Typora\typora-user-images\image-20200122175215019.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bookstore>
    <book category="COOKING">
        <title lang="en">Everyday Italian</title>
        <author>Giada De Laurentiis</author>
        <year>2005</year>
        <price>30.00</price>
    </book>
    <book category="CHILDREN">
        <title lang="en">Harry Potter</title>
        <author>J K. Rowling</author>
        <year>2005</year>
        <price>29.99</price>
    </book>
    <book category="WEB">
        <title lang="en">Learning XML</title>
        <author>Erik T. Ray</author>
        <year>2003</year>
        <price>39.95</price>
    </book>
</bookstore>
```

实例中的根元素是 <bookstore>。文档中的所有 <book> 元素都被包含在 <bookstore> 中。

<book> 元素有 4 个子元素：<title>、<author>、<year>、<price>。

#### xml常见的解析器

1. JAXP:sun公司提供的解析器，支持DON和SAX两种思想

2. DoM4J：一款非常优秀的解析器

3. Jsoup：是一款Java的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jouery的操作方法来取出和操作数据。

4. PULL：Android操作系统内置的解析器，SAX方式



【Jsoup解析xml】




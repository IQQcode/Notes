

## Jsoup解析

### Jsoup解析器

Jsoup是一款Java的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套井常省力的API，可通过DOM，CSS以及类似于jQuery的操作方法来取出和操作数据。

Jsoup解析步骤：

1. 导入jar包
2. 获取Document对象
3. 获取对应的标签Element对象
4. 获取数据

Code



Jsoup对象

对象的使用：

1.Jsoup工具类，可以解析html或xml文档，返回Document

*parse：解析html或xm1文档，返回Document

*parse（File in，string charsetName）：解析xml或html文件的。

*parse（String html）：解析xml或html字符串

*parse（URL url，int timeoutMillis）：通过网络路径获取指定的html或xml的文档对象





2.Document：文档对象，代表内存中的dom树

*获取Elemet对象

getElementById（String id）：根据id属性值获取唯一的element对象

getElementsByTag（String tagName）：根据标签名称获取元素对象集合

getElementsByAttribute（String key）：根据属性名称获取元素对象集合

getElementsByAttributeValue（String key，string value）：根据对应的属性名和属性值获取元素对象集合

3.Elements：元素Element对象的集合。可以当做ArrayList<Element>来使用



4.Element：元素对象

1.获取子元素对象

getElementById（string id）：根据id属性值获取唯一的element对象*

getElementsByTag（string tagName）：根据标签名称获取元素对象集合

*getElementsByAttribute（string key）：根据属性名称获取元素对象集合

*getElementsByAttributevalue（String key，string value）：根据对应的属性名和属性值获取元素对象集合

2.获取属性值
*

string attr（string key）：根据属性名称获取属性值

3.获取文本内容

*String text（）：获取文本内容

*string html（）：获取标签体的所有内容（包括字标签的字符串内容）



5.Node：节点对象是Document和Element的父类



--------------------------------------------------

### 快捷查询方式



[XML(三)_解析器(Jsoup和JsoupXpath)_附Jsoup.jar包下载](https://blog.csdn.net/qq_37388518/article/details/99675283)



1.selector：选择器

*使用的方法：Elements select（string cssouery）

*语法：参考selector类中定义的语法



2.XPath:XPath即为XML路径语言，它是一种用来确定XML（标准通用标记语言的子集）文档中某部分位置的语言

*使用Jsoup的Xpath需要额外导入jar包。

*查询w3cshoo1参考手册，使用xpath的语法完成查询


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





2.Document：文档对象。代表内存中的dom树



3.Elements：元素Element对象的集合。可以当做ArrayList<Element>来使用



4.Element：元素对象



5.Node：节点对象










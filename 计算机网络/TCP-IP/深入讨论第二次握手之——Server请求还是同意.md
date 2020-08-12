### 官方篇——收到并回复

**服务器收到客户端的请求，并且回复SYN + ACK**

**维基百科**

- 回复

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200811235504.png)

> https://zh.wikipedia.org/wiki/%E4%BC%A0%E8%BE%93%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE

**百度百科**

- 收到、确认

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200811235634.png)

> [三次握手_百度百科](https://baike.baidu.com/item/%E4%B8%89%E6%AC%A1%E6%8F%A1%E6%89%8B/5111559?fr=aladdin)

**搜狗百科**

- 和百度一样

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200811235809.png)

### 高参考价值博文

**谢老爷子书中内容**

- 同意连接，并且确认连接

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200812000436.png)

> https://zhuanlan.zhihu.com/p/58603455

**CSDN官方文章**

- 同意连接，并且确认连接

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200812000049.png)

> [详解 TCP 连接的“ 三次握手 ”与“ 四次挥手 ”](https://baijiahao.baidu.com/s?id=1654225744653405133&wfr=spider&for=pc)

**B乎**

- 同意连接，并且确认连接

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200812000653.png)

> https://zhuanlan.zhihu.com/p/43838752

**油管**

- 确认同步请求，并回复

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200812000750.png)

> [MicroNugget: How to Prevent TCP Syn-Flood Attacks - YouTube](https://www.youtube.com/watch?v=nYPFH1ZAlck)

**《图解TCP/IP》**

- 确认应答

**Video**

- 确认应答，同意连接  `11:40`开始

> https://www.bilibili.com/video/BV1wW411K7QZ?p=2

--------------

还找了好多，就不一一列举了。网络文章可能歧义性较大，同一知识点可能理解的角度不同，叙述的方式也不同，关键是自己将正确的要点理解即可！

## 结论

官微都说的很简介，体现不出我们歧义的结论：

第二次握手，到底服务器是**同意连接---并且确认连接**，还是**请求和客户端进行双向的连接确认**无法得出结论。。。

但是，通过很多资料、文章的叙述，我还是保留我的观点，即

【第二次服务器向客户端确认应答的语义是】：

**服务器同意连接，并且确认连接**。先是服务器**同意**客户端的连接请求，才会进行**确认应答，建立新的连接**

以上仅为个人通过论述并且根据资料查找得出的观点，仅是个人理解和理由。
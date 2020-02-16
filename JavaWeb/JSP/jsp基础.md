### JSP

JSP概念：Java Server pages java服务器端页面

可以理解为：

- 一个特殊的页面，其中既可以**定义html标签**，又可以**定义java代码**
- 用于简化书写！

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>JSP</title>
  </head>
  <body>
  <%
    System.out.println("你好，JSP!");
  %>
  <h2>Hello,JSP!</h2>
  </body>
</html>
```

控制台和页面分别输出：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163558814.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163613238.png)

JSP简化了HTML页面书写

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163651666.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)



### JSP访问原理

**JSP本质是一个Servlet**
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020021616371040.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

### JSP脚本

JSP脚本：JSP定义java代码的方式

1.`<% java代码 %>` 

定义的java代码在 service方法中。 service方法中可以定义什么，该脚本中就可以定义什么

2.`<%! java代码 %>` 

定义的java代码在jsp转换后的java类的成员位置（成员变量，成员方法，静态代码块），可能引发线程安全问题！

3.`<%= java代码 %>` 

 定义的java代码会输出到页面上，输出语句中可以定义什么

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163734360.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)



页面输出

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163752720.png)





### JSP内置对象

在jsp页面中不需要获取和创建，可以值接使用的对象jsp共有9个内置对象

**1. request请求对象**

request对象属于 Javax. ervlet ServletRequest接口的实例化对象。

【作用】 request对象不但可以用来设置和取得 request范围变量,还可以用来获得客户端请求参数、请求的来源、表头、 cookies等。

【机制】当用户请求一个JSP页面时,JSP页面所在的 Tomcat服务器将用户的请求封装在内置对象 request中。 request内置对象代表了客户端的请求信息,主要用于接收客户端通过HTTP协议传送给服务器端的数据。在客户端的请求中如果有参数,则该对象就有参数列表。

**2. response响应对象**

response对象属于Javax.servlethttpHttpservletrEsponse接口的实例化对象

【作用】 response对象用来给客户端传送输出信息、设置标头等。

【机制】 response对象的生命周期由JSP容器自动控制。当服务器向客户端传送数据JSP容器就会创建 response对象,并将请求信息包装到 response对象中。它封装了JSP性的响应,然后被发送到客户端以响应客户的请求,当JSP容器处理完请求后, response
对象就会被销毁。

**3. out字符输出流对象**
out：字符输出流对象，可以捋数据输岀到页面上。

在JSP页面中，`out`和 `response. getwriter()`类似。

销毁。

**3. out字符输出流对象**
out：字符输出流对象，可以捋数据输岀到页面上。

在JSP页面中，`out`和 `response. getwriter()`类似。

`response.getwriter()`和 `out. write()`的区别在 Tomcat服务器真正给客户端做出响应之前，会先找 response缓冲区数据，再找out缓冲区数据，response.getwriter()数据输出永远在out.write()之前

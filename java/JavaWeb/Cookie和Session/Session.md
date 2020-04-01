### HttpSession快速入门

概念：服务器端会话技术，在一次会话的多次请求间共享数据，将数据保存在服务器端的对象中

**HttpSession快速入门**

1. 获取HttpSession对象：

	​	Httpsession session = request.getsession();

2. 使用HttpSession对象

​			object getAttribute(String name)

​			void setAttribute(String name,object value)

​			void removeAttribute(String name)



一次会话中，两次请求间的共享数据：



<img src="C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581901368346.png" alt="1581901368346" style="zoom:80%;" />

【ServletSessionI】

<img src="C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581906918816.png" alt="1581906918816" style="zoom:80%;" />

【ServletSessionII】

![1581907020817](C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581907020817.png)

既然是两个请求共享了数据，那么它们的Session对象可能是同一个。

我们通过抓包发现两次的JSESSIONID是用一个。



### Session

**服务器如何确保在一次会话范围内，多次获取的Session对象是同一个?**

- 通过Cookie来确保多次获取的Session对象是同一个
- Session的买现是依赖于Cookie的

![1581906780542](C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581906780542.png)



Q1：当客户端关闭后，服务器不关闭，两次获取session是否为同一个？:

- 默认情况下，不是。

	【第一次获取】

	<img src="C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581906918816.png" alt="1581906918816" style="zoom:80%;" />

	【第二次获取】

<img src="C:%5CUsers%5Cj2726%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5C1581907645231.png" alt="1581907645231" style="zoom:80%;" />

- 如果需要相同，则可以创建Cookie，键为JSESSIONID，设置最大存活时间，让cookie持久化保存

	```java
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
	        //获取Session
	        HttpSession session = request.getSession();
	        //期望客户端关闭后,Session也能够相同
	        Cookie cookie = new Cookie("JSESSIONID",session.getId());
	        cookie.setMaxAge(60*60);
	        response.addCookie(cookie);
	        System.out.println(session);
	    }
	```

-------------------------------------------------------------

Q2：客户端不关闭，服务器关闭后，两次获取的session是同一个吗？

- 不是同一个，浏览器关闭后Session销毁

- 不是同一个，但是要确保**数据不丢失**



【Session钝化--序列化】

- 在服务器正常关闭之前，将session对象系列化到硬盘上

【Session活化–反序列化】

在服务器后动后，将session文件转化为内存中的session对象

--------------------------------------------------------------------------------------------

Q3：Session的失效时间？

1. 服务器关闭

2. session对象调用`invalidate()`

3. session默认失效时间30分钟选择性配置修改

```xml
<session-config>
			<session-timeout>30</session-timeout>
</session-config>
```



### Session的特点

1. Session用于存储一次会话的多次请求的数据，存在服务器端

2. Session可以存储任意类型、任意大小的数据



**Session与Cookie的区别：**

1. Session存储数据在服务器端，Cookie在客户端

2. Session没有数据大小限制，Cookie有

3. Session数据安全，Cookie相对于不安全(服务器相对于客户端更加安全)








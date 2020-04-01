@[toc]
### 1.会话技术

会话：一次会话中包含多次请求和响应

一次会话：浏览器第一次给服务器资源发送请求，会话建立，直到有一方断开为止

功能：在一次会话的范围内的多次请求间，共享数据

就像我倒某东买一台MacBook，我在页面上没有登录就能够把商品能够加入购物车

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216162746380.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216162759589.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)


在我登陆之后，发现电脑已经躺在我的购物车里了。这就是通过会话技术来实现数据共享。

**方式**

- 客户端会话技术：Cookie

- 服务器端会话技术：Session





### 2.Cookie

概念：客户端会话技术，将数据保存到客户端

- 一个小信息，由服务器写给浏览器的，由浏览器来保存。

- 客户端保存的Cookie信息，可以再次带给服务器

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216162820202.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

#### 获取Cookie对象

1. 创建 Cookie对象，绑定数据
	- new Cookie (string name, String value)
2. 发送 Cookie对象
	- response. addCookie(Cookie cookie)
3. 获取 Cookie，拿到数据c
	- Cookie[] request. getCookieso()

**获取Cookie Code**

<kbd>ServletCookieI</kbd>

```java
package com.iqqcode.cookie;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-15 15:30
 * @Description:Cookie快速入门
 */
@WebServlet("/ServletCookieI")
public class ServletCookieI extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //1.创建Cookie对象
        Cookie cookie = new Cookie("MSG","Hello");
        //2.发送Cookie
        response.addCookie(cookie);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        this.doPost(request, response);
    }
}
```

<kbd>ServletCookieII</kbd>

```java
package com.iqqcode.cookie;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-15 15:30
 * @Description:
 */
@WebServlet("/ServletCookieII")
public class ServletCookieII extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //3.获取Cookie
        Cookie[] cs = request.getCookies();
        //4.获取数据,遍历Cookies
        if(cs != null) {
            for (Cookie c : cs) {
                String name = c.getName();
                String value = c.getValue();
                System.out.println(name + ":" + value);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        this.doPost(request, response);
    }
}
```



必须是同一浏览器访问`ServletCookieI` `ServletCookieII`才能打印Cookie信息，不同浏览器没有建立数据共享来缓存到本地目录

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020021616284057.png)

基于响应头**set- cookie**和请求头**cookie**实现

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216162900621.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)



#### Cookie内容

I. 一次可不可以发送多个 Cookie？

- 可以

- 可以创建多个 Cookie对象，使用 response用多次 addCookie方法发送Cookie即可

II. Cookie在浏览器中保存多长时间？

- 默认情况下，当浏览器关闭后， Cookie数据被销毁，Cookie数据存放在内存中
- 持久化存储：`setMaxAge(int seconds)`
	1. 正数：将 Cookie数据写到硬盘的文件中，持久化存储，Cookie存活时间
	2. 负数：默认情况
	3. 零：删陈除Cookie信息

III. Cookie能不能存中文？

- 在 Tomcat 8之前cookie中不能直接存储中文数据（需要将中文数据转码，采用URL编码）

- 在 Tomcat 8之后， cookie支持中文数据

IV. Cookie获取范围多大？

假设在一个Tomcat服务器中，部署了多个web项目，那么在这些web项目中cookie能不能共享？

- 默认情况下 cookie不能共享

* `setpath(string path)`：设置 cookie的获取范围。默认情况下，设置当前的虚拟目录如果要共享，则可以将path设置为`/`

---------------------------------------------

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163049889.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163122778.png)

` https://tieba.baidu.com/ `相对于`https://baidu.com`，`tieba`是二级域名，`baidu.com`是一级域名



不同的Tomcat服务器间cookie共享问题？

* `setDomain(string path)`：如果设置一级域名相同，那么多个服务器之间cookie可以共享
* `setDomain(".baidu.com")`，那么tieba.baidu.com和news.baidu.com中cookie可以共享



#### 案例

记录上一次访问时间

**1. 需求**

1. 访问一个Servlet，如果是第一次访间，则提示：您好，欢迎您首次访问

2. 如果不是第一次访问，则提示：欢迎回来，您上次访问时间为：显示时间字符串

**2. 分析**

1. 采用cook来完成

2. 在服务器中的 Servlet判断是否有一个名为LastTime的cookie

- 有：不是第一次访问
	- 响应数据：欢迎回来，您上次访问时间为：2020年2月15日20:16:20
	- 写回 Cookie：LastTime，更新时间

- 没有：是第一次访问
	- 响应数据：您好，欢迎您首次访问！
	- 写回 Cookie：LastTime，更新时间

虚拟目录设置 `/CookieTechnology`

```java
package com.iqqcode.demo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-15 20:20
 * @Description:记录上一次访问时间
 * 有:不是第一次访问
 * 	  -响应数据：欢迎回来，您上次访问时间为：2020年2月15日20:16:20
 * 	  -写回 Cookie：LastTime，更新时间
 * 没有:是第一次访问
 * 	  -响应数据：您好，欢迎您首次访问！
 * 	  -写回 Cookie：LastTime，更新时间
 */
@WebServlet("/CookieDemo")
public class CookieDemo extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //设置响应消息体的数据格式及编码
        response.setContentType("text/html;charset:utf-8");
        //1.获取所有Cookie
        Cookie[] cookies = request.getCookies();
        boolean flag = false;//没有LastTime的cookie
        //2.遍历Cookie数组
        if (cookies!= null && cookies.length > 0) {
            for (Cookie cookie : cookies) {
                //3.获取cookie的名称
                String name = cookie.getName();
                //4.判断名称是否为LastTime
                if (name.equals("LastTime")) {
                    flag = true;
                    //有该cookie,不是第一次访问
                    //获取当前字符串,重新获取cookie值,重新发送cookie
                    Date date = new Date();
                    SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy:MM:dd HH:mm:ss");
                    String setdate = simpleDate.format(date);
                    //URL编码
                    setdate = URLEncoder.encode(setdate, "UTF-8");
                    cookie.setValue(setdate);
                    //设置cookie存活时间
                    cookie.setMaxAge(60*60);
                    response.addCookie(cookie);
                    //响应数据,获取cookie的value
                    String value = cookie.getValue();
                    //URL解码
                    value = URLDecoder.decode(value, "UTF-8");
                    response.getWriter().write("<h2>欢迎回来！您上次的访问时间是:" + value + "</h2>");
                    break;
                }
            }
        }
        if (flag == false || cookies == null || cookies.length == 0) {
            //没有,第一次访问
            Date date = new Date();
            SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy:MM:dd HH:mm:ss");
            String setdate = simpleDate.format(date);
            //URL编码
            setdate = URLEncoder.encode(setdate, "UTF-8");
            Cookie cookie = new Cookie("LastTime",setdate);
            //设置cookie存活时间
            cookie.setMaxAge(60*60);
            response.addCookie(cookie);
            response.getWriter().write("<h2>您好，欢迎您首次访问！</h2>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200216163244630.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

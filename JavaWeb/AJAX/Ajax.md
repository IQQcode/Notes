

## Ajax异步

### 同步与异步

在Java多线程时，接触过同步。利用`synchnized`关键字修饰同步代码块或者同步方法来实现线程的同步，即只让一个线程获取资源。

此处的同步是☞客户端请求服务器时，在等待服务器响应的状态。是等待还是能够干其他事。

就比如说，有一天，母胎单身的我终于脱单了（妈呀，不敢想那会是啥时候呀！）

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314221235.png)

和女神约好规定时间到咖啡馆约会，我提前到了指定座位但是她还没来。。。

这时，作为同步的我会在那啥也不动，就坐着等她来，你不来我啥也不干，一心一意等你！

作为异步的我会拿出鲜花放到桌上，然后掏出我的电脑咔咔就是一顿写代码！！！

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314221150.png)

当女神来了，无论我是同步还是异步，都会等到女神的响应。毫无疑问，作为异步的我，女神的用户体验肯定更好！

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314221105.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314210942.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314211747.png)

### Ajax简介

Ajax 即 “**A**synchronous  **J**avascript **A**nd  **X**ML”（异步 JavaScript 和 XML），是指一种创建交互式、快速动态网页应用的网页开发技术，**无需重新加载整个网页**的情况下，能够更新部分网页的技术

------------------------------

划重点：

- 通过在后台与服务器进行少量数据交换，Ajax 可以使网页实现异步更新

- 可以在不重新加载整个网页的情况下，对网页的某部分进行更新

传统的网页（不使用 Ajax）如果需要更新内容，必需重载整个网页面.

举个大家在Ajax中都举过的例子：

当在谷歌的搜索框输入关键字Ajax时，浏览器客户端会把这些字符发送到服务器，然后服务器会返回一个搜索的联想列表。

我们并没有刷新页面，但是输入框出现了联想列表，说明页面的部分内容进行了更新

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200314213801.png)

**Ajax的作用：**

- 提升用户体验，使用户操作更加连贯流畅

## Ajax实现方式

### jQuery实现

**$.ajax()实现**

让servlet的线程睡5s，如果是同步则在5s内文本框不能输入。异步时当Tomcat状态为`pending`等待时，此时可以在文本框中输入

<kbd>JSP<kbd>

```javascript
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>JQ实现</title>
    <script src="js/jquery-3.4.1/jquery-3.4.1.min.js"></script>
    <script>
        function fun() {
            //使用$.ajax()发送异步请求
            $.ajax({
                url:"ajaxServlet", //请求路径
                type:"POST", //请求方式
                //data:"username=Tom&password=1234",//请求参数
                data:{"username":"Tom","password":"1234"},
                //响应成功后的回掉函数
                success:function (data) {
                    alert(data);
                },
                //请求响应出现错误回调函数
                error:function () {
                    alert("ERROR!")
                },
                dataType:"text" //接收到的响应数据格式
            });
        }
    </script>
</head>
<body>
<input type="button" value="发送异步请求" onclick="fun();">
<input type="text" placeholder="请求时能否输入">
</body>
</html>
```

<kbd>servlet</kbd>

```java
package com.iqqcode.ajax.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @Author: Mr.Q
 * @Date: 2020-03-15 10:19
 * @Description:原生js实现
 */
@WebServlet("/ajaxServlet")
public class AjaxJsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //1.获取请求参数
        String username = request.getParameter("username");
        //处理业务逻辑，耗时
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //2.打印username
        System.out.println(username);

        //3.响应
        response.getWriter().write("hello : " + username);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
}
```

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315112056.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315112218.png)

**$.get()**

`$.get(url,[]data],[callback],[type])`

参数

- url：请求路径

- data：请求参数

- callback：回调函数

- type：响应结果的类型

Get请求方式

```javascript
<script>
    function fun() {

        //使用$.post()发送异步请求

        $.get("ajaxServlet",{username:"Tom",},function(data) {

            alert(data);

        },"text");
    }

</script>
```

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315120447.png)

**$.post()**

Post请求方式，仅仅是名称换了而已

```javascript
<script>
    function fun() {

    //使用$.post()发送异步请求

    $.post("ajaxServlet",{username:"Tom"},function(data) {

        alert(data);

        },"text");
    }

</script>
```

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315120353.png)

### 原生js实现

`xmlhttp.open("GET","ajaxJsServlet?username=Tom",true);`

`Thread.sleep(5000);`

- true为异步

- false为同步

在Tomcat响应数据时：

- 如果是同步，文本输入框得等5秒之后才能输入数据

- 异步则直接可以输入内容

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315103623.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315104232.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315103643.png)

<kbd>JSP</kbd>

```javascript
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>原生js实现</title>
  <script>
    //定义方法
    function  fun() {
      //发送异步请求

      //1.创建核心对象
      var xmlhttp;
      if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
      }
      else {
        // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
      }

      //2. 建立连接
      /*
          参数：
              1. 请求方式：GET、POST
                  * get方式，请求参数在URL后边拼接。
                  * send方法为空参
                  * post方式，请求参数在send方法中定义
              2. 请求的URL：
              3. 同步或异步请求：true（异步）或 false（同步）

       */
      xmlhttp.open("GET","ajaxJsServlet?username=Tom",true);

      //3.发送请求
      xmlhttp.send();

      //4.接受并处理来自服务器的响应结果
      //获取方式 ：xmlhttp.responseText
      //什么时候获取？当服务器响应成功后再获取

      //当xmlhttp对象的就绪状态改变时，触发事件onreadystatechange。
      xmlhttp.onreadystatechange=function() {
        //判断readyState就绪状态是否为4，判断status响应状态码是否为200
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
          //获取服务器的响应结果
          var responseText = xmlhttp.responseText;
          alert(responseText);
        }
      }
    }
  </script>
</head>
<body>
<input type="button" value="发送异步请求" onclick="fun();">
<input type="text" placeholder="请求时能否输入">
</body>
</html>
```

<kbd>servlet</kbd>同上

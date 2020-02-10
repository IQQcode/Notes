![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210114602678.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
### 需求

用户登录案例需求：

1. 编写login.html登录页面username&password 两个输入框

2. 使用Druid数据库连接池技术，操作mysql，LoginDemo数据库中user表

3. 使用dbcTemplate技术封装 JDBC

4. 登录成功跳转到Successservlet展示：登录成功！用户名，欢迎您

5. 登录失败跳转到Failservlet展示：登录失败，用户名或密码错误



![C:\Users\j2726\AppData\Roaming\Typora\typora-user-images](https://img-blog.csdnimg.cn/20200210105247241.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)



### 开发步骤

#### 1.创建项目，导入html页面，配置文件，jar包

File -----> New -----> Project

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020021010541674.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

#### 2.创建数据库环境,导入jar包

```sql
CREATE DATABASE day14;

USE day14;

CREATE TABLE USER(
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR (32) UNIQUE NOT NULL,
password VARCHAR (32) NOT NULL
);
```

- 在表中插入数据

| username | password |
| :------: | :------: |
|  admin   |  admin   |

- IDEA关联数据库表，选择MySQL

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210105451194.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210105508163.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210110507931.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

- 导入jar包
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210110119933.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
链接：[https://pan.baidu.com/s/1LhJRBs8BSNGL9ZdvU72bUQ](https://pan.baidu.com/s/1LhJRBs8BSNGL9ZdvU72bUQ)
提取码：b1o5

**新建文件夹，将这些jar包放到 WEB-INF下的lib中**

<img src = "https://img-blog.csdnimg.cn/20200210110227773.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70 " width="60% ">

- 将jar包添加到项目中

选中lib，右击Add as Library
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020021011054946.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
选择添加到模块中
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210110702194.png)
将编译后的class文件放到文件夹中，路径为当前项目位置的out目录

没有out文件夹的在项目中新建一个即可，不然编译运行时会报错！
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020021011080961.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
**Druid连接池**

桌面新建文件名为`druid.properties`，放到src下

【项目目录】

<img src = " https://img-blog.csdnimg.cn/20200210111336922.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width="60% ">

<kbd>druid.properties</kbd>
```sql
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://127.0.0.1:3306/db_loginservlet
username=root
password=1234
initialSize=5
maxActive=10
maxWait=3000
maxIdle=6
minIdle=3
```
>url=jdbc:mysql://127.0.0.1:3306/数据库名

#### 3.创建用户实体类User
在`domain`包下创建User

```java
package org.iqqcode.domain;


/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 09:05
 * @Description:用户实体类
 */
public class User {
    private int id;
    private String username;
    private String password;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
}
```


#### 4.创建UserDao类，提供login方法
在`dao`下新建UserDao，操纵数据库中User类的表

```java
package org.iqqcode.dao;


import org.iqqcode.domain.User;
import org.iqqcode.utils.JDBCUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 10:27
 * @Description:操纵数据库中User类的表
 */
public class UserDao {

    //声明JDBCTemplate对象共用
    private JdbcTemplate  template = new JdbcTemplate(JDBCUtils.getDataSource());

    /**
     * 登录方法
     * @param loginUser 只有用户名,密码
     * @return user 包含用户全部数据
     */
    public User login(User loginUser) {
        try {
            //1.编写sql
            String sql = "select * from user where username = ? and password = ?";
            //2.调用quary方法
            User user = template.queryForObject(sql,new BeanPropertyRowMapper<User>(User.class),
                    loginUser.getUsername(),loginUser.getPassword());

            return user;
        } catch (DataAccessException e) {
            e.printStackTrace();//记录日志
            return null;
        }
    }
}
```

#### 5.编写工具类JDBCUtils
在`utils`包下创建JDBCUtils，JDBC工具类,使用druid连接池

```java
package org.iqqcode.utils;


import com.alibaba.druid.pool.DruidDataSourceFactory;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 10:31
 * @Description:JDBC工具类,使用druid连接池
 */
public class JDBCUtils {
    private static DataSource ds;

    static {
        try {
            //1.加载配置文件
            Properties props = new Properties();

            //使用ClassLoader加载配置文件来获取字节输入流
            InputStream inputStream = JDBCUtils.class.getClassLoader().getResourceAsStream("druid.properties");
            props.load(inputStream);

            //2.初始化连接池对象
            ds = DruidDataSourceFactory.createDataSource(props);

        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取连接池对象
     * @return
     */
    public static DataSource getDataSource() {
        return ds;
    }

    /**
     * 获取Connection对象
     * @return
     * @throws SQLException
     */
    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}
```
#### 6.单元测试UserDao功能
在`test`包下新建UserDaoTest，**junit**测试UserDao查询数据表功能

```java
package org.iqqcode.test;


import org.iqqcode.dao.UserDao;
import org.iqqcode.domain.User;
import org.junit.Test;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 11:34
 * @Description:
 */
public class UserDaoTest {
    @Test
    public void testLogin() {
        User useLogin = new User();
        useLogin.setUsername("admin");
        useLogin.setPassword("admin");

        UserDao dao = new UserDao();
        User user = dao.login(useLogin);

        System.out.println(user);
    }
}
```
测试结果
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210113727855.png)

#### 7.编写ServletLogin类
在`servlet`包下创建ServletLogin

```java
package org.iqqcode.servlet;

import org.apache.commons.beanutils.BeanUtils;
import org.iqqcode.dao.UserDao;
import org.iqqcode.domain.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.Map;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 15:16
 * @Description:
 */
@WebServlet("/ServletLogin")
public class ServletLogin extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //1.设置编码
        request.setCharacterEncoding("UTF-8");

        /*
        //2.获取单个请求参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        //3.封装user对象
        User loginUser = new User();
        loginUser.setUsername(username);
        loginUser.setPassword(password);
        */

        //2.获取所有请求参数
        Map<String,String[]> map = request.getParameterMap();

        //3.封装user对象
        User loginUser = new User();
        //3.1使用BeanUtils封装
        try {
            BeanUtils.populate(loginUser,map);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }

        //4.调用UserDao的login方法
        UserDao dao = new UserDao();
        User user = dao.login(loginUser);

        //5.判断user
        if (user == null) {
            //登录失败
            request.getRequestDispatcher("failServlet").forward(request, response);
        }else {
            //登陆成功
            //存储数据
            request.setAttribute("user",user);
            //转发
            request.getRequestDispatcher("successServlet").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        this.doPost(request, response);
    }
}
```

<kbd>FailServlet</kbd>

```java
package org.iqqcode.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 16:36
 * @Description:
 */
@WebServlet("/failServlet")
public class FailServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //页面设置编码
        response.setContentType("text/html;charset=UTF-8");
        //输出
        response.getWriter().write("登陆失败...用户名或密码错误");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
}
```

<kbd>SuccessServlet</kbd>

```java
package org.iqqcode.servlet;

import org.iqqcode.domain.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author: Mr.Q
 * @Date: 2020-02-09 16:36
 * @Description:
 */
@WebServlet("/successServlet")
public class SuccessServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //页面设置编码
        response.setContentType("text/html;charset=UTF-8");

        //获取request域中共享的user对象
        User user= (User)request.getAttribute("user");

        if(user != null) {
            //输出
            response.getWriter().write("登陆成功!" + user.getUsername() +"欢迎您！");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
}
```


#### 8.登录页面
index中form表单的action路径的写法

	虚拟目录+Servlet的资源路径

【页面预览】
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210112659908.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
<kbd>index.jsp</kbd>
```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
  <form class="box" action="/LoginServletDemo/ServletLogin" method="POST">
    <h1>Login</h1>
    <input type="text" name="username" placeholder="Username">
    <input type="password" name="password" placeholder="Password">
    <input type="submit" name="" value="Login">
  </form>
  </body>
</html>
```
<kbd>style.css</kbd>
```css
body{
    margin: 0;
    padding: 0;
    font-family: sans-serif;
    background: #34495e;
}
.box{
    width: 300px;
    padding: 40px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    background: #191919;
    text-align: center;
}
.box h1{
    color: white;
    text-transform: uppercase;
    font-weight: 500;
}
.box input[type = "text"],.box input[type = "password"]{
    border: 0;
    background: none;
    display: block;
    margin: 20px auto;
    text-align: center;
    border: 2px solid #3498db;
    padding: 14px 10px;
    width: 200px;
    outline: none;
    color: white;
    border-radius: 24px;
    transition: 0.25s;
}
.box input[type = "text"]:focus,.box input[type = "password"]:focus{
    width: 280px;
    border-color: #2ecc71;
}
.box input[type = "submit"]{
    border: 0;
    background: none;
    display: block;
    margin: 20px auto;
    text-align: center;
    border: 2px solid #2ecc71;
    padding: 14px 40px;
    outline: none;
    color: white;
    border-radius: 24px;
    transition: 0.25s;
    cursor: pointer;
}
.box input[type="submit"]:hover{
    background: #2ecc71;
}
```


-------------------------------------
【登录测试】

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210114344284.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210114409775.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200210114431825.png)

-------------------------

#### Bug修改

我真是个憨憨，找错找了一天，Druid数据池老报错，原来是导入jar包导错了！


-------------------------


好啦，到此Servlet登录案例的Demo完成了。虽然实现的功能比较简单，算是对Servlet知识点的练习！









<img src = " " width=" ">

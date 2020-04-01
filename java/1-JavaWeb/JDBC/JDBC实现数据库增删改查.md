@[TOC](JDBC实现数据库增删改查)
### 1. JDBC
JDBC概念： (Java DataBase Connectivity) Java数据库链接，是访问关系型数据库的 Java API

JDBC**本质**： JDBC是官方（sun公司）给Java程序员提供==访问和操作所有关系型数据库的统一接口==（规则）. 各个数据库厂商去实现这套接口，提供数据库驱动 jar 包

> 那么问题来了（来了呀老弟）：
> 不同的数据库厂商定义的API肯定不同，所以操作的规范也就不同了. 在学校我学了 SQL Server, 那我再学 MySQL 或者 Oracle 的话,岂不是还得再从头学......学一个数据库，就得学对应的一套不同的规范，就算我顶得住，头发也顶不住呀！！！
> 所以，为了解决这个问题，sun公司提出了一套规范

![在这里插入图片描述](https://img-blog.csdnimg.cn/2019080610343646.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
### 2. JDBC操作数据库
#### 1. 操作步骤：
**1. 导入驱动 jar 包 mysql-connector-java-5.1.37-bin.jar**
>复制 mysq1-connector-java-5.1.37-bin.jar 到项目的 libs(自定义文件夹)目录下
右键---->Add As Library

**2. 注册驱动**

**3. 获取数据库连接对象 Connection**

**4. 定义sql. 获取执行sql语句的对象 Statement**

**5. 执行sql，ResultSet 集合接收返回结果**

**6. 处理结果**

**7. 释放资源**
#### 2. 实例Demo
[**mysql jdbc jar包官网下载流程**](https://blog.csdn.net/qq_38049314/article/details/81743809)

[**空降 MySQL-jdbc 链接**](https://dev.mysql.com/downloads/connector/j/)

在 meven 项目的单元测试中执行：

<img src = "https://img-blog.csdnimg.cn/20190806113226402.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "50%">

**创建 jdbc DataBase 以及 user Table**

```sql
CREATE DATABASE IF NOT EXISTS `jdbc`
        DEFAULT CHARACTER SET `utf8`;

USE jdbc;

CREATE TABLE user(
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户id',
    username VARCHAR(20) UNIQUE NOT NULL COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT 'MD5加密后的密码'
)CHARSET='utf8';

```
添加数据

```sql
INSERT INTO jdbc.user(username, password)
    VALUES ('zs','123'),('ls','123'),('ww','123');
```

**1. select 操作**
```java
import org.junit.Test;

import java.sql.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-30 20:12
 * @Description: 会存在 SQL注入的隐患
 */

public class JDBCDemoSelect {
    @Test
    public void testSelect(){
        try {
            //1.加载驱动
            Class forName = Class.forName("com.mysql.jdbc.Driver");

            //2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","1234");

            //3.执行SQl

            String sql = "select * from user";
            Statement statement = connection.createStatement();
          
             //查询的结果通过 ResultSet 放入到结果集中
            ResultSet resultSet = statement.executeQuery(sql);
            
            //遍历结果集
            while (resultSet.next()) {
                //每一行记录认为是一个对象
                int id = resultSet.getInt("id");
                String username = resultSet.getString("username");
                String password = resultSet.getString("password");
                System.out.println("id : "+id+" \nusername : "+username +"\npassword : "+password);
            }

            //4.释放资源
            connection.close();
            statement.close();
            resultSet.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
```
数据表：
<img src = "https://img-blog.csdnimg.cn/2019080611352596.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "50%">

执行结果：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190806113719548.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

### 3. 详解JDBC的各个对象：
通过上面的 Demo,我们来具体分析 JDBC涉及到的各个对象

JDBC API 主要用到4个接口：**Driver**、**Connection**、**Statement** 和 **ResultSet**

这些接口的关系如图
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190806153137515.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
JDBC 引用程序使用 **Driver** 接口加载一个合适的数据库驱动，使用 **Connection** 接口连接到数据库，使用 **Statement** 接口创建和执行SQL语句. 如果语句返回结果(比如select时)，那么就使用 **ResultSet** 来处理结果.
>我们来把 Connection比作是通向山顶的轨道,那么 Statement 就是来回接送游客的缆车，SQL语句就相当于是游客


#### 1. DriverManager：驱动管理对象
 功能：
**1. 注册驱动：** 告诉程序该使用哪一个数据库驱动 jar 
`static void registerpriver`（Driver driver）：注册给定的驱动程序 DriverManager
写代码使用：`Class.forName("com.mysq1.jdbc.Driver")`简化后的格式
通过查看源码发现：在 `com.mysql.jdbc.Driver`类中存在静态代码块
```java
static {
        try {
            java.sql.DriverManager.registerDriver(new Driver());
        } catch (SQLException E) {
            throw new RuntimeException("Can't register driver!");
        }
    }
```
注意：MySQL5之后的驱动 jar 包可以省略注册驱动的步骤

在 com.mysql.services 包下由 Driver,JVM 会自动加载；但是还是建议写上`Class.forName("com.mysq1.jdbc.Driver")`

<img src = "https://img-blog.csdnimg.cn/20190806121133730.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70"  width = "45%">
<img src = "https://img-blog.csdnimg.cn/20190806121430686.png"  width = "50%">

**2. 获取数据库连接**

<kbd>方法</kbd>：`static Connection getconnection(String url，String user，String password)`

<kbd>参数</kbd>：
- ur1：指定连接的路径
*语法：jdbc:mysq1：//ip地址（域名）：端口号/数据库名称*：`jdbc:mysq1：//localhost：3306/jdbc` 【localhoist为本机回环地址  127.0.0.1】
- user：用户名
- password：密码

#### 2. Connection：数据库连接对象
**功能：**

<kbd>1. 获取执行sql的对象</kbd>

`Statement createStatement()`

`Preparedstatement preparestatement(string sql)`

<kbd>2. 管理事务：</kbd>

开后事务：`setAutocommit(boolean autocommit)`调用该方法设置参数为false，即开后事务

提交事务：`commit()`

回滚事务：`rollback()`

#### 3. Statement：执行sql的对象
**功能**

<kbd>执行 SQL</kbd>

1. `int executeUpdate(String sql)`：执行ML（insert、update、delete）语句
- 返回值：影响的行数，可以通过这个影响的行数判断DML语句是否执行成功. 返回值 >0 ,则执行成功;反之，则失败.

2. `ResultSet executeQuary(string sql)`：执行DQL(select) 语句,结果放在结果集中

#### 4. ResultSet：结果集对象，封装查询结果
[**ResultSet**](https://blog.csdn.net/qq_35180983/article/details/82226407)了解更多
<img src = "https://img-blog.csdnimg.cn/20190806160400578.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "70%">

`boolean next()`：游标向下移动一行,判断当前行是否是最后一行末尾（是否有数据）；如果是，返回 **false** 结束遍历；如果不是游标移到下一行，获取数据...

`getxxx(参数)`：获取数据

**Xxx**：代表数据类型如：`int getInt()`，`String getstring()`

**参数：**
1. int：代表列的编号，从1开始. 如：`getString(1)` 取到表中第一行的第一列的元素
2. String：代表列名称. 如：`getString("user")`方法的重载，通过穿的参数来获取到对应的列

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190806160613769.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
#### 5. 对上面 select Demo的修改

```java
import org.junit.Test;

import java.sql.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-30 20:12
 * @Description: 会存在 SQL注入的隐患
 */

public class JDBCDemoSelect {
    @Test
    public void testSelect() {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            //1.加载驱动
            Class forName = Class.forName("com.mysql.jdbc.Driver");

            //2.获取连接
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","1234");

            //3.执行SQl

            String sql = "select * from user";
            statement = connection.createStatement();

            //查询的结果通过 ResultSet 放入到结果集中
            resultSet = statement.executeQuery(sql);

            //遍历结果集
            while (resultSet.next()) {
                //每一行记录认为是一个对象
                int id = resultSet.getInt(1);
                String username = resultSet.getString("username");
                String password = resultSet.getString("password");
                System.out.println("id : "+id+" \nusername : "+username +"\npassword : "+password);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }finally {
            //4.释放资源

            //避免空指针异常
            if(statement != null) {
                //statement != null则获取到到了资源;statement = null则为空,未获取到
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if(connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
更改内容，将释放资源的操作放到了 **finally** 代码块中.

因为如果在获取链接处或者执行SQL处出错，那么后面的在 **try** 代码块中释放资源的操作就不会被执行，而是会来到 **catch** 块中，可能会导致内存泄露. 而放在 **finally** 代码块中，则一定会被执行，正常的释放资源.

而且，在 **fianlly** 中关闭资源时，要判断

`if(statement != null)`  

<font color=#DC143C size=3>statement != null</font> 则获取到到了资源；<font color=#DC143C size=3>statement = null</font>则为空,则未获取到资源

` if(connection != null)`

` if (resultSet != null)`

当未获取到资源时，会抛出**空指针异常**，所以需要判断一下.

### 4. Insert、Delete、Update Demo
>为了代码的可读性，减少重复的篇幅，就把释放资源的操作放到了 **try** 代码块中，在写的时候及得要放在 **finally** 中
#### 1. Insert 插入操作

```java
import org.junit.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-30 20:56
 * @Description: Insert 插入操作
 */
public class JDBCDemoInsert {
    @Test
    public void testInsert(){
        try {
            //1.加载驱动
            Class forName = Class.forName("com.mysql.jdbc.Driver");

            //2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","1234");

            //3.执行SQl
            String sql = "insert into user(username, password) values ('Tom','123')";
            Statement statement = connection.createStatement();
            int resultRows = statement.executeUpdate(sql,Statement.RETURN_GENERATED_KEYS);

            System.out.println(resultRows);


            //4.释放资源
            connection.close();
            statement.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
```

#### 2. Delete 删除操作

```java
import org.junit.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-30 21:09
 * @Description: Delete 删除操作
 */
public class JDBCDemoDelete {
    @Test
    public void testDelete(){
        try {
            //1.加载驱动
            Class forName = Class.forName("com.mysql.jdbc.Driver");

            //2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","1234");

            //3.执行SQl
            String sql = "delete from  user where username = 'Tom'";
            Statement statement = connection.createStatement();
            int resultRows = statement.executeUpdate(sql,Statement.RETURN_GENERATED_KEYS);

            System.out.println("受影响行数： " + resultRows);

            //4.释放资源
            connection.close();
            statement.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
```

#### 3. Update 更新操作

```java
import	java.sql.DriverManager;
import org.junit.Test;
import java.sql.Connection;
import java.sql.Statement;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-06 17:08
 * @Description:
 */
public class JDBCDemoUpdate {
    @Test
    public void testUpdate() {
        try {
            // 1.加载驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql:///jdbc","root","1234");
            // 3.执行SQL
            String sql = "update user set password = 123456 where id = 3";
            Statement statement = connection.createStatement();
            // 返回结果
            int result = statement.executeUpdate(sql);
            System.out.println("受影响行数： " + result);
            //4.释放资源
            connection.close();
            statement.close();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```


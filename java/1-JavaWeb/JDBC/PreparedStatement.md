@[TOC](PreparedStatement解决SQL注入)
> 上一回我们通过[**JDBC实现数据库增删改查**](https://blog.csdn.net/weixin_43232955/article/details/98588055)，但是还是存在一个很大的问题. 今天七夕，我们不谈感情，只谈技术
> <img src = "https://img-blog.csdnimg.cn/20190807193828229.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "20%"> 
> 
### 1. Statement 存在的问题
<kbd>**要操作的用户**
username: zs
password: 123</kbd>


**知道用户名可以直接登录通过 " - - " 注释 SQL语句**

```java
package jdbc.injection;


import org.junit.Test;

import java.sql.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-07 11:53
 * @Description:Statement执行SQL会产生SQL注入
 */
public class SQLInjection01 {
    @Test
    public void test3() {
        try {
            // 1.加载驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc",
                            "root","1234");
            // 3.执行SQL
            String userName = "zs' --";
            String password = "fdfdfdfdf";
            String sql = "select * from user where username = '"+userName+" " +
                    "and password = '"+password+"' ";

            //知道用户名可以直接登录
            // 通过 -- 注释 SQL语句,password被注释
            // select * from user where username = 'zs' -- and password = 'fdfdfdfdf';

            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);
            // 遍历结果集
            if (resultSet.next()) {
                System.out.println("登录成功！");
            }else {
                System.out.println("登录失败！");
            }
            // 4.释放资源
            connection.close();
            statement.close();
            resultSet.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190807192050462.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
**通过 or 拆分SQL语句,一条语句变为两条**

```java
package jdbc.injection;


import org.junit.Test;

import java.sql.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-07 11:57
 * @Description:Statement执行SQL会产生SQL注入
 */
public class SQLInjection02 {
    @Test
    public void test3() {
        try {
            // 1.加载驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc",
                    "root","1234");
            // 3.执行SQL
            String userName = "zs'or 1 = 1";
            String password = "fdfdfdfdf";
            String sql = "select * from user where username = '"+userName+" " +
                    "and password = '"+password+"' ";

            //知道用户名可以直接登录
            // 通过 or 拆分SQL语句,一条语句变为两条,password不在验证
            // select * from user where username = 'zs' or 1 = 1 and password = 'fdfdfdfdf';

            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);
            // 遍历结果集
            if (resultSet.next()) {
                System.out.println("登录成功！");
            }else {
                System.out.println("登录失败！");
            }
            // 4.释放资源
            connection.close();
            statement.close();
            resultSet.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190807192438832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)


#### Stetement存在SQL注入漏洞，换用PreparedStatement(预处理SQL)

SQL注入: 在拼接SQL时 ，有一些SQL的特殊关键字参与字符窜的拼接. 会造成安全问题

```java
 // 3.执行 SQL
            String userName = "zs' --";
            String password = "fdfdfdfdf";
            String sql = "select * from user where username = '"+userName+" " +
                    "and password = '"+password+"' ";
```



```sql
select * from user where username = 'adkvnja' and password = 'a' or 'a' = 'a'
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190807191827601.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)


- Statement 是 PreparedStatement 的父接口

- Statement执行的是==静态==的SQL语句 

  - `select * from user where username = 'zs' and password = '1234' `在执行SQL时时拼接好的

- PrepareStatement执行的是==动态==的SQL语句(预编译SQL),**参数使用占位符替代**

  - `select * from user" + " where username = ? and password = ?`

  

- Statement执行SQL

```java
// Statement执行SQL

       String sql = "select * from user";
       statement = connection.createStatement();

       //查询的结果通过 ResultSet 放入到结果集中
       resultSet = statement.executeQuery(sql);
```



- Preparement执行SQL

```java
// Preparement执行SQL

      String userName = "zs";
      String password = "1234";
      String sql = "select * from user" + " where username = ? and password = ?";

      //预编译SQl
      PreparedStatement statement = connection.prepareStatement(sql);//传入SQL
      // 1表示对应第一个占位符
      statement.setString(1,userName);
      statement.setString(2,password);
      ResultSet resultSet = statement.executeQuery();//此时不需要传入SQL
```



### 2. PreparedStatement执行步骤

- 定义SQL
  - 注意：SQL的参数使用？作为占位符. 如：`select*from user where username=? and password=?`
- 获取执行SQL语句的对象
  - `Preparedstatement pstmt = connection.preparestatement(String sql)`//传入SQL
- 给 **？** 赋值：
  - 方法：`setxxx(参数1，参数2)`
  - 参数1：**?** 的位置编号从 1 开始
  - 参数2：**?**  的值
- 执行SQL，接收返回结果，不需要传递SQL语句
  - ` ResultSet resultSet = statement.executeQuery();//此时不需要传入SQL`



#### PreparedStatement使用Demo

```java
import org.junit.Test;

import java.sql.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-31 16:26
 * @Description:
 */
public class JDBCDemoSelectPlus {
    @Test
    public void testSelectPlus() {
        try {
            //1.加载驱动
            Class.forName("com.mysql.jdbc.Driver");

            //2.获取连接
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc","root","1234");

            //3.执行SQl

            String userName = "zs";
            String password = "1234";
            String sql = "select * from user" + " where username = ? and password = ?";

            //预编译SQl
            PreparedStatement statement = connection.prepareStatement(sql);
            // 1表示对应第一个占位符
            statement.setString(1,userName);
            statement.setString(2,password);
            ResultSet resultSet = statement.executeQuery();

            if(resultSet.next()) {
                System.out.println("Login Success!");
            }else {
                System.out.println("Login Failure...");
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
可以看到使用PreparedStatement替代Statement之后，一样可以登录成功
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190807192625646.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
那么，我们将密码修改为<kbd>asdnvjdvb</kbd>时，再次尝试登录
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190807192949331.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
登录失败！

----
<img src = "https://img-blog.csdnimg.cn/20190807194101614.jpg" width = "20%">

如果有不对的地方，欢迎指正！看到单身狗在孤独寂寞的学习，老铁能不能点个赞再走....

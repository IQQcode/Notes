### 1. MyBatis基于XML配置的动态SQL语句使用

**动态SQL语句使用：**根据实体类的不同取值，使用不同的SQL语句来进行查询

【使用场景】：

- 当我们查询表中某一字段时，可能不知道该字段是否有值；如果该字段没有值，则根据另一个条件查询
- 动态的添加查询条件，多个条件复合查询
- 比如在查询`id`时，如果不为空时可以根据``id`查询；如果`username`不为空时还要加入用户名作为条件

- [x] **if标签**
- [x] **where标签**
- [x] **foreach标签**

<kbd>IUserDao.xml</kbd>中添加SQL语句

无条件查询

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419180256.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419181355.png)

----------------------------------------------

#### if标签

**`<if>`**：如果查询的字段信息符合条件，则添加到查询条件中；

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419180714.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419181627.png)

如果`username`不为空则添加到查询语句中；``[ select * from user where username = “小猪佩奇”; ]``

如果`sex`不为空则添加到查询语句中；`[ select * from user where username = “小猪佩奇” and sex = “女”; ]`

#### where标签

**`<where>`**：如果条件很多时，用`<where>`简化书写

查询条件：有可能有用户名，有可能有性别，也有可能有地址，还有可能是都有

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419181943.png)

设置查询字段信息

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419182043.png)



#### foreach标签

**`<foreach>`**：根据查询集合中的条件只，进行范围查询

【例如】：

传入多个``id`查询用户信息，用下边两个sql实现： 

`SELECT * FROM USERS WHERE username LIKE '%张%' AND (id =10 OR id =89 OR id=16);`

`SELECT * FROM USERS WHERE username LIKE '%张%' AND id IN (10,89,16);`

 这样我们在进行范围查询时，就要将一个集合中的值，作为参数动态添加进来。 

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419183838.png)

<kbd>QueryVo</kbd>实体类

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419184027.png)

设置查询字段信息，查询id为 [ 41，42，50，51]

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419183926.png)



### 2. Mybatis多表查询

**MyBatis中的多表查询，表之间的关系有几种：**

- **一对一 [ 一对一关系映射: 从表实体应该包含一个主表实体的对象引用 ]**

- **一对多 [ 一对多关系映射: 主表实体应该包含从表实体的集合引用 ]**
- **多对多 [ 多对多关系映射: 两实体应该包含彼此的集合引用 ]**

> 多对一 [ Mybatis就把多对一看成了一对一 ]）

-----------------------------------

- [ ] 一个账户只能属于一个用户（多个账户也可以属于同一个用户，**一对一**）[ Mybatis就把多对一看成了一对一 ]
- [ ] 一个用户可以拥有多个用户（**一对多**）

【步骤】

1. 建立两张表：用户表 [ 主表 ]，账户表 [  从表 ]

2. 建立两个实体类：用户实体类和账户实体类
	- 让用户和账户的实体类能体现出来一对多的关系：需要使用外键在账户表中添加		
	- 让账户表和用户表之间具备一对一的关系	

3. 建立两个配置文件
	- 用户的配置文件
	- 账户的配置文件
					

4. 实现配置：
	- 当我们查询用户时，可以同时得到用户下所包含的账户信息（一对一）
	- 当我们查询账户时，可以同时得到账户的所属用户信息（一对多）

---------------------------------------------------------

#### 一对一

**一个账户只能属于一个用户**

**查询所有：**

```mysql
select u.*,a.id as aid,a.uid,a.money from account a , user u where u.id = a.uid;
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420120302.png)

**查询所有账户同时包含用户名和地址信息：**

```mysql
select a.*,u.username,u.address from account a , user u where u.id = a.uid;
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420120612.png)

<kbd>Account</kbd>账户实体类，账户与用户一对一

```java
@Data
public class Account implements Serializable {
    private int id;
    private int uid;
    private double money;

    //一对一关系映射: 从表实体应该包含一个主表实体的对象引用
    //主表为user,从表为account
    private User user;
}
```

<kbd>IAccountDao</kbd>

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-04-19 15:31
 * @Description:账户与用户一对一
 */
public interface IAccountDao {
    /**
     * 查询所有账户，同时还要获取到当前账户的所属用户信息
     * @return
     */
    List<Account> findAll();

    /**
     * 查询所有账户，并且带有用户名称和地址信息
     * @return
     */
    List<Account> findAccountUser();
}
```

<kbd>SqlMapConfig.xml</kbd>主配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 配置properties-->
    <properties resource="jdbcConfig.properties"/>

    <!--使用typeAliases配置别名，它只能配置domain中类的别名 -->
    <typeAliases>
        <package name="org.iqqcode.domain"/>
    </typeAliases>

    <!--配置环境-->
    <environments default="mysql">
        <!-- 配置mysql的环境-->
        <environment id="mysql">
            <!-- 配置事务 -->
            <transactionManager type="JDBC"/>
            <!--配置连接池-->
            <dataSource type="POOLED">
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>
    <!-- 配置映射文件的位置 -->
    <mappers>
        <package name="org.iqqcode.dao"/>
    </mappers>
</configuration>
```

<kbd>IAccountDao.xml</kbd>定义封装`Account`和`User`的 resultMap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="org.iqqcode.dao.IAccountDao">
    <!--定义封装account和user的resultMap-->
    <resultMap id="accountUserMap" type="Account">
        <id property="id" column="aid"/>
        <result property="uid" column="uid"/>
        <result property="money" column="money"/>
        <!--一对一的关系映射：配置封装user的内容-->
        <association property="user" column="uid" javaType="User">
            <id property="id" column="id"/>
            <result column="username" property="username"/>
            <result column="address" property="address"/>
            <result column="sex" property="sex"/>
        </association>
    </resultMap>

    <!--查询所有 -->
    <select id="findAll" resultMap="accountUserMap">
        select u.*,a.id as aid,a.uid,a.money from account a , user u where u.id = a.uid;
    </select>

    <!--查询所有账户同时包含用户名和地址信息-->
    <select id="findAccountUser" resultMap="accountUserMap">
        select a.*,u.username,u.address from account a , user u where u.id = a.uid;
    </select>
</mapper>
```

<kbd>AccountTest</kbd>测试类

```java
import org.iqqcode.dao.IAccountDao;
import org.iqqcode.domain.Account;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-11 09:45
 * @Description:测试类
 */
public class AccountTest {
    private InputStream in;
    private SqlSession sqlSession;
    private IAccountDao accountDao;

    /**
     * 初始化
     */
    @Before //用于在测试方法之前执行
    public void init() throws IOException {
        //1.读取配置文件，生成字节输入流
        in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //2.获取SqlSessionFactory
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(in);
        //3.获取SqlSession对象
        sqlSession = factory.openSession();
        //4.获取dao代理对象
        accountDao = sqlSession.getMapper(IAccountDao.class);
    }

    @After //用于在测试方法之后执行
    public void destroy() throws IOException {
        //5.提交事务
        sqlSession.commit();
        //6.释放资源
        sqlSession.close();
        in.close();
    }

    /**
     * 测试查询所有用户
     * @throws IOException
     */
    @Test
    public void testFindAll() throws IOException {
        List<Account> accs = accountDao.findAll();
        for (Account acc : accs) {
            System.out.println(acc);
        }
    }

    /**
     * 查询所有账户，并且带有用户名称和地址信息
     * @throws IOException
     */
    @Test
    public void testFindAccountUser() throws IOException {
        List<Account> accs = accountDao.findAccountUser();
        for (Account acc : accs) {
            System.out.println(acc);
        }
    }
}
```

表中查询出的重复MyBatis会总动整合

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420122558.png)

-----------------------------------------------------------------------------------------------------------------

#### 一对多

**一个用户可以拥有多个账户**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420123356.png)

**查询所有用户，同时获取到用户下所有账户的信息**

```mysql
select * from user u left outer join account a on u.id = a.uid
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420123746.png)

<kbd>User</kbd>用户实体类，用户与账户一对多

```java
@Data
public class User implements Serializable {
    private int id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;

    //一对多关系映射: 主表实体应该包含从表实体的集合引用
    //主表为user,从表为account
    private List<Account> accounts;
}
```

<kbd>IUserDao</kbd>

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-04-11 09:41
 * @Description:用户与账户一对一
 */
public interface IUserDao {
    /**
     * 查询所有用户，同时获取到用户下所有账户的信息
     * @return
     */
    List<User> findAll();
}
```

<kbd>IUserDao.xml</kbd>定义封装`Account`和`User`的 resultMap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="org.iqqcode.dao.IUserDao">
    <!--定义User的resultMap-->
    <resultMap id="userAccountMap" type="User">
        <id property="id" column="id"/>
        <result property="username" column="username"></result>
        <result property="address" column="address"></result>
        <result property="sex" column="sex"></result>
        <result property="birthday" column="birthday"></result>
        <!--配置user对象中accounts集合的映射 -->
        <collection property="accounts" ofType="Account">
            <id column="aid" property="id"></id>
            <result column="uid" property="uid"></result>
            <result column="money" property="money"></result>
        </collection>
    </resultMap>

    <!--查询所有用户，同时获取到用户下所有账户的信息-->
    <select id="findAll" resultMap="userAccountMap">
        select * from user u left outer join account a on u.id = a.uid
    </select>
</mapper>
```

<kbd>AccountTest</kbd>测试类

```java
    @Test
    public void testFindAll() throws IOException {
        List<User> users = userDao.findAll();
        for (User user : users) {
            System.out.println("---------------------------------------------");
            System.out.println(user);
            System.out.println(user.getAccounts());
        }
    }
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420123145.png)



#### 多对多

------------------------------------------------

- [x] 一个用户可以有多个角色
- [x] 一个角色可以赋予多个用户		

【步骤】

1. 建立两张表：用户表，角色表

	- 让用户表和角色表具有多对多的关系。

	- 需要使用中间表，中间表中包含各自的主键，在中间表中是外键。

2. 建立两个实体类：用户实体类和角色实体类
	- 让用户和角色的实体类能体现出来多对多的关系
	- 各自包含对方一个集合引用	

3. 建立两个配置文件
	- 用户的配置文件
	- 角色的配置文件

4. 实现配置：
	- 当我们查询用户时，可以同时得到用户所包含的角色信息
	- 当我们查询角色时，可以同时得到角色的所赋予的用户信息

-----------------------------------------------------------------------------------------

**一个用户可以拥有多个角色，一个角色可以赋予多个用户		**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420125204.png)

**查询所有用户，同时获取到用户下所有角色的信息**

```mysql
SELECT
		p.*,
		r.id AS rid,
		r.ROLE_NAME,
		r.role_DESC
FROM
		person p
				LEFT OUTER JOIN person_role pr ON p.id = pr.uid
        LEFT OUTER JOIN role r ON r.id = pr.rid
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420125445.png)

**查询所有角色，同时获取到角色下所有用户的信息**

```mysql
SELECT
		p.*,
		r.id AS rid,
		r.role_name,
		r.role_desc
FROM
		role r
				LEFT OUTER JOIN person_role pr ON r.id = pr.rid
				LEFT OUTER JOIN person p ON p.id = pr.uid
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420125855.png)

-----------------------------------------------------

<kbd>Person</kbd>用户实体类，用户与角色多对多

```java
@Data
public class Person implements Serializable {
    private int id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;

    //多对多的关系映射：一个用户可以具备多个角色
    //user表，role表，person_role表为连接两表
    private List<Role> roles;
}
```

<kbd>Role</kbd>角色实体类，用户与角色多对多

与表中字段不一致，需要在映射中添加 resultMap

```java
@Data
public class Role {
    private Integer roleId;
    private String roleName;
    private String roleDesc;

    //多对多的关系映射：一个角色可以赋予多个用户
    //user表，role表，person_role表为连接两表
    private List<Person> persons;
}
```

<kbd>IPersonDao</kbd>

```java
public interface IPersonDao {
    /**
     * 查询所有用户，同时获取到用户下所有角色的信息
     * @return
     */
    List<Person> findAll();
}
```

<kbd>IRoleDao</kbd>

```java
public interface IRoleDao {
    /**
     * 查询所有角色，同时获取到角色下所有用户的信息
     * @return
     */
    List<Role> findAll();
}
```

<kbd>IPersonDao.xml</kbd>定义封装`Person`和`Role`的 resultMap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.iqqcode.dao.IPersonDao">
    <!--定义role表的ResultMap-->
    <resultMap id="personMap" type="Person">
        <id property="id" column="id"></id>
        <result property="username" column="username"></result>
        <result property="address" column="address"></result>
        <result property="sex" column="sex"></result>
        <result property="birthday" column="birthday"></result>
        <!-- 配置角色集合的映射 -->
        <collection property="roles" ofType="Role">
            <id property="roleId" column="rid"></id>
            <result property="roleName" column="role_name"></result>
            <result property="roleDesc" column="role_desc"></result>
        </collection>
    </resultMap>

    <!-- 查询所有 -->
    <select id="findAll" resultMap="personMap">
        SELECT
            p.*,
            r.id AS rid,
            r.ROLE_NAME,
            r.role_DESC
        FROM
            person p
                LEFT OUTER JOIN person_role pr ON p.id = pr.uid
                LEFT OUTER JOIN role r ON r.id = pr.rid
    </select>
</mapper>
```

<kbd>IPersonDao.xml</kbd>定义封装`Person`和`Role`的 resultMap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="org.iqqcode.dao.IRoleDao">
    <!--定义role表的ResultMap-->
    <resultMap id="roleMap" type="Role">
        <id property="roleId" column="rid"></id>
        <result property="roleName" column="role_name"></result>
        <result property="roleDesc" column="role_desc"></result>
        <collection property="persons" ofType="Person">
            <!--配置用户集合映射-->
            <id column="id" property="id"></id>
            <result column="username" property="username"></result>
            <result column="address" property="address"></result>
            <result column="sex" property="sex"></result>
            <result column="birthday" property="birthday"></result>
        </collection>
    </resultMap>

    <!-- 查询所有 -->
    <select id="findAll" resultMap="roleMap">
        SELECT
            p.*,
            r.id AS rid,
            r.role_name,
            r.role_desc
        FROM
            role r
                LEFT OUTER JOIN person_role pr ON r.id = pr.rid
                LEFT OUTER JOIN person p ON p.id = pr.uid
    </select>
</mapper>
```

<kbd>PersonTest</kbd>测试类

```java
		@Test
    public void testFindAll() throws IOException {
        List<Person> pers = personDao.findAll();
        for (Person per : pers) {
            System.out.println("---------------------------------------------");
            System.out.println(per);
            System.out.println(per.getRoles());
        }
    }
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420130931.png)

<kbd>RoleTest</kbd>测试类

```java
@Test
    public void testFindAll() throws IOException {
        List<Role> roles = roleDao.findAll();
        for (Role role : roles) {
            System.out.println("--------------每个角色的信息---------------");
            System.out.println(role);
            System.out.println(role.getPersons());
        }
    }
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420131154.png)



### 3. JNDI数据源

**连接池：**可以减少获取连接所消耗的时间
#### MyBatis中的连接池

MyBatis连接池提供了3种方式的配置：

配置的位置：主配置文件**SqlMapConfig.xml*中的`dataSource`标签，`type`属性就是表示采用何种连接池方式

type属性的取值：

- **POOLED：**采用传统的`javax.sql.DataSource`规范中的连接池，mybatis中有针对规范的实现

- **UNPOOLED：**采用传统的获取连接的方式，并没有使用连接池的思想
- **JNDI：**采用服务器提供的JNDI技术实现，来获取`DataSource`对象，不同的服务器所能拿到DataSource是不一样。

> 注意：如果不是web或者maven的war工程，是不能使用的。
>
> Tomcat服务器，采用的连接池就是**dbcp**连接池。

JNDI：Java Naming and Directory Interface。是SUN公司推出的一套规范，属于JavaEE技术之一。目的是模仿windows系统中的注册表， 在服务器中注册数据源

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420133017.png)



#### JNDI使用

创建Maven的war工程并导入坐标

**META-INF目录中建立一个名为context.xml的配置文件**

> – wedapp
>
> ​			– META-INF
>
> ​						– context.xml

- 数据源的名称：name="jdbc/iqqcode_jndi [ jdbc/下名称自定义 ]"						
- 数据源类型：type="javax.sql.DataSource"						
- 数据源提供者：auth="Container"								
- 最大活动数：maxActive="20"									
- 最大等待时间：maxWait="10000"									
- 最大空闲数：maxIdle="5"										
- 用户名：username="root"									
- 密码：password="1234"									
- 驱动类：driverClassName="com.mysql.jdbc.Driver"			
- 连接url字符串：url="jdbc:mysql://localhost:3306/eesy_mybatis"	

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <Resource
            name="jdbc/iqqcode_jndi"
            type="javax.sql.DataSource"
            auth="Container"
            maxActive="20"
            maxWait="10000"
            maxIdle="5"
            username="root"
            password="1234"
            driverClassName="com.mysql.jdbc.Driver"
            url="jdbc:mysql://localhost:3306/db_mybatistest"
    />
</Context>
```



**修改SqlMapConfig.xml中的配置**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420134302.png)

> 实体类，Dao，映射配置文件参考前文！

**配置Tomcat，在JSP中添加测试类**

```html
<%@ page import="org.apache.ibatis.io.Resources" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactoryBuilder" %>
<%@ page import="org.iqqcode.dao.IUserDao" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>
<%@ page import="org.iqqcode.domain.User" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<body>
<h2>JNTI Test</h2>
    <%
        //读取配置文件，生成字节输入流
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        //获取SqlSessionFactory
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(in);
        //获取SqlSession对象
        SqlSession sqlSession = factory.openSession();
        //获取dao代理对象
        IUserDao userDao = sqlSession.getMapper(IUserDao.class);

        List<User> users = userDao.findAll();
        for (User user : users) {
            System.out.println(user);
        }
        sqlSession.commit();
        sqlSession.close();
        in.close();
    %>
</body>
</html>
```

启动Tomcat，查看输出

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420134630.png)
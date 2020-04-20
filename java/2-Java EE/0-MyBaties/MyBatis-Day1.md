### 1. 框架的概念

**什么是框架？**

- 框架就是一个半成品软件，它是软件开发中的一套解决方案，不同的框架解决的是不同的问题。

**为什么要使用框？**
使用框架的好处：

- 框架封装了很多的细节，使开发者可以使用极简的方式实现功能，大大提高开发效率。

**框架要解决的问题是什么？**

- 实现技术解耦。将研发将集中在应用的设计上，而不是具体的技术实现。

### 2. MyBatis 框架概述

【官方文档】

> [MyBatis](https://mybatis.org/mybatis-3/zh/index.html) 是一款优秀的持久层框架，它支持自定义 SQL、存储过程以及高级映射。MyBatis 免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO（Plain Old Java Objects，普通老式 Java 对象）为数据库中的记录。

MyBatis 是一个优秀的基于 java 的持久层框架，它内部封装了 JDBC，使开发者只需要关注 SQL语句本身，而不需要花费精力去处理加载驱动、创建连接、创建 Statement 等繁杂的过程。

MyBatis通过`xml`或注解的方式将要执行的各种 Statement 配置，并通过 java对象和 Statement 中 SQL 的**动态参数**进行**映射**生成最终执行的SQL语句，最后由 MyBatis 框架执行 SQL并将结果**映射**为 java 对象并返回。

MyBatis采用 ORM 思想解决了实体和数据库映射的问题，对JDBC进行了封装，屏蔽了JDBC API底层访问细节，不用与 JDBC API打交道，就可以完成对数据库的持久化操作。

> **ORM**：Oject Relational Mapping 对象关系映射
> 
> 简单的说：就是把数据库表和实体类及实体类的属性对应起来让我们可以操作实体类就实现操作数据库表

在JavaBean对象的实体类中属性和数据库表的字段名称要保持一致

| DB_Table | JavaBean |
|:--------:|:--------:|
| user     | user     |
| id       | id       |
| username | username |

### 3. 持久层技术解决方案

**JDBC技术**

- Connection获取连接

- Preparedstatement 执行SQL语句

- Resultset 封装结果集对象

**SpringJdbcTemplate** 

- Spring中对JDBC的简单封装

**Apache DBUtils**

- 它和 Spring的 JabcTemplate很像，也是对JDBC的简单封装

以上这些都不是框架，JDBC是规范。Spring的`JdbcTemplate`和 Apache的`DBUtils`都只是工具类

### 4. MyBatis入门案例

<font color=pink>**Dao层下的接口无实现类，简化开发**</font>

#### 环境搭建的注意事项

1. 创建`IUserDao.xml`和 `IUserDao.java`时名称是为了和MVC以及三层架构的目录结构保持一致。在 Mybatis中它把持久层的映射文件也叫做：**Mapper**。所以：`IUserDao`和 `IUserMapper`是一样的

2. 在resource中创建MyBatis的映射配置文件时，MaBatis的映射配置文件位置必须和Dao接口的包结构相同（比如均为org.iqqcode.dao）

3. 映射配置文件的**mapper**标签的`namespace`属性的取值必须是dao接口的**全限定类名**

4. 映射配置文件的操作配置（ select），id属性的取值必须是dao接口的方法名

> 当我们遵从了以上约定之后，我们在开发中就无须再写dao的实现类，剩下的功能将由MyBatis实现

#### 基于xml配置

MaBatis 基于xml环境搭建【目录结构】：

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408153616.png)

**第一步：创建maven工程并导入坐标**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.iqqcode</groupId>
    <artifactId>MyBatis_SectionI</artifactId>
    <version>1.0-SNAPSHOT</version>
    <!--打包方式-->
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.4.5</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.6</version>
        </dependency>
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.12</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.10</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.10</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>

</project>
```

**第二步：创建实体类和dao的接口**

<kbd>User</kbd>用户实体类

```java
//实现Serializable接口，将对象序列化
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User implements Serializable {
    private int id;
    private String name;
    private Date birthday;
    private String sex;
    private String address;
}
```

<kbd>IuserDao</kbd>用户持久层接口(数据访问层)

```java
public interface IUserDao {
    /**
     * 查询所有操作
     * @return
     */
    List<User> findAll();
}
```

**第三步：创建Mybatis的主配置文件`SqlmapConifg.xml`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<!--MyBatis主配置文件-->
<configuration>
    <!--配置环境-->
    <environments default="mysql">
        <!--配置MySQL环境-->
        <environment id="mysql">
            <!--配置事务类型-->
            <transactionManager type="JDBC"></transactionManager>
            <!--配置数据源(连接池)-->
            <dataSource type="POOLED">
                <!--配置连接数据库的基本信息-->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/db_mybatistest"/>
                <property name="username" value="root"/>
                <property name="password" value="1234"/>
            </dataSource>
        </environment>
    </environments>

    <!--指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件-->
    <mappers>
        <mapper resource="org/iqqcode/dao/IUserMapper.xml"/>
    </mappers>
</configuration>
```

**第四步：创建映射配置文件`IUserMapper. xml`**

> 此处包的路径一定要和dao层下的IUserDao保持一致，否则会出现
> 
> <font color=red>Cause: org.apache.ibatis.builder.BuilderException: Error parsing SQL Mapper</font>的错误

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="org.iqqcode.dao.IUserDao">
    <!--配置查询所有-->
    <select id="findAll" resultType="org.iqqcode.domain.User">
        select * from user
    </select>
</mapper>
```

<kbd>log4j.properties</kbd>

```xml
# Set root category priority to INFO and its only appender to CONSOLE.
#log4j.rootCategory=INFO, CONSOLE            debug   info   warn error fatal
log4j.rootCategory=debug, CONSOLE, LOGFILE

# Set the enterprise logger category to FATAL and its only appender to CONSOLE.
log4j.logger.org.apache.axis.enterprise=FATAL, CONSOLE

# CONSOLE is set to be a ConsoleAppender using a PatternLayout.
log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern=%d{ISO8601} %-6r [%15.15t] %-5p %30.30c %x - %m\n

# LOGFILE is set to be a File appender using a PatternLayout.
log4j.appender.LOGFILE=org.apache.log4j.FileAppender
log4j.appender.LOGFILE.File=d:\axis.log
log4j.appender.LOGFILE.Append=true
log4j.appender.LOGFILE.layout=org.apache.log4j.PatternLayout
log4j.appender.LOGFILE.layout.ConversionPattern=%d{ISO8601} %-6r [%15.15t] %-5p %30.30c %x - %m\n
```

-----------------------

**测试**

<kbd>MyBatisXmlTest</kbd>

```java
package com.iqqcode.test;

import org.iqqcode.dao.IUserDao;
import org.iqqcode.domain.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-08 13:59
 * @Description:入门测试案例--Annotation
 */
public class MyBatisAnnotationTest {
    public static void main(String[] args) throws IOException {
        //1.读取配置文件
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");

        //2.创建SqlSessionFactory工厂
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        SqlSessionFactory factory = builder.build(in);

        //3.使用工厂生产SqlSession对象
        /**此时session可以操纵数据库了，但是我们要用Dao来操纵数据库，所以产生Dao代理对象**/
        SqlSession session = factory.openSession();

        //4.使用SqlSession创建Dao接口的代理对象
        IUserDao userDao = session.getMapper(IUserDao.class);

        //5.使用代理对象执行方法
        List<User> users = userDao.findAll();
        for (User user : users) {
            System.out.println(user);
        }

        //6.释放资源
        session.close();
        in.close();
    }
}
```

----------------------------

执行结果，打印User表内容

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408152619.png)

------------------------------

#### 基于Annotation配置

**把resources下的`IUserDao.xml`移除**

![](E:\MarkText\Cache-img\2020-04-08-16-18-04-image.png)

**在Dao接口的方法上使用`@Select`注解**

```java
public interface IUserDao {
    /**
     * 查询所有操作
     * @return
     */
    @Select("select * from user")
    List<User> findAll();
}
```

**并且指定SQL语句时在`SqlmapConfig.xml`中的 mapper配置使用`class`属性指定dao接口的全限定类名**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408161816.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<!--MyBatis主配置文件-->
<configuration>
    <!--配置环境-->
    <environments default="mysql">
        <!--配置MySQL环境-->
        <environment id="mysql">
            <!--配置事务类型-->
            <transactionManager type="JDBC"></transactionManager>
            <!--配置数据源(连接池)-->
            <dataSource type="POOLED">
                <!--配置连接数据库的基本信息-->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/db_mybatistest"/>
                <property name="username" value="root"/>
                <property name="password" value="1234"/>
            </dataSource>
        </environment>
    </environments>

    <!--指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件
    如果是用注解来配置的话，此处应该使用class属性指定被注解的dao全限定类名-->
    <mappers>
        <mapper class="org.iqqcode.dao.IUserDao"/>
    </mappers>
</configuration>
```

-----------------------------

<font color=pink>**Dao层下的接口有实现类**</font>

<kbd>UserDaoImpl</kbd>

```java
public class UserDaoImpl implements IUserDao {

    private SqlSessionFactory factory;

    public UserDaoImpl(SqlSessionFactory  factory){
        this.factory = factory;
    }

    public List<User> findAll(){
        //1.使用工厂创建SqlSession对象
        SqlSession session = factory.openSession();
        //2.使用session执行查询所有方法
        List<User> users = session.selectList("org.iqqcode.dao.IUserDao.findAll");
        session.close();
        //3.返回查询结果
        return users;
    }
}
```

-------------------------

**测试类**

<kbd>DaoImplementsTest</kbd>

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-04-08 16:27
 * @Description:dao有实现类测试
 */
public class DaoImplementsTest {
    public static void main(String[] args) throws IOException {
        //1.读取配置文件
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");

        //2.创建SqlSessionFactory工厂
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        SqlSessionFactory factory = builder.build(in);

        //3.使用工厂创建dao对象
        IUserDao userDao = new UserDaoImpl(factory);

        //4.使用代理对象执行方法
        List<User> users = userDao.findAll();
        for(User user : users){
            System.out.println(user);
        }
        //5.释放资源
        in.close();
    }
}
```

### 5. MyBatis入门案例分析

**第一步：读取配置文件**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408171140.png)

在开发中，我们并不是通过写路径名来读取到配置文件的，而是动态获取路径

- 绝对路径：`G:\Test\Config`

> 如果此电脑无G盘，或者操作系统不同盘符不同则无法找到配置文件

- 相对路径：`src/main/resources`

> 如果此项目部署在服务器上，则不存在src目录，文件无法找到

正确的做法应该是：

1. 使用类加载器（只能获取类路径的配置文件）

2. 使用**servletContext**对象的`getRealPath()`

-------------------------------------------------------------

**第二步：创建SqlSessionFactory工厂**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408171225.png)

创建工厂MyBatis使用了<font color=blueeee>构建者模式</font>，`builder`就是构建者

把繁琐的细节封装起来，让构建者去实现

> 构建者模式：把对象的 创建细节隐藏，直接调用方法拿到对象

**第三步：创建 SqlSession**

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408171240.png)

生产者SqlSession使用了工厂模式，而不是直接`new`，降低了类之间的耦合度

**第四步：创建Dao接口的代理对象**

![](E:\MarkText\Cache-img\2020-04-08-17-12-59-image.png)

`getMapper(IUserDao.class)`创建Dao接口实现类使用了代理模式

> 优势：在不修改源码的基础上对已有方法功能增强

第五步：执行dao中的方法

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200408171312.png)

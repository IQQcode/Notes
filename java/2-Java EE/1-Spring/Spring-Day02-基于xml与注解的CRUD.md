## 1. 基于XML连接DBUtils的CRUD

> CRUD它又双来了...

对表**spring__user**进行增删改查

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501160638.png)

代码都是增删改查的语句很简单，关键是配置信息。

**0. Pom.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.iqqcode</groupId>
    <artifactId>03_AnnoDemo_CRUD</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>sprin应用程序的入口main方法。 Junit单元测试中，没有main方法也能执行Junit集成了一个main方法，该方法就会判断当前测试类中哪些方法有@Test注解，Junt就让有Test注解的方法执行
 Junit不会管我们是否采用 spring框架，在执行测试方法时， Junit根本不知道我们是不是使用了 spring框架，所以也就不会为我们读取配置文件/配置类创建 spring核心容器
由以上三点可知当测试方法执行时，没有Ioc容器，就算写了 Autowired注解，也无法实现注入g-test</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>commons-dbutils</groupId>
            <artifactId>commons-dbutils</artifactId>
            <version>1.7</version>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>
        <dependency>
            <groupId>c3p0</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.1.2</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.10</version>
        </dependency>
    </dependencies>

</project>
```

**1. 用户实体类User**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501161702.png)

**2. dao层UserDao**

<kbd>UserDao</kbd>接口

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501161715.png)

<kbd>UserDaoImpl</kbd>

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501161838.png)

**3. service层UserService**

<kbd>UserService</kbd>接口

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501161850.png)

<kbd>UserServiceImpl</kbd>

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501161940.png)

**4. bean.xml**

- ref属性引入其他bean类

- 采用构造方法注入DBUtils连接池工具类

- 采用Setter注入c3p0连池

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- 配置Service -->
    <bean id="userService" class="org.iqqcode.service.impl.UserServiceImpl">
        <!-- 注入dao -->
        <property name="userDao" ref="userDao"/>
    </bean>

    <!--配置Dao对象-->
    <bean id="userDao" class="org.iqqcode.dao.impl.UserDaoImpl">
        <!-- 注入QueryRunner -->
        <property name="run" ref="run"/>
    </bean>

    <!--配置QueryRunner-->
    <bean id="run" class="org.apache.commons.dbutils.QueryRunner" scope="prototype">
        <!--注入数据源-->
        <constructor-arg name="ds" ref="dataSource"/>
    </bean>

    <!-- 配置数据源 -->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <!--连接数据库的必备信息-->
        <property name="driverClass" value="com.mysql.jdbc.Driver"/>
        <property name="jdbcUrl" value="jdbc:mysql://localhost:3306/db_test?characterEncoding=utf-8&amp;useSSL=false"/>
        <property name="user" value="root"/>
        <property name="password" value="1234"/>
    </bean>
</beans>
```

**5. 单元测试类**

```java
package org.iqqcode.test;

import org.iqqcode.domain.User;
import org.iqqcode.service.UserService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-30 11:24
 * @Description:测试xml--CRUD
 */
public class UserServiceTest {
    @Test
    public void testFindAll() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        UserService us = ac.getBean("userService", UserService.class);
        List<User> users = us.findAll();
        for (User user : users) {
            System.out.println(user);
        }
    }

    @Test
    public void testFindOne() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        UserService us = ac.getBean("userService", UserService.class);
        User user = us.findUserById(1);
        System.out.println(user);
    }
    @Test
    public void testSava() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        UserService us = ac.getBean("userService", UserService.class);
        User user = new User();
        user.setName("Java");
        user.setAge(22);
        us.saveUser(user);
    }

    @Test
    public void testUpdate() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        UserService us = ac.getBean("userService", UserService.class);
        User user = us.findUserById(4);
        user.setName("Python");
        us.updateUser(user);
    }

    @Test
    public void testDelete() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        UserService us = ac.getBean("userService", UserService.class);
        us.deleteUser(4);
    }
}
```

## 2. 基于注解的CRUD

通过注解配置类来取代`applicationContext.xml`配置文件

> 上述代码更改

**0. 首先删除applicationContext.xml**

### 创建对象的更改

他们的作用就和在XML配置文件中编写一个`<bean>`标签实现的功能是一样的

**1. UserDaoImpl**

- 添加@Component注解，将实现类对象存入Spring容器

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501163709.png)

**2. UserServiceImpl**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501163750.png)

### 与配置相关的注解

创建**config**包，存放配置类信息

主配置类`SpringConfiguration`来管理其他子配置类`JdbcConfig`

<kbd>SpringConfiguration</kbd>

```java
package org.iqqcode.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-30 17:12
 * @Description:该类是一个配置类，它的作用和bean.xml是一样的
 */
@ComponentScan("org.iqqcode")
@Import(JdbcConfig.class)
@PropertySource("classpath:jdbcConfig.properties")
public class SpringConfiguration {  }

```

<kbd>jdbcConfig</kbd>

```java
package org.iqqcode.config;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.dbutils.QueryRunner;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;

import javax.sql.DataSource;
import java.beans.PropertyVetoException;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-30 17:29
 * @Description:和Spring连接数据库相关的配置类
 */
public class JdbcConfig {

    @Value("${jdbc.driver}")
    private String driver;

    @Value("${jdbc.url}")
    private String url;

    @Value("${jdbc.username}")
    private String username;

    @Value("${jdbc.password}")
    private String password;

    /**
     * 创建一个QueryRunner对象
     * @param dataSource
     * @return
     */
    @Bean(name = "run")
    @Scope("prototype")
    public QueryRunner createQueryRunner(@Qualifier("ds1") DataSource dataSource) {
        return new QueryRunner(dataSource);
    }

    @Bean(name = "ds1")
    public DataSource createDataSource() {
        try {
            ComboPooledDataSource ds = new ComboPooledDataSource();
            ds.setDriverClass(driver);
            ds.setJdbcUrl(url);
            ds.setUser(username);
            ds.setPassword(password);
            return ds;
        } catch (PropertyVetoException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
```

resources下创建 **jdbcConfig.properties**连接数据库信息

```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/db_test?characterEncoding=utf-8&useSSL=false
jdbc.username=root
jdbc.password=root
```

## 3. spring-text单元测试

应用程序的入口**main**方法。 Junit单元测试中，没有main方法也能执行Junit集成了一个main方法，该方法就会判断当前测试类中哪些方法有`@Test`注解，Junt就让有Test注解的方法执行


 Junit不会管我们是否采用 spring框架，在执行测试方法时， Junit根本不知道我们是不是使用了 spring框架，所以也就不会为我们读取配置文件/配置类创建 spring核心容器
由以上三点可知当测试方法执行时，没有Ioc容器，就算写了 Autowired注解，也无法实现注入



### 使用spring-test单元测试

Spring整合Junit的配置


1. 导入Junti的jar包

2. 使用 Junit提供的@RunWith注解把原有的main方法替换成 spring提供的

3. 告知 spring的运行器，spring和IoC创建是基于XML还是注解的，并且说明位置
   
    - @Context Confiquration Locations：指定XML文件的位置，加上 cLasspath关键字，表示在类路径下
   
    - classes：指定注解类所在地位置


当我们使用 spring5.x版本的时候，要求Junit的jar必须是4.12及以上

**使用spring-test对上面单元测试的改进**

```java
package org.iqqcode.test;

import org.iqqcode.config.SpringConfiguration;
import org.iqqcode.domain.User;
import org.iqqcode.service.UserService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * @Author: Mr.Q
 * @Date: 2020-04-30 11:24
 * @Description:使用Spring-Junit单元测试
 * Spring整合junit的配置
 *      1、导入spring整合junit的jar(坐标)
 *      2、使用Junit提供的一个注解把原有的main方法替换了，替换成spring提供的@Runwith
 *      3、告知spring的运行器，spring和ioc创建是基于xml还是注解的，并且说明位置
 *          @ContextConfiguration
 *                  locations：指定xml文件的位置，加上classpath关键字，表示在类路径下
 *                  classes：指定注解类所在地位置
 *
 *   当我们使用spring 5.x版本的时候，要求junit的jar必须是4.12及以上
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = SpringConfiguration.class)
public class UserService_SpringTest {

    @Autowired
    private UserService us = null;

    @Test
    public void testFindAll() {
        List<User> users = us.findAll();
        for (User user : users) {
            System.out.println(user);
        }
    }

    @Test
    public void testFindOne() {
        User user = us.findUserById(1);
        System.out.println(user);
    }
    @Test
    public void testSava() {
        User user = new User();
        user.setName("Java");
        user.setAge(22);
        us.saveUser(user);
    }

    @Test
    public void testUpdate() {
        User user = us.findUserById(4);
        user.setName("Python");
        us.updateUser(user);
    }

    @Test
    public void testDelete() {
        us.deleteUser(4);
    }
}
```

@[TOC](SpringFramework简介)
### 1. Spring介绍

- **Spring是一个开源框架，是为了解决企业应用程序开发复杂性而创建的**
- **Spring以IoC、AOP为主要思想构建的JavaEE框架**
- **Spring是一个“一站式”框架，即Spring在JavaEE的三层架构：表现层（Web层）、业务逻辑层（Service
  层）、数据访问层（DAO即Data Access Object ) 中，每一层均提供了不同的解决技术****
- **Spring: 控制class 与 class之间的关系**
- **Spring是容器，是框架，也是技术**

[**Spring官网**](https://spring.io/)

**Spring框架提供的模块：**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190731224240198.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)



### 2. Spring核心思想

#### 2.1 基本概念

- IoC( Inversion of Control )：控制反转，将创建对象的权力和生命周期的管理过程交付给Spring框架来处理;

  在开发过程中不再需要关注对象的创建和生命周期的管理，在需要的时候由Spring框架提供

- IoC容器：实现了IoC思想的容器就是IoC容器，比如：SpringFremework

- DI( Dependency Injection )：在创建对象的过程中Spring依据配置对==对象==进行属性设置，那么这个过程称之为依赖注入

#### 2.2 IoC容器的特点

- 无需主动new对象
- 不需要主动装配对象之间的依赖关系；
- 迪米特法则：（面向抽象编程），松散耦合，一个对象应当对其它对象有尽可能少的了解

**IoC是一种让消费者不直接依赖于服务提供者的组件设计方式，是一种减少类与类之间依赖的设计原则**

#### 2.3 理解IoC容器

容器：提供组件运行环境，管理组件生命周期

- 谁控制谁？为什么叫反转？
  答：IoC容器控制，而以前是应用程序控制，所以叫反转
- 控制什么？
  答：控制应用程序所需要的资源（对象、文件……）
- 为什么控制？
  答：解耦组件之间的关系
- 控制的哪些方面被反转了？
  答：程序的控制权发生了反转，从应用程序转移到了IoC容器

#### 2.4 理解DI

- 谁依赖于谁？
  答：应用程序依赖于IoC容器
- 为什么需要依赖？
  答：应用程序依赖于IoC容器装配类之间的关系
- 依赖什么东西？
  答：依赖了IoC容器的装配功能
- 谁注入于谁？
  答：IoC容器注入应用程序
  特点说明
- 注入什么东西？
  答：注入应用程序需要的资源（类之间的关系）



### 3. Spring框架的特点

|     特点     | 说明                                                         |
| :----------: | ------------------------------------------------------------ |
|    轻量级    | Spring在大小和透明性方面属于轻量级的                         |
|   控制反转   | Spring使用控制反转技术实现了松耦合。依赖被注入到对象，而不是创建或寻找依赖对象 |
| 面向切面编程 | Spring支持面向切面编程，同时把应用的业务逻辑与系统的服务分离开来 |
|     容器     | Spring包含并管理应用程序对象的配置及生命周期                 |
|   MVC框架    | Spring的web框架是一个设计优良的Web MVC框架，很好的取代了一些web框架 |
|   事务管理   | Spring对下至本地业务上至全局业务(JAT)提供了统一的事务管理接口 |
|   异常处理   | Spring提供一个方便的API将特定技术的异常(由JDBC, Hibernate, 或JDO抛出)转化为一致的、 Unchecked异常 |



### 4. Spring简单案例
我们先来定义`class UserInfo`

```java
public class UserInfo {
    private String username;

    public UserInfo() { }

    public UserInfo(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String helloWorld() {
        return "Hello Spring! " + username;
    }
}

```
再定义`class DemoTest`

```java
public class DemoTest {
    public static void main(String[] args) {
       UserInfo userInfo = new UserInfo();
        userInfo.setUsername("  Mr.Q");
        String result = userInfo.helloWorld();
        System.out.println(result);
    }
}
```
实例化`UserInfo`之后，我们便拿到了`UserInfo`的属性并输出
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190801152745100.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
以上的操作过程为：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190801152346219.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
那我们试着解耦，让它们不再是强依赖的关系，进行解耦操作：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019080115372653.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
把这俩个类的关系交给SpringIoC来做

通过控制反转，将创建对象的权力和生命周期的管理过程交付给Spring框架来处理

**Framework Demo**
<img src = "https://img-blog.csdnimg.cn/20190801154545760.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "50%">

`UserInfo`
```java
/**
 * @Author: Mr.Q
 * @Date: 2019-07-26 08:31
 * @Description:
 */

public class UserInfo {
    private String username;

    public UserInfo() { }

    public UserInfo(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    /**
     * DI
     * @param username
     */
    public void setUsername(String username) {
        this.username = username;
    }

    public String helloWorld() {
        return "Hello Spring! " + username;
    }
}
```
`DemoTest`

```java
package com.iqqcode.bean;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @Author: Mr.Q
 * @Date: 2019-07-26 08:34
 * @Description:
 */

public class DemoTest {
    /**
     * UserInfo class helloWord function will be called by DemoTest
     * @param args
     */
    public static void main(String[] args) {
       //创建IoC容器并使用 Bean

        //从 Spring的容器中获取 文件applicationContext.xml
        ApplicationContext context = new
                ClassPathXmlApplicationContext("applicationContext.xml");

        // getBean()返回的是 Object

        UserInfo userInfo = (UserInfo) context.getBean("userInfo");
        String result = userInfo.helloWorld();
        System.out.println(result);
    }
}
```
**resources下是配置文件，配置接口以及类的关系**

`applicationContext.xml`

```html
<?xml version="1.0" encoding="ISO-8859-1"?>
<beans xmlns="http://www.springframework.org/schema/beans" xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
        xmlns:p="http://www.springframework.org/schema/p"
       xmlns:util="http://www.springframework.org/schema/util"
       xmlns:cache="http://www.springframework.org/schema/cache"
       xsi:schemaLocation="
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context.xsd
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <!--UserInfo userInfo = new UserInfo();-->
    <bean id="userInfo" class="com.iqqcode.bean.UserInfo">

        <!--setter注入-->
        <property name="username" value="Mr.Q"/>

    </bean>

</beans>
```
```html
<!--UserInfo userInfo = new UserInfo();-->
    <bean id="userInfo" class="com.iqqcode.bean.UserInfo">
    
        <!--constructor注入-->
        <constructor-arg name="username" value="Mr.Q"/>

    </bean>
```


---
如果出错的话，在`applicationContext.xml`中重新添加配置文件

```html
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.ming</groupId>
    <artifactId>ArvinSpringProjects</artifactId>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>

        <!--spring core
            spring beans
            spring context
            spring aop

        -->
        <!-- https://mvnrepository.com/artifact/org.springframework/spring-core -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.1.5.RELEASE</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.springframework/spring-context -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.1.5.RELEASE</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.springframework/spring-beans -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>5.1.5.RELEASE</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.springframework/spring-aop -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>5.1.5.RELEASE</version>
        </dependency>

    </dependencies>

</project>
```

[**所需要的配置文件在mvn官网添加**](https://mvnrepository.com/)

`spring core`
`spring context`
`spring beans`
`spring aop`



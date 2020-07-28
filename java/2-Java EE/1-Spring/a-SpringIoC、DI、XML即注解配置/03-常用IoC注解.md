## 一、常用IoC注解

在使用注解配置Spring时，<kbd>applicationContext.xml</kbd>配置如下：

> 告知Spring在创建容器时要扫描的包，配置所需要的标签不在beans中，而是在context名称空间约束中

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <!--告知Spring在创建容器时要扫描的包，配置所需要的标签不在beans中，而是在context名称空间约束中-->

    <context:component-scan base-package="org.iqqcode"/>

</beans>
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200728154941.png)

### 1. 用于创建对象的

他们的作用就和在XML配置文件中编写一个<kbd><bean></kbd>标签实现的功能是一样的

**1. @Component**

【出现位置】：类上注解

【作用】：创建当前类对象，并且存入Spring容器中

【属性】：

- value：用于指定bean的id。当我们不写时（属性只有一个），它的默认值是当前类名，且首字母改小写。如果有多个属性值时，必须全部指定出

------------------------

**2. @Controller**

- 一般用在表现层

**3. @Service**

- 一般用在业务层

**4. Repository**

- 一般用在持久层

以上三个注解他们的作用和属性与Component是一模一样，是对Component的继承。

他们三个是Spring框架为我们提供明确的三层使用的注解，使我们的三层对象更加清晰

### 2. 用于注入数据的

他们的作用就和在XML配置文件中的bean标签中写一个<kbd><property></kbd>标签的作用是一样的

#### 1. @Autowired

【出现位置】：可以是变量上，也可以是方法上

【作用】

- 如果IoC容器中有*一个*类型匹配时，只要容器中有唯一的一个bean对象类型和要注入的变量类型匹配，就可以注入成功
  
  ![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200430083144.png)

- 如果IoC容器中没有任何bean的类型和要注入的变量类型匹配，则报错。

- 如果IoC容器中有*多个*类型匹配时：先按照数据类型确定匹配的范围，然后按照变量名称作为唯一`id`，使用`@Qualifier`在确定的范围中精确匹配
  
  ![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200430084514.png)

> 细节：在使用注解注入时，Setter方法就不是必须的了，可以不写

#### 2. @Qualifier

【作用】：在按照类中注入的基础之上再按照`id`名称注入。

它在给类成员注入时不能单独使用，但是在给方法参数注入时可以直接使用。

【使用】：它在给类成员注入时不能单独使用，必须与`@Autowired`配合使用。`@Autowired`确定类的匹配范围，`@Qualifier`根据变量名`id`精确匹配

【属性】

-  value：用于指定注入bean的id

<kbd>UserDaoImpl</kbd>

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200430085142.png)

<kbd>UserServiceImpl</kbd>为userDao1类注入数据

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200430085317.png)

【在方法上直接使用】

出现多个连接对象时，我们指定连接某一个：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501154820.png)



#### 3. @Resource

【作用】：区别于直接按照bean的id注入，它可以独立使用

【 属性】

- `name`：用于指定bean的`id`

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501123322.png)

以上三 个注入都只能注入**其他bean类型**的数据，而基本类型和String类型无法使用上述注解实现。

另外，集合类型的注入只能通过XML来实现。

---------------------------

【@Resource-@Autowired-@Qualifier三个注解小结】

- `@Autowired` ：按照数据类型从Spring容器中进行匹配(如果有多个相同类型则不能匹配，结合@Qualifier)

- `@Qualifier("userDao")` ：按照id值从容器中进行匹配，必须结合Autowired一起使用

- `@Resource(name = "userDao")`：相当于@Autowired + @Qualifier

<kbd>示例</kbd>

```java
@Service("userService")
public class UserServiceImpl implements UserService {
    //<property name="userDao" ref="userDao"/>
    //@Autowired  //按照数据类型从Spring容器中进行匹配(如果有多个相同类型则不能匹配，结合@Qualifier)
    //@Qualifier("userDao")  //按照id值从容器中进行匹配，必须结合Autowired一起使用
    
    @Resource(name = "userDao")  //相当于@Autowired + @Qualifier
    private UserDao userDao;

    public UserServiceImpl() { }

    public UserServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void login() {
        userDao.login();
    }
}
```



-----------------

#### 4. @Value

【作用】：用于注入基本类型和String类型的数据

【属性】：

- `value`：用于指定数据的值。它可以使用spring中SpEL(也就是spring的el表达式）

- SpEL的写法：`${表达式}`

### 3. 用于改变作用范围的

他们的作用就和在bean标签中使用`scope`属性实现的功能是一样的

#### @Scope

【作用】：用于指定bean的作用范围

【属性】

- `value`：指定范围的取值，默认是单例的
  
   - 常用取值：singleton(单例)，prototype(多例)
    
  
  ![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501123701.png)

### 4. 与生命周期相关

他们的作用就和在bean标签中使用`init-method`和`destroy-methode`的作用是一样的

#### @PreDestroy

- 作用：用于指定销毁方法

#### @PostConstruct

- 作用：用于指定初始化方法

## 二、配置相关的新注解

> 通过注解配置类来取代`applicationContext.xml`配置文件

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200728170533.png)

--------------------------------------

**`@Configuration`**

【作用】：指定当前类是一个配置类

【细节】：当配置类作为AnnotationConfigApplicationContext对象创建的参数时，该注解可以不写。

----------------------------

**`@ComponentScan`**

【作用】：用于通过注解指定Spring在创建容器时要扫描的包

【属性】

- value：它和basePackages的作用是一样的，都是用于指定创建容器时要扫描的包。

我们使用此注解就等同于在xml中配置了:

```
<context:component-scan base-package="org.iqqcdode"
```

------------------------------------------------------------------------

**`@Bean`**

【作用】：用于把当前方法的返回值作为bean对象存入Spring IoC容器中

- name：用于指定bean的`id`。当不写时，默认值是当前方法的名称

当我们使用注解配置方法时，如果方法有参数， Spring框架会去容器中查找有没有可用的bean对象，查找的方式和Autowired注解的作用是一样的

--------------------------

**`@Scope`**

- @Scope("prototype")，配置多例对象



--------------------------------------------------

**`@Import`**

当我们有多个配置类时，要将不同的配置类分开写在不同类中。此时，需要有一个主配置类来管理其他子配置类。`@Import`注解就相当于把其他配置类（如：JdbcConfig）都导入到主配置类中（SpringConfiguration），只需要加载主配置类，即可加载全部的子配置类。

主配置类：

<kbd>SpringConfiguration</kbd>


![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501131831.png)

子配置类：

<kbd>JdbcConfig</kbd>

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200501132032.png)

【作用】：用于导入其他的配置类
【属性】

- value：用于指定其他配置类的字节码

当我们使用Import的注解之后，有Import注解的类就父配置类，而导入的都是配置类.。可以理解为继承关系

--------------------------------------------------

**`@PropertySource`**

【作用】：用于指定properties文件的位置

【属性】

- value：指定文件的名称和路径。

- 关键字：classpath，表示类路径下

```java
@PropertySource("classpath:jdbcConfig.properties")
```

<kbd>jdbcConfig.properties</kbd>

```java
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/db_test?characterEncoding=utf-8&useSSL=false
jdbc.username=root
jdbc.password=1234
```

该类是一个配置类，它的作用和`ApplicationContext.xml`是一样的





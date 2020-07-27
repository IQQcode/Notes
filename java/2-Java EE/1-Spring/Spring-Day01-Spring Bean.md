## 一、Bean对象

现在我们来谈谈什么是**Bean对象**，还得先从**JavaBean**说起......

### 1. JavaBean

JavaBean 是一种 Java语言写成的可重用组件。写成JavaBean，类必须是具体的和公共的，并且具有无参数的构造器。JavaBean 通过提供符合一致性设计模式的公共方法将内部域暴露成员属性，long和class方法获取。众所周知，属性名称符合这种模式，其他Java 类可以通过自省机制发现和操作这些JavaBean 的属性。(这段话太官方，咱看的迷迷糊糊的，举个实例来说)

**Q1：什么是JavaBean?**

1. 所有的类必须放在一个包中；
2. 所有的类必须声明为`public`，这样才能够被外部所访问；
3. 类中所有的属性都必须封装，即：使用`private`声明；
4. 封装的属性如果需要被外部所操作，则必须编写对应的`setter`、`getter`方法；
5. 一个JavaBean中至少存在一个无参构造方法

第一个简单JavaBean

```java
public class User {
    private String name;
    private int age;
    
    public void setName(String name) {
        this.name = name;    
    }   
    
    public void setAge(int age) {
        this.age = age;    
    }
    
    public String getName() {
        return this.name;    
    }
    
    public int getAge() {
        return this.age;    
    }
}
```

如果在一个类中只包含属性、`setter`、`getter`方法，那么这种类就成为简单JavaBean

对于简单的JavaBean也有几个名词：

- **VO**：与简单Java对象对应，专门用于传递值的操作上
- **POJO**：简单Java对象
- **TO**：传输对象，进行远程传输时，对象所在的类必须实现`java.io.Serializable`接口。

**为什么要写成JavaBean？**

对于程序员来说，最好的一点就是 JavaBean可以实现代码的重复利用，模块独立，易于维护。

Bean：在计算机英语中，有可重用组件的含义。

 JavaBean：用java语言编写的可重用组件

> JavaBean > 实体类

------

### 2. Spring Bean

Spring其实就是一个大型的工厂，而Spring容器中的Bean就是该工厂的产品.

 以前我们要用对象是通过自己`new`来生产的，现在是通过Spring这个工厂来代替我们管理生产，我们来使用。

对于Spring容器能够生产哪些对象，则取决于配置文件中配置。

对于我们而言，我们使用Spring框架所做的就是两件事：开发Bean、配置Bean。

对于Spring框架来说，它要做的就是根据配置文件来创建Bean实例，并调用Bean实例的方法完成“**依赖注入**”。

简而言之，Spring Bean是**Spring框架在运行时管理的对象**。Spring Bean是任何Spring应用程序的基本构建块。使用Spring框架时编写的大多数应用程序逻辑代码都将放在Spring Bean中。

------

Spring Bean的管理包括：

- 创建一个对象
- 提供依赖项（例如其他Bean，配置属性）
- 拦截对象方法调用以提供额外的框架功能
- 销毁一个对象

### 3. Bean的定义

`<beans…/>`元素是Spring配置文件的根元素，`<bean…/>`元素是<beans../>元素的子元素，<beans…/>元素可以包含多个<bean…/>子元素。

每个`<bean…/>`元素可以定义一个Bean实例，每一个Bean对应Spring容器里的一个Java实。

定义Bean时通常需要指定两个属性：

**id**：确定该Bean的唯一标识符，容器对Bean管理、访问、以及该Bean的依赖关系，都通过该属性完成。Bean的id属性在Spring容器中是唯一的。    

**class**：指定该Bean的具体实现类。通常情况下，Spring会直接使用new关键字创建该Bean的实例，因此，这里必须提供Bean实现类的全限定类名。

下面是定义一个Bean的简单配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://www.springframework.org/schema/beans"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
	<!-- 定义第一个Bean实例：bean1 -->
	<bean id="bean1" class="com.Bean1" />
	
	<!-- 定义第二个Bean实例：bean2 -->
	<bean id="bean2" class="com.Bean2" />
	
</bean>
```

Spring容器集中管理Bean的实例化，Bean实例可以通过**BeanFactory**的`getBean`(Stringbeanid)方法得到。**BeanFactory**是一个工厂，程序只需要获取BeanFactory引用，即可获得Spring容器管理全部实例的引用。程序不需要与具体实例的实现过程耦合（这就是用Spring解耦的原理）。

大部分Java EE应用里，应用在启动时，会自动创建Spring容器，组件之间直接以**依赖注入**的方式耦合，甚至无须主动访问Spring容器本身。

 当我们在配置文件中通过\<bean id="xxxx" class="xx.XxClass"/>方法配置一个Bean时，这样就需要该Bean实现类中必须有一个无参构造器。故Spring底层相当于调用了如下代码：

```java
Xxx = new xx.XxClass()
```

## 二、Spring对Bean的管理细节

### 1. 创建Bean的三种方式

#### I. 使用默认构造函数创建

 在Spring的配置文件中使用`Bean`标签，配以`id`和`class`属性之后，且没有其他属性和标签时。 采用的就是默认构造函数创建Bean对象，默认是单例的`scope=singleton`。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425190928.png)



#### II. 使用工厂中的实例方法创建对象

使用某个类中的方法创建对象，并存入spring容器

- 先创建工厂对象
- 从工厂中获取创建的对象

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425191102.png)

#### III. 使用工厂中的静态方法创建对象

使用某个类中的静态方法创建对象，并存入Spring容器

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425191216.png)

### 2. Bean对象的作用范围

Bean标签的`scope`属性：

作用：用于指定bean的作用范围

取值： 常用的就是单例的和多例的        

- singleton：单例的（默认值）
- prototype：多例的
- request：作用于web应用的请求范围
- session：作用于web应用的会话范围
- global-session：作用于集群环境的会话范围（全局会话范围），当不是集群环境时，它就是session

--------------------

**【Bean标签范围配置】**

**1）当 scope的取值为 singleton时**

Bean的实例化个数：==一个==

Bean的实例化时机：当 Spring核心文件被加载时，实例化配置的Bean实例

Bean的生命周期：

- 对象创建：<font color = red><u>当应用加载，创建容器时</u>，对象就被创建了</font>font>

- 对象运行：只要容器在，对象一直活着

- 对象销毁：当应用卸载，销毁容器时，对象就被销毁了

**2）当 scope的取值为 prototype时**

Bean的实例化个数：==多个==

Bean的实例化时机：当调用 getBean()方法时实例化Bean

- 对象创建：<font color = red><u>当使用对象时</u>，创建新的对象实例</font><font>
- 对象运行：只要对象在使用中，就一直活着
- 对象销毁：当对象长时间不用时，被JVM的垃圾回收器回收

> **global-session**：集群环境是由多个服务器构成，某一个服务器上的session不能够被其他服务器识别。global-session相当于全局变量，在session销毁之前全局有效

### 3. Bean对象的生命周期

  单例对象

- 出生：当容器创建时对象出生
- 活着：只要容器还在，对象一直活着
- 死亡：容器销毁，对象消亡
- 总结：单例对象的生命周期和容器相同        

多例对象

- 出生：当我们使用对象时Spring框架为我们创建
- 活着：对象只要是在使用过程中就一直活着
- 死亡：当对象长时间不用，且没有别的对象引用时，由Java的垃圾回收器`GC`回收

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--Bean对象默认是单例的-->
    <bean id="userService" class="org.iqqcode.service.impl.UserServiceImpl"/>
        
</beans>
```



------------------------

【参考文章】

1. [Spring读书笔记-----Spring的Bean之Bean的基本概念](https://blog.csdn.net/chenssy/article/details/8222744?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522158778781619725256731003%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=158778781619725256731003&biz_id=0&utm_source=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-3)
>  [**初识Spring**](https://blog.csdn.net/weixin_43232955/article/details/97973247)，这篇文章我简单的介绍了一些关于Spring的优势和核心概念。这篇文章对**Ioc**和**DI**对于初接触Spring的自己来说做个了结

### 1. 程序的耦合

> 我们再来谈一谈程序的耦合

**I. 程序的耦合：程序间的依赖关系**

包括

- 类之间的依赖

- 方法间的依赖

**II. 为什么会出现程序的耦合呢？**

&nbsp;&nbsp;&nbsp;在我写代码时，通常会遵循 '单一性' 的原则。就是在一个类中，尽量保持它功能的单一性，一个类尽量独立实现一个功能，如果很多代码都写到一个类中，出现问题很难更改。但是，复杂的功能逻辑往往需要调用很多方法来实现，通常都需要两个或者更多的类通过彼此的合作来实现业务逻辑。

&nbsp;&nbsp;某个对象需要获取与合作对象的引用，如果这个获取的过程需要自己实现(就是使用`new`实例化对象)，代码的耦合度就会高，维护起来的成本就比较高。

**解耦**：降低程序间的依赖关系

实际开发中：
            应该做到：编译期不依赖，运行时才依赖。
解耦的思路

- 第一步：使用反射来创建对象，而避免使用**new**关键字

- 第二步：通过读取配置文件来获取要创建的对象全限定类名

### 2. 控制反转IoC

### 控制反转理解

> 以下实例说明参考自二哥的文章[《Java：控制反转IoC与依赖注入DI》](https://blog.csdn.net/qing_gee/article/details/98741476)

我们来通过实例来模拟一下。假如老Q是计算机院的辅导员，他想让数媒专业的班级去听讲座（大一大二的你是不是常常被拉去凑人数，讲座听半天听不懂就瞌睡了），代码可以这样实现：

数媒班级代码如下所示：

```java
public class Media {

    public void liaten() {

        System.out.println("数媒专业在听讲座！");

    }
}
```

老王类的代码如下所示：

```java
public class LaoQ {
    public void advice() {
        //通知数媒班级听讲座
        new Media().liaten();
    }
}
```

测试类的代码如下所示：

```java
public class Test {
    public static void main(String[] args) {
        LaoQ laoQ = new LaoQ();
        laoQ.advice();
    }
}
```

运行结果：

> 数媒专业在听讲座！

LaoQ 类的 `advice()`方法中使用 **new** 关键字创建了一个 Media类的对象——这种代码的耦合度就很高，维护起来的成本就很高，为什么这么说呢？

某一天，学校又来学者作报告了，老Q想起了数媒专业（俺的万精油专业），可数媒专业去上实验了，让谁去听呢，老Q辅导员想起了软工专业，于是 LaoQ 类就不得不重新通知了，于是代码变成了这样：

```java
public class Soft {
    public void listen() {
        System.out.println("软工专业在听讲座！");
    }
}

public class LaoQ {
    public void advice() {
        //通知数媒专业听讲座
        new Media().liaten();
    }

    public void advice1() {
        //通知软工专业听讲座
        new Media().liaten();
    }
}
```

假如软工专业去实习了，老Q辅导员打算要让计科专业去听讲座。这样下去的话，LaoQ这个类里面都是强耦合了。

老Q最为一个辅导员，这种打酱油的工作，还用得着亲自负责么！于是，他找了一个办公室助理李同学来帮他干这件事。

李同学负责去叫学院班级去执行老Q听讲座的命令。代码可以这样实现：

定义一个听讲座专业的接口，代码如下所示：

```java
public interface Major {
    //该班级听讲座
    void listen();
}
```

数媒类的代码修改如下所示：

```java
public class Media implements Major {

    @Override
    public void listen() {
        System.out.println("数媒专业去听讲座！");
    }

    public boolean experiment() {
        // 星期三的时候数媒专业要做实验
        return false;
    }
}
```

软工类的代码修改如下所示：

```java
public class Soft implements Major {

    @Override
    public void listen() {
        System.out.println("软工专业听讲座！");

    }
}
```

李同学类的代码如下所示：

```java
public class StuLi {
    public static Major getListen() {
        Media media = new Media();
        if (media.experiment()) {
            //如果数媒有实验就通知软工去
            return new Soft();
        }
        return media;
    }
}
```

如果数媒专业在上实验，就通知软工专业去

这时老Q就轻松了，有啥事告诉李同学，自己不再关心到底哪个专业去了，具体安排由李同学通知。

老Q类的代码修改如下：

```java
public class LaoQ {
    public void advice() {
        //通知数媒专业听讲座
        new Media().listen();
    }

    public void advice1() {
        System.err.println("数媒专业在做实验...");
        //通知软工专业听讲座
        new Soft().listen();
    }
}
```

测试类的代码不变：

```java
public class Test {
    public static void main(String[] args) {
        LaoQ laoQ = new LaoQ();
        laoQ.advice();
    }
}
```

> <font color=red>数媒专业在做实验...</font>
>
> 软工专业听讲座！

我们替老Q想的这个办法就叫控制反转（Inversion of Control，缩写为 IoC），它不是一种技术，而是一种思想——指导我们设计出松耦合的程序。

&nbsp;&nbsp;控制反转从词义上可以拆分为“**控制**”和“**反转**”，说到控制，就必须找出主语和宾语，谁控制了谁；说到反转，就必须知道正转是什么。

&nbsp;&nbsp;在紧耦合的情况下，老Q下命令的时候自己要通过**new**关键字创建依赖的对象（数媒专业和软工专业）；而控制反转后，老Q要找听讲座的班级由李同学负责，也就是说控制权交给了李同学，是不是反转了呢？

----------------------------------------

Q0：**IoC的作用是什么？**

- **削弱类之间的耦合（不能完全消除）**

Q1：谁控制谁？为什么叫反转？

- 答：IoC容器控制，而以前是应用程序控制，所以叫反转

Q2：控制什么？

- 答：控制应用程序所需要的资源（对象、文件……）

Q3：为什么控制？

- 答：解耦组件之间的关系，削减类之间的耦合度

Q4：控制的哪些方面被反转了？

- 答：程序的控制权发生了反转，从应用程序转移到了IoC容器

----------------------------------------------------

#### 控制反转实例

模拟编写持久层`UserDao`接口及其实现类

<kbd>UserDao</kbd>

```java
public interface UserDao {
    /**
     * 用户注册
     */
    void regist();
}
```

<kbd>UserDaoImpl</kbd>

```java
public class UserDaoImpl implements UserDao {
    public void regist() {
        System.out.println("user regist...");
    }
}
```

模拟编写业务逻辑层`UserService`接口及其实现类

<kbd>UserService</kbd>

```java
public interface UserService {
    /**
     * 用户注册
     */
    void regist();
}
```

<kbd>UserServiceImpl</kbd>

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-04-23 10:58
 * @Description:用户的业务逻辑层接口实现类
 */
public class UserServiceImpl implements UserService {

    private UserDao userDao;

    public UserServiceImpl() {
        System.err.println("对象创建了！");
    }

    public void regist() {
        userDao.regist();
    }
}
```

现在，我们不直接用`new`来实例化对象了，用上面的例子来说，就是老Q不再具体通知班级了，交由李同学来管理。李同学就相当于Spring管理资源.

我们要做的事在配置文件中配置`UserDao`和`UserService`

<kbd>applicationContext.xml</kbd>

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--把对象的创建交给spring来管理-->
    <bean id="userService" class="org.iqqcode.service.impl.UserServiceImpl"/>

    <bean id="userDao" class="org.iqqcode.dao.impl.UserDaoImpl"/>

</beans>
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425115037.png)

模拟编写表现层`RegistClient`

<kbd>RegistClient</kbd>

```java
public class RegistClient {
    public static void main(String[] args) {
        //1.获取核心容器对象
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");

        //2.根据id获取Bean对象
        UserDao userDao = ac.getBean("userDao",UserDao.class); //反射拿到字节码强转
        UserService userService = (UserService) ac.getBean("userService"); //Object类型
        userDao.regist();
    }
}
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425120529.png)

#### 核心容器的两个接口

**获取spring的Ioc核心容器创建对象的策略** 

<font color=pink size=5>ApplicationContext</font>: 单例对象适用

它在构建核心容器时，创建对象采取的策略是采用立即加载的方式。也就是说，只要一读取完配置文件马上就创建配置文件中配置的对象。

<font color=pink size=5>BeanFactory</font>: 多例对象使用

它在构建核心容器时，创建对象采取的策略是采用延迟加载的方式。也就是说，什么时候根据id获取对象了，什么时候才真正的创建对象。  

ApplicationContext的三个常用实现类：  

* ClassPathXmlApplicationContext：它可以加载类路径下的配置文件，要求配置文件必须在类路径下。不在的话，加载不了。(更常用)  
* FileSystemXmlApplicationContext：它可以加载磁盘任意路径下的配置文件(必须有访问权限）  
* AnnotationConfigApplicationContext：它是用于读取注解创建容器的  

#### 获取Bean对象

由于是Spring来管理我们对象的产生，不知道传入的**Bean**对象是什么类型的，所以有两种方法来获取Bean对象

- Object类（需要强转）

- 反射获取

### 3. [Bean对象](https://blog.csdn.net/weixin_43232955/article/details/105755021)

> JavaBean，Spring Bean对象的理解

### getBean的用法

```java
ApplicationContext apps = new ClassPathXmlApplicationContext("applicationContext.xml");

// 1.根据id获取Bean
UserService userService = (UserService) apps.getBean("userService");

// 2.根据类型获取Bean(多个相同类型的无法使用，只能用id)
UserService userService = apps.getBean(UserService.class);

userService.save();
```



### 4. 依赖注入DI

依赖注入（Dependency Injection，简称 DI）是实现控制反转的主要方式。它是Spring框架核心IoC的具体实现。 

我们的程序在编写时，通过控制反转(Ioc)，把对象的创建交给了Spring，但是代码中不可能出现没有依赖的情况。IoC解耦只是降低他们的依赖关系，但不会消除。

> 例如：我们在业务层仍会调用持久层的方法。 那这种业务层和持久层的依赖关系，在使用Spring之后，就让Spring来维护了。 简单的说，就是坐等框架把持久层对象传入业务层，而不用我们自己去获取。

在当前类需要用到其他类的对象，由Spring为我们提供，我们只需要在配置文件中说明。

在类A的实例创建过程中就创建了依赖的B对象，通过类型或名称来判断将不同的对象注入到不同的属性中。

---------------------------------

**【注入DI的方式】**

大概有 3 种具体的实现形式：

1. 构造函数注入

2. Setter()注入

3. 使用注解提供

**【注入的数据】**

能注入的数据：有三类

1. 基本类型和String

2. 其他Bean类型（在配置文件中或者注解配置过的bean）

3. 复杂类型/集合类型

------------------------------------------------

#### 构造函数注入

使用的标签: `constructor-arg`

标签出现的位置：`bean`标签的内部

标签中的属性

- type：用于指定要注入的数据的数据类型，该数据类型也是构造函数中某个或某些参数的类型

- index：用于指定要注入的数据给构造函数中指定索引位置的参数赋值。索引的位置是从0开始

- name：用于指定给构造函数中指定名称的参数赋值
             

以上三个用于指定给构造函数中哪个参数赋值

- value：用于提供基本类型和String类型的数据
- ref：用于指定其他的Bean类型数据。它指的就是在Spring的IoC核心容器中出现过的Bean对象(如Date类对象)

```xml
	<!--构造方法注入-->
    <bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl">
        <constructor-arg name="userDao" ref="userDao"/>
    </bean>
```

- `name="userDao"` ：参数内部对应的名称

- `ref="userDao"`：引用容器中`bean`对象的**id**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425202654.png)



**构造函数注入注入对比**

优势：

- 在获取bean对象时，注入数据是必须的操作，否则对象无法创建成功
  

 弊端：

- 改变了bean对象的实例化方式，使我们在创建对象时，如果用不到这些数据，也必须提供

------------------------------------------------------------------------

#### Setter()注入

Setter方法注入（更常用的方式）

涉及的标签：`property`

出现的位置：`bean`标签的内部

标签的属性

- `name`：用于指定注入时所调用的set方法名称

- `value`：用于提供**基本类型和String类型**的数据

- `ref`：用于指定其他的bean的**引用类型**数据。它指的就是在Spring的IoC核心容器中出现过的bean对象        

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200425202750.png)



优势：

- 创建对象时没有明确的限制，可以直接使用默认构造函数

弊端：

- 如果有某个成员必须有值，则获取对象时set()方法有可能没有执行

![](Spring-Day01-IoC%E4%B8%8EDI.assets/20200728105849.png)

【注入对象】

```xml
<!--无参构造实例化Bean对象-->
<bean id="userDao" class="com.iqqcode.dao.impl.UserDaoImpl"/>
<bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl">
    <!--Setter注入，将userDao注入到userService中-->
    <property name="userDao" ref="userDao"/>
</bean>
```

【注入普通属性】

```xml
<!--注入普通属性，为对象赋值-->
<bean id="userDao" class="com.iqqcode.dao.impl.UserDaoImpl">
    <property name="name" value="iqqcode"/>
    <property name="age" value="21"/>
</bean>

<!--构造方法注入对象引用-->
<bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl">
    <constructor-arg name="userDao" ref="userDao"/>
</bean>
```



![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200728110159.png)

```xml
<bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl">
    <!--Setter注入，将userDao注入到userService中-->
    <property name="userDao" ref="userDao"/>
</bean>
```

等价于

```xml
<!--p命名空间-->
<bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl" p:userDao-ref="userDao"/>
```



-----------------------------------

#### 使用注解注入

> 下篇文章肝吧...

-----------------------------------------------------------------------------------------

#### Setter()集合数据注入

对于`List`、`Set`、`Map`、`Props`集合类型的数据来说，我们使用**Sette**来注入

1. domain下的实体类

	```java
	@Data
	public class User {
	    private String username;
	    private String password;
	}
	```

2. UserDaoImpl下的集合类

	```java
	@Data
	public class UserDaoImpl implements UserDao {
	
	    //注入基本类型
	    private String name;
	    private int age;
	
	    //注入集合
	    private int[] arr;
	    private List<Integer> list;
	    private Map<String, User> map;
	    private Properties prop;
	
	
	    @Override
	    public void save() {
	        System.out.println("user save!");
	
	        System.out.println("name: " + name + "\tage: " + age);
	
	        System.out.println(list);
	        System.out.println(map);
	        System.out.println(prop);
	    }
	}
	```
	
3. applicationContext.xml配置

	```xml
	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:p="http://www.springframework.org/schema/p"
	       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
	
	    <!--无参构造实例化Bean对象-->
	    <bean id="userDao" class="com.iqqcode.dao.impl.UserDaoImpl">
	        <!--注入基本类型-->
	        <property name="name" value="iqqcode"/>
	        <property name="age" value="21"/>
	
	        <!--注入集合-->
	        <property name="arr">
	            <array>
	                <value>111</value>
	                <value>222</value>
	            </array>
	        </property>
	        <property name="list">
	            <list>
	                <value>01010101</value>
	                <value>10101010</value>
	            </list>
	        </property>
	        <property name="map">
	            <map>
	                <entry key="u1" value-ref="user1"/>
	                <entry key="u2" value-ref="user2"/>
	            </map>
	        </property>
	        <property name="prop">
	            <props>
	                <prop key="config">iqqcode</prop>
	                <prop key="settings">Mr.Q</prop>
	            </props>
	        </property>
	    </bean>
	
	    <bean id="user1" class="com.iqqcode.domain.User">
	        <property name="username" value="Tom"/>
	        <property name="password" value="2020"/>
	    </bean>
	    <bean id="user2" class="com.iqqcode.domain.User">
	        <property name="username" value="Jack"/>
	        <property name="password" value="2021"/>
	    </bean>
	
	    <!--构造方法注入UserDao-->
	    <bean id="userService" class="com.iqqcode.service.impl.UserServiceImpl">
	        <constructor-arg name="userDao" ref="userDao"/>
	    </bean> 
	
	</beans>
	```

------------------------

**结构相同，标签可以互换**：

 用于给List结构集合注入的标签

- `list`、 `arr`、 `set `

用于个Map结构集合注入的标签:

- `map`、` props `

 ![](Spring-Day01-IoC%E4%B8%8EDI.assets/20200728120239.png)

【小结】

![](Spring-Day01-IoC%E4%B8%8EDI.assets/20200728120709.png)

好啦，Spring的解耦思想，IoC，Bean，DI就介绍到此啦。下一篇讲注解


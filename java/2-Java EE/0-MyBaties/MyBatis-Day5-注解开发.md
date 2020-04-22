### 1. 注解开发使用事项

**为什么注解一句话等同于映射配置文件**

修饰的谁

- 注解：修饰`findAll()`
- XML：修饰id为`findAll()`

执行的SQL语句

- 注解、XML都相同

封装的结果

- 注解：方法的返回类型
- XML：resultType中的类型

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421174801.png)

### 2. 如果注解和XML同时存在

**使用注解开发，映射配置IUserDao.xml文件存在但不使用**——**<font color=red>运行出错</font>**

<kbd>SqlMapConfig</kbd>主配置文件

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421185123.png)

**<font color=red>报错信息</font>**

```verilog
org.apache.ibatis.exceptions.PersistenceException: 
### Error building SqlSession.
### The error may exist in org/iqqcode/dao/IUserDao.xml
### Cause: org.apache.ibatis.builder.BuilderException: Error parsing SQL Mapper Configuration. Cause: java.lang.IllegalArgumentException: Mapped Statements collection already contains value for org.iqqcode.dao.IUserDao.findAll. please check org/iqqcode/dao/IUserDao.xml and org/iqqcode/dao/IUserDao.java (best guess)
```

**只要使用注解开发，如果在配置文件路径下同时包含了映射配置文件，无论使用与否，都会报错**

所以，如果使用注解开发，只需要添加主配置文件即可！

<img src="https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421190054.png" style="zoom:67%;" />

### 3. 复杂关系映射的注解说明

**`@Results`注解 代替的是标签\<resultMap>**

-  该注解中可以使用单个`@Result`注解，也可以使用`@Result集合 `

```java
@Results({@Result(),@Result()}) 或 @Results(@Result())
```

-----------------------------------

**`@Result`注解 代替了\<id>标签和\<result>标签 **

@Result中属性介绍： 

+ id 是否是主键字段(boolen) 

- column 数据库的列名 

- property需要装配的属性名 

- one 需要使用的`@One`注解

- many 需要使用的`@Many`注解

----------------------------------------

**@One注解（一对一） 代替了\<assocation>标签，是多表查询的关键，在注解中用来指定子查询返回单一对象**

@One注解属性介绍： 

- select 指定用来多表查询的 sqlmapper 

- fetchType 会覆盖全局的配置参数 lazyLoadingEnabled (延迟加载)

-------------------------------------------

**@Many注解（一对多） 代替了\<collection>标签，是多表查询的关键，在注解中用来指定子查询返回对象集合**

> 注意：聚集元素用来处理 “一对多” 的关系。需要指定映射的Java实体类的属性，属性的 javaType（一般为ArrayList）但是注解中可以不定义； 



#### 实体类属性与数据库表字段不对应

当实体类属性与数据库表字段不对应时，XML配置会在映射配置文件中添加`<resultMap>`来重新映射关系结构，在注解开发中我们使用`@Results`集合来重新映射表字段

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200422085356.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200422085540.png)



#### @ResultMap

XML配置：

resultMap可以用来描述从数据库结果集中来加载对象，有的时候映射过于复杂，我们可以在Mapper中定义resultMap来解决映射问题，可以在IUserDao这样来定义一个`resultMap`：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200422092822.png)

注解配置对比：

`@Results`中**id**是resultMap的唯一标识符，我们在后面引用这个`@Results`的时候就是通过这个**id**来引用，然后还定义了type属性，type属性指明了这个resultMap它对应的是哪个JavaBean。

在`@Result`节点中，id为true表示主键，`Result`节点定义了普通的映射关系，这里的property表示JavaBean中的属性名称，column表示数据库中的字段名称，javaType代表JavaBean中该属性的类型，jdbcType则表示数据库中该字段的类型

`@ResultMap`与XML中的`resultMap`等价，在select查询的时候指定`@Results`**id**即可

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200422093219.png)

> **更多相关resultMap映射器配置细则**
>
> [mybatis映射器配置](https://blog.csdn.net/u012702547/article/details/54562619)
>
> [mybatis中resultMap配置细则](https://blog.csdn.net/u012702547/article/details/54599132)

#### fetchType

配置延迟加载策略：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200422095250.png)

```java
fetchType = FetchType.LAZY
fetchType = FetchType.EAGER
fetchType = FetchType.DEFAULT
```

- 当映射关系为一对一时：选择**EAGER**加载
- 当映射关系为一对多或者多对多时：选择**LAZY**加载
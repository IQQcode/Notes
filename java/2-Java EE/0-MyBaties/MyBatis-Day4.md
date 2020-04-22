[TOC]

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420190351.png)

## 2. MyBatis缓存

Mybatis中的一级缓存和二级缓存：

【一级缓存】

它指的是Mybatis中`SqlSession`对象的缓存

- 当我们执行查询之后，查询的结果会同时存入到SqlSession为我们提供一块区域中。该区域的结构是一个Map。

- 当我们再次查询同样的数据，Mybatis会先去SqlSession中查询是否有，有的话直接拿出来用。

- 当SqlSession对象消失时，Mybatis的一级缓存也就消失了。
				

【二级缓存】

它指的是Mybatis中SqlSessionFactory对象的缓存。

由同一个`SqlSessionFactory`对象创建的`SqlSession`共享其缓存
		

二级缓存的使用步骤：

1. 让Mybatis框架支持二级缓存（在SqlMapConfig.xml中配置）
2. 让当前的映射文件支持二级缓存（在IUserDao.xml中配置）
3. 让当前的操作支持二级缓存（在select标签中配置）

------------------------------------------------------------------------

### 一级缓存

MyBatis提供了缓存策略，通过缓存策略来减少数据库的查询次数，从而提高性能。 Mybatis中缓存分为一级缓存，二级缓存。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421142515.png)



****

Mybatis的一级缓存的作用域是`session`，是**SqlSession**级别的缓存，只要**SqlSession**没有`flush`或`close`，它就存在。

如果执行相同的SQL（相同语句和参数）， MyBatis不进行执行SQL，而是从缓存中命中返回查询；如果命中直接返回，没有命中则执行SQL，从数据库中査询

**一级缓存存在测试**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421144333.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421144201.png)

我们可以发现，虽然在上面的代码中我们查询了两次，但最后只执行了一次数据库操作，这就是Mybatis提供给我们的一级缓起作用了。因为一级缓存的存在，导致第二次查询id为51的记录时，并没有发出SQL语句从数据库中查询数据，而是从一级缓存中查询。

一级缓存是SqlSession范围的缓存，当调用SqlSession的修改，添加，删除，commit()，close()等方法时，就会清空一级缓存。

**一级缓存清空测试**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421145144.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421145339.png)

当执行`sqlSession.close()`后，再次获取sqlSession并查询id=51的User对象时，又重新执行了SQL 语句，从数据库进行了查询操作。

### 二级缓存

MyBatis 的二级缓存是`mapper映射`级别的缓存，作用域是同一个mapper的**namespace** ，同一个**namespace**中查询SQL可以从缓存中命中，多个SqlSession可以共用二级缓存，二级缓存是跨SqlSession的。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421145855.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421152532.png)



**二级缓存测试**

主配置文件`SqlMapConfig.xml`中开启缓存（默认是开启的）

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200420190351.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421152733.png)

映射配置文件`IUserDao.xml`中开启二级缓存

```xml
<!--开启user支持二级缓存-->
<cache/>
```

```java
@Test
    public void testFirstLevelCache(){
        SqlSession sqlSession1 = factory.openSession();
        IUserDao dao1 = sqlSession1.getMapper(IUserDao.class);
        User user1 = dao1.findById(41);
        System.out.println(user1);
        //一级缓存消失
        sqlSession1.close();

        SqlSession sqlSession2 = factory.openSession();
        IUserDao dao2 = sqlSession2.getMapper(IUserDao.class);
        User user2 = dao2.findById(41);
        System.out.println(user2);
        sqlSession2.close();
        System.out.println(user1 == user2);
    }
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200421155723.png)

经过上面的测试，我们发现执行了两次查询，并且在执行第一次查询后，我们关闭了一级缓存，再去执行第二次查询时，我们发现并没有对数据库发出SQL语句，所以此时的数据就只能是来自于我们所说的二级缓存。
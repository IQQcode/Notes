![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs01/20200728174355.png)

   ### 1. 导入坐标

```xml
  <dependencies>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-test</artifactId>
      <version>5.1.9.RELEASE</version>
    </dependency>
      
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.13</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
```

### 2. Spring-test

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-07-28 17:48
 * @Description:Spring集成Junit测试--xml&注解
 */

@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration("classpath:applicationContext.xml")
@ContextConfiguration(classes = {SpringConfiguration.class})

public class SpringJunitTest {

    @Autowired
    private UserService userService;

    //@Resource(name = "dataSource_Druid")  //xml
    @Autowired
    private DataSource dataSource;

    @Test
    public void test() throws SQLException {
        userService.login();
        System.out.println(dataSource.getConnection());
    }
}
```






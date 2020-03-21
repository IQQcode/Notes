## JSON数据和Java对象的相互转换

JSON解析器：

- 常见的解析器：Jsonlib，Gson，Fastjson，Jackson

### JSON转为Java对象

1. 导入jackson的相关jar包
2. 创建Jackson核心对象 ObjectMapper
3. 调用ObjectMapper的`readValue()`方法进行转换

```java
@Test
public void test() throws IOException {
    //初始化JSON字符串
    String json = "{\"name\":\"Mr.Q\",\"age\":22,\"address\":\"Inner Mongolia\",\"birthday\":\"2020-03-16\"}";
    ObjectMapper mapper = new ObjectMapper();
    //转换为Java对象
    Person per = mapper.readValue(json, Person.class);
    System.out.println(per);
}
```

    Person{name='Mr.Q', age=22, address='Inner Mongolia', birthday=Mon Mar 16 08:00:00 CST 2020}

### Java对象转换JSON

#### 转换步骤：

1. 导入**Jackson**的相关jar包

2. 创建Jackson核心对象`ObjectMapper`

3. 调用ObjectMapper的相关方法进行转换

#### 转换方法：

**Java对象转为JSON**

`writeValue(参数，obj)`

参数：  

* File：将obj对象转换为JSON字符串，并保存到指定的*文件*中  
* Writer：将obj对象转换为JSON宇符串，并将JSON数据填充到*字符输岀流*中  
* OutputStream：将obj对象转换为JSON字符串，并将JSON数据填充到*字节输岀流*中    

`writeValueAsString(obj)`：将对象转为json字符串

------------------------------------------------------------------------

I. 新建JavaBean对象

```java
@Data
@ToString
public class Person {
    private String name;
    private int age;
    private String address;
}
```

II. 单元测试类

```java
@Test
public void test1() throws Exception {
    Person per = new Person();
    per.setName("Mr.Q");;
    per.setAge(22);
    per.setAddress("Inner Mongolia");
    //创建Jackson对象ObjectMapper
    ObjectMapper mapper = new ObjectMapper();
    String json = mapper.writeValueAsString(per);
    //{"name":"Mr.Q","age":22,"address":"Inner Mongolia"}
    //System.out.println(json);

    //writeValue:将数据写到文件中
    mapper.writeValue(new File("F://Json.txt"),per);

    //writeValue:将数据写到输出流中
    mapper.writeValue(new FileWriter("F://JsonStream.txt"),per);
    mapper.writeValue(new FileOutputStream("F://JsonTest.txt"),per);
}
```

生成的文件：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200316174752106.png)![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMTYxNzE1MTUucG5n?x-oss-process=image/format,png)

【注解】

1. `@JsonIgnore`：排除属性
2. `@JsonFormat`：属性值得格式化

如果在**Person**中添加属性birthday

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nY29kZS5wbmc?x-oss-process=image/format,png)

则上面的对象属性解析为：

    {"name":"Mr.Q","age":22,"address":"Inner Mongolia","birthday":1584346372533}

其中 "birthday":1584346372533 为时间戳

- 如果我们不想转换这个属性，就用`@JsonIgnore`来排除此birthday属性

- 如果格式化显示则用`@JsonFormat`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200316174832922.png)

    {"name":"Mr.Q","age":22,"address":"Inner Mongolia","birthday":"2020-03-16"}

**复杂java对象转换**

1. List：数组
2. Map：对象格式一致

<kbd>List</kbd>

```java
@Test
public void testList() throws JsonProcessingException {
    Person per = new Person();
    per.setName("Mr.Q");;
    per.setAge(22);
    per.setAddress("Inner Mongolia");
    per.setBirthday(new Date());

    Person per1 = new Person();
    per1.setName("Mr.Q");;
    per1.setAge(22);
    per1.setAddress("Inner Mongolia");
    per1.setBirthday(new Date());

    Person per2 = new Person();
    per2.setName("Mr.Q");;
    per2.setAge(22);
    per2.setAddress("Inner Mongolia");
    per2.setBirthday(new Date());

    List<Person> list = new ArrayList<Person>();
    list.add(per);
    list.add(per1);
    list.add(per2);
    ObjectMapper mapper = new ObjectMapper();
    String json = mapper.writeValueAsString(list);
    System.out.println(json);
}
```

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMTYxNzQxMzYucG5n?x-oss-process=image/format,png)
<kbd>Map</kbd>

```java
@Test
public void testMap() throws JsonProcessingException {

    Map<String,Object> map = new HashMap<String, Object> ();

    map.put("name", "Mr.Q");

    map.put("age", 22);

    map.put("address" , "Xian");

    ObjectMapper mapper = new ObjectMapper();

    String json = mapper.writeValueAsString(map);

    //{"address":"Xian","name":"Mr.Q","age":22}

    System.out.println(json);

}
```

    {"address":"Xian","name":"Mr.Q","age":22}

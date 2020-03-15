![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200315200504.png)

JSON数据

1. 概念： JavaScript Object Notation        JavaScript对象表示法
    Person p = new Person();
    p.setName("张三");
    p.setAge(23);
    p.setGender("男");
   
    var p = {"name":"张三","age":23,"gender":"男"};
   
   * json现在多用于存储和交换文本信息的语法
   * 进行数据的传输
   * JSON 比 XML 更小、更快，更易解析。

2. 语法：
   
   1. 基本规则
      
      * 数据在名称/值对中：json数据是由键值对构成的
        * 键用引号(单双都行)引起来，也可以不使用引号
        * 值得取值类型：
          1. 数字（整数或浮点数）
          2. 字符串（在双引号中）
          3. 逻辑值（true 或 false）
          4. 数组（在方括号中）    {"persons":[{},{}]}
          5. 对象（在花括号中） {"address":{"province"："陕西"....}}
          6. null
      * 数据由逗号分隔：多个键值对由逗号分隔
      * 花括号保存对象：使用{}定义json 格式
      * 方括号保存数组：[]
   
   2. 获取数据:
      
      1. json对象.键名
      
      2. json对象["键名"]
      
      3. 数组对象[索引]
      
      4. 遍历

3. JSON数据和Java对象的相互转换
   
   * JSON解析器：
     
     * 常见的解析器：Jsonlib，Gson，fastjson，jackson
   1. JSON转为Java对象
      
      1. 导入jackson的相关jar包
      2. 创建Jackson核心对象 ObjectMapper
      3. 调用ObjectMapper的相关方法进行转换
         1. readValue(json字符串数据,Class)
   
   2. Java对象转换JSON
      
      1. 使用步骤：
         
         1. 导入jackson的相关jar包
         
         2. 创建Jackson核心对象 ObjectMapper
         
         3. 调用ObjectMapper的相关方法进行转换
            
            1. 转换方法：
               
               * writeValue(参数1，obj):
                   参数1：
                 
                       File：将obj对象转换为JSON字符串，并保存到指定的文件中
                       Writer：将obj对象转换为JSON字符串，并将json数据填充到字符输出流中
                       OutputStream：将obj对象转换为JSON字符串，并将json数据填充到字节输出流中
               
               * writeValueAsString(obj):将对象转为json字符串
            
            2. 注解：
               
               1. @JsonIgnore：排除属性。
               2. @JsonFormat：属性值得格式化
                  * @JsonFormat(pattern = "yyyy-MM-dd")
            
            3. 复杂java对象转换
               
               1. List：数组
               2. Map：对象格式一致

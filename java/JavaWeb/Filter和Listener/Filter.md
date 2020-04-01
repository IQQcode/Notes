## 过滤器

web中的过滤器：当访问服务器的资源时，过滤器可以捋请求拦截下来，完成一些特殊的功能
过滤器的作用：一般用于完成通用的操作。如：登录验证、统一编码处理、敏感字符过滤

### 1.快速入门

1. 定义一个类，实现接口`Filter`

2. 覆写方法

3. 配置拦截路径
   
   - web.xml
   
   - Annotation

<kbd>web.xml</kbd>Config

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <filter>
        <filter-name>filterConfig</filter-name>
        <filter-class>com.iqqcode.filter.Filter_config</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>filterConfig</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

</web-app>
```

`Annotation`

```java
@WebFilter("/*") //访问所有资源前，都会执行该过滤器
```

### 2.过滤器执行流程

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200228142710.png)

- request对象请求资源

- Filter拦截过滤

- 服务器响应请求

- Filter再次拦截过滤

<kbd>Filterx执行流程</kbd>

```java
@WebFilter("/*")
public class FilterExecute implements Filter {
    @Override
    public void destroy() {}


    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        //对request对象请求消息增强
        System.out.println("1.FilterExecute请求执行");

        chain.doFilter(req, resp);

        //对response对象的响应消息增强
        System.out.println("3.FilterExecute响应数据");
    }

    @Override
    public void init(FilterConfig config) throws ServletException { }
}
```

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200228143322.png)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200228143357.png)

### 3.过滤器生命周期方法

1. init：在服务器动后，会创建 Filter对象，然后调用`init()`方法，只执行一次。用于加载资源

2. doFilter：每一次请求被拦截资源时会执行。执行多次

3. destroy：在服务器关闭后， Filter对象被销毁。如果服务器是正常关闭，则会执行 `destroy()`方法。只执行一次，用于释放资源

### 4.过滤器拦截配置

#### 拦截路径配置

1. 具体资源路径：`/index.jsp` 只有访问index.jsp资源时，过滤器才能被执行

2. 拦截目录：`/user/*` 访问 /user下的所有资源时，过滤器都会被执行

3. 后缀名拦截：`*.jsp*` 访问所有后缀名为 jsp资源时，过滤器都会被执行

4. 拦截所有资源：`/*` 访问所有资源时，过滤器都会被执行

#### 拦截方式配置

拦截方式配置：资源被访问的方式

- 请求路径访问

- 请求转发

**1. 注解配置**
设置 `dispatcher Types`属性

1. REQUEST：默认值。浏览器直接请求资源
2. FoRWard：转发访问资源
3. INCLUDE：包含访问资源
4. ERROR：错误跳转资源
5. ASYNC：异步访问资源

---------------------------------------

**过滤直接请求**

- @WebFilter(value="/index.jsp", dispatcherTypes = DispatcherType.REQUEST) 

- `dispatcherTypes = DispatcherType.REQUEST`

- 浏览器直接请求index.jsp资源时被拦截，过滤器被执行

**过滤转发请求**

- @WebFilter(value="/index.jsp", dispatcherTypes = DispatcherType.FORWARD)

- `dispatcherTypes = DispatcherType.FORWARD`

- 只有转发访问index.jsp时，该过滤器才会被执行

**过滤直接请求和转发请求**

- @WebFilter(value="/index.jsp", dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD})

- `dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD}`

- 浏览器直接请求或者转发访问index.jsp时，该过滤器都会被执行

---------------------------------------------------------------------------------------------------

**2. web.xml配置**

设置`< dispatcher></dispatcher>`标签即可

### 5.过滤器链(配置多个过滤器)

![](https://blogimage-1255618592.cos.ap-chengdu.myqcloud.com/img20200228164610.png)

过滤器拦截顺序：

有两个过滤器---过滤器1和过滤器2

1. 过滤器1

2. 过滤器2

3. 资源执行

4. 过滤器2

5. 过滤器1

过滤器先后执行顺序问题

I. 注解配置：按照类名的字符串**逐一比较**，**值小的先执行**

- AFilter 和 BFilter, AFilter先执行

- Filter6 和 Filter7，Filter6先执行

- Filter6 和 Filter17, Filter17先执行

II. web.xml配置：**顺序执行**，谁先定义谁先执行（自上而下，在上面的先执行）





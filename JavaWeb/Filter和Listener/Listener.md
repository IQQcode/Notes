## Listener监听器

概念：web的三大组件之一
事件件监听机制

- 事件：一件事情

- 事件源：事件发生的地方

- 监听器：一个对象

- 注册监听：事件、事件源、监听器绑定在一起。当事件源上发生某个事件后，执行监听器代码

-----------------------------------------------------

Servletcontextlistener：监听Servletcontext对象的创建和销毁


【方法】

- void contextDestroyed(Servletcontextevent sce)：ServletContext对象被**销毁之前**会调用该方法
* void contextinitialized(ServletcontextEvent sce)：ServletContext对象**创建之后**会调用该方法
  

【步骤】

1. 定义一个类，实现 ServletContextListener接口

2. 覆写方法

3. 配置
   
   - web.xml配置
   
   - Annotation配置

**xml配置**

```xml
<!--配置监听器-->
    <listener>
        <listener-class>com.iqqcode.listener.LoaderListener</listener-class>
    </listener>
    &lt;!&ndash;加载资源文件&ndash;&gt;
    <context-param>
        <param-name>config</param-name>
        <param-value>/WEB-INF/classes/druid.properties</param-value>
    </context-param>
```

**注解配置**

`@WebListener`



```java
@WebListener
public class ContextLoaderListener implements ServletContextListener {

    /**
     * 监听ServletContext对象创建的。ServletContext对象服务器启动后自动创建。
     *
     * 在服务器启动后自动调用
     * @param servletContextEvent
     */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        //加载资源文件
        //1.获取ServletContext对象
        ServletContext servletContext = servletContextEvent.getServletContext();

        //2.加载资源文件
        String contextConfigLocation = servletContext.getInitParameter("contextConfigLocation");

        //3.获取真实路径
        String realPath = servletContext.getRealPath(contextConfigLocation);

        //4.加载进内存
        try{
            FileInputStream fis = new FileInputStream(realPath);
            System.out.println(fis);
        }catch (Exception e){
            e.printStackTrace();
        }
        System.out.println("ServletContext对象被创建了。。。");
    }

    /**
     * 在服务器关闭后，ServletContext对象被销毁。当服务器正常关闭后该方法被调用
     * @param servletContextEvent
     */
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("ServletContext对象被销毁了。。。");
    }
}
```



## web服务器软件

### 1.Java Web服务器
服务器：安装了服务器软件的计算机

服务器软件：接收用户的请求，处理请求，做出响应

web服务器软件：接收用户的请求，处理请求，做出响应

- 在web服务器软件中，可以部署web项目，让用户通过浏览器来访问这些项目

- web服务器可以理解为web容器

常见的Java相关的web服务器软件：

- webLogic：oracle公司，大型的JavaEE服务器，支持所有的JavaEE规范，收费的。

- webSphere：IBM公司，大型的JavaEE服务器，支持所有的JavaEE规范，收费的。

- JBOSS：JBOSS公司的，大型的JavaEE服务器，支持所有的JavaEE规范，收费的。

- Tomcat：Apache基金组织，中小型的JavaEE服务器，仅仅支持少量的JavaEE规范 servlet/jsp，开源免费。



> JavaEE：Java语言在企业级开发中使用的技术规范的总和，一共规定了13项大的规范



### 2.Tomcat服务器

Tomcat目录结构：

![C:\Users\j2726\AppData\Roaming\Typora\typora-user-images](https://img-blog.csdnimg.cn/20200122131441704.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

启动Tomcat命令：`startup`

关闭Tomcat命令：`shutdown`

查看端口使用情况：`netstat -ano`

 

项目目录：

<center><img src = "https://img-blog.csdnimg.cn/20200122131528637.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width="70%"></center>
【将Tomcat集成到IDEA中，并且创建JavaEE 的项目，部署项目】

### 3.Tomcat服务器的安装及配置
- 参考另一篇文章

[**Tomcat服务器的安装及环境变量的配置**](https://blog.csdn.net/weixin_43232955/article/details/93308142)

### 4.IDEA配置Tomcat及创建Web项目
[**配置Tomcat及创建Web项目详细过程**](https://blog.csdn.net/weixin_43232955/article/details/93378072)

配置好之后，启动Test项目。

【目录结构】
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020012213512198.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

**index.jsp**是默认的首页
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200122134959479.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
web.xml文件说明：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200122135032434.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
【访问 hello.html】

`http://localhost:8080/TomcatTest_war_exploded/hello.html`
<center><img src = "https://img-blog.csdnimg.cn/20200122135341917.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width="70%"></center>
【访问 index.jsp】

`http://localhost:8080/TomcatTest_war_exploded/index.jsp`

<center><img src = "https://img-blog.csdnimg.cn/20200122135553601.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width="70%"></center>
### 5.Tomcat日志乱码解决
- 在第一次使用时可能会出现乱码问题，解决方案如下

- [**Tomcat日志乱码解决**](https://blog.csdn.net/weixin_43232955/article/details/100833817)

### 6. Tomcat启动失败解决方案
>虽然此问题我没有遇到过，照着我上面几步配置是不会有问题的。但是在此记录一下常见的错误及解决方案。

**项目启动tomcat失败的几种可能原因和解决方法:**


1. java配置路径有问题，请配置好jdk路径，具体参考java路径的配置吧。



2. 项目未添加tomcat驱动，

- （一般提示The superclass "javax.servlet.http.HttpServlet" was not found on the Java Build Path属于这一类）


3. 项目中的web.xml中配置的servlet的名称写错，tomcat无法识别，

- （一般控制台提示java.util.concurrent.ExecutionException属于这种问题）

- 解决方法：检查自己配置的servlet名称和路径是否正确。



4. 端口被占用，一般由于上一次非正常关闭tomcat或eclipse导致，（ Port 8080 .............. is already in use）

- 解决方法：①修改端口号（当然不建议这么做） Tomcat根目录/conf/Server.xml中修改
- ②关闭被占用的端口进程:到dos窗口（计算机开始里的查找中输入cmd）中
----------------
 输入`netstat -ano`            （8080是被占用的端口号，哪个被占用输入哪个）

回车后可以看到有正在使用的进程

再输入   `taskkill /pid 8080 /f`     （这里的8080是正在使用的进程信息中最后一个数字编号）

回车后会显示已结束进程，然后重新启动tomcat即可。

5. Tomcat启动闪退
- [**Tomcat无法成功启动——双击startup.bat闪退的解决办法**](https://blog.csdn.net/scau_lth/article/details/83218335)
- [**Tomcat启动一闪而过就消失的原因和解决方法**](https://blog.csdn.net/qq904069486/article/details/80909780)

-------------------------------
【参考文章】

[项目启动tomcat失败的几种可能原因和解决方法](https://blog.csdn.net/u010565910/article/details/80411468)

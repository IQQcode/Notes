### 1.Maven简介

Maven的主要功能是，通过在pom.xml的`<dependency> `指定要在项目中使用的JAR库名称和版本，可以自动下载在外部站点上集中管理的JAR ，并在本地使用该JAR进行构建可以。

Maven构建项目的优势

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMjQyMTAucG5n?x-oss-process=image/format,png)

在传统的Web项目中，每个项目所需要的`jar`包文件都配置在**WEB-INF**下的lib目录下，如果所需要的jar包文件很多，则项目会很大，关键是jar包可能产生冲突，这才是要命的！web下几十行的报红，对于俺这种菜鸟来说简直是.....Maven的优势就在于能够复用jab包，构建了统一的Web目录结构，方便项目的管理和部署。

Maven 中的有两大核心：

- 依赖管理：对 jar 的统一管理(Maven 提供了一个 Maven 的中央仓库[https://mvnrepository.com/](https://mvnrepository.com/%EF%BC%8C)，当我们在项目中添加完依赖之后，Maven 会自动去中央仓库下载相关的依赖，并且解决依赖的依赖问题)

- 项目构建：对项目进行编译、测试、打包、部署、上传到私服等

### 2.Maven安装及配置

**安装仓库配置出门左转**

[**【Maven安装配置及在idea中配置】**](https://blog.csdn.net/weixin_43232955/article/details/97840767)

**Maven目录结构**

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMTE2MjcucG5n?x-oss-process=image/format,png)

**bin目录下**

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMTE4MTIucG5n?x-oss-process=image/format,png)

**boot目录**

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMTE5NTAucG5n?x-oss-process=image/format,png)

**config**

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMTIxMTYucG5n?x-oss-process=image/format,png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200303220432387.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

**lib**

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMTI2MjEucG5n?x-oss-process=image/format,png)

### 3.仓库repository

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMxMjIwMjMucG5n?x-oss-process=image/format,png)

**运行原理**  

运行Maven的时候，Maven所需要的任何构件首先从本地仓库获取。如果本地仓库没有，它会首先尝试从远程仓库下载构件至本地仓库，然后再使用本地仓库的构件。

> 关于如何将本地仓库修改到别的盘符，移步链接[**【Maven安装配置及在idea中配置】**](https://blog.csdn.net/weixin_43232955/article/details/97840767)

本地默认仓库位置

> **C:\Users\YourPC\\.m2**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200303220457894.png)
创建Maven项目，一定要保持网络畅通，否则一些依赖文件无法下载会导致项目报错！！！

### 4.Maven项目标准目录结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200303220515666.png)

- src/ main / java目录 核心代码部分

- src/ main / resources 配置文件部分

- src/ test / java目录 测试代码部分

- src/ test / resources 测试配置文件

- src/ main / webapp页面资源，js，cs，图片等等

### 5.Maven常用命令

`mvn -version`：显示版本信息

`mvn clean`：将编译过的target文件删除，清除产生的项目

`mvn compile`：编译src-main下源代码，并放置到target下

`mvn test-compile`：编译测试代码

`mvn test`：运行测试src下的代码

`mvn package`：打包

`mvn install`：打包项目并且安装到本地仓库

`mvn:deploy`：发布项目

【idea中集成的mvn命令】

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMyMTM4MTUucG5n?x-oss-process=image/format,png)

---

1. 创建maven项目：`mvn archetype:generate`
2. 验证项目是否正确：`mvn validate`
3. 只打jar包：`mvn jar:jar`
4. 生成源码jar包：`mvn source:jar`
5. 产生应用需要的任何额外的源代码：`mvn generate-sources`
6. 运行检查：`mvn verify`
7. 生成idea项目：`mvn idea:idea`
8. 显示maven依赖树：`mvn dependency:tree`
9. 显示maven依赖列表：`mvn dependency:list`

**web项目相关命令**

1. 启动tomcat：`mvn tomcat:run`
2. 启动jetty：`mvn jetty:run`
3. 运行打包部署：`mvn tomcat:deploy`
4. 撤销部署：`mvn tomcat:undeploy`
5. 启动web应用：`mvn tomcat:start`
6. 停止web应用：`mvn tomcat:stop`
7. 重新部署：`mvn tomcat:redeploy`
8. 部署展开的war文件：`mvn war:exploded tomcat:exploded`

### 6.项目对象模型pom.xml

Maven有三个内置的构建生命周期分别为：`clean`、`default`、`site`

我们一般使用的是默认的生命周期

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9ibG9naW1hZ2UtMTI1NTYxODU5Mi5jb3MuYXAtY2hlbmdkdS5teXFjbG91ZC5jb20vaW1nMjAyMDAzMDMyMDU2MjkucG5n?x-oss-process=image/format,png)

Maven 项目，如果需要使用第三方的控件，都是通过依赖管理来完成的。这里用到的一个东西就是 `pom.xml `文件，概念叫做项目对象模型（POM，Project Object Model），我们在 pom.xml 中定义了 Maven 项目的形式，所以，pom.xml 相当于是 Maven 项目的一个地图。

这个地图中都涉及到哪些东西呢？

**Maven 坐标**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200303220540808.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

- dependencies：添加项目需要的 jar 所对应的 maven 坐标

- dependency：一个 dependency 标签表示一个组件的坐标

- groupId：公司名

- artifactId：相当于在一个组织中项目的唯一标识符。

- version：一个项目的版本

- scope：表示依赖范围

![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9tbWJpei5xcGljLmNuL21tYml6X3BuZy9HdnRER0tLNHVZbTB2aWFoZWxEaWJPUXp0a0Qwd2FpYzd4ejF3UzAxeUk2UUd6eEZHSFpvUzZ3VW1nbk1VTndpYlpBbXlTMkJDdEprT2JMaWFCRWliSlFWaWNpYnBBLzY0MA?x-oss-process=image/format,png)

**jar包冲突问题**

maven所需要的jar包存放在本地仓库，但是在我们使用`jsp `、`servlet`时，项目有可能不识别`HttpServlet`而报红，此时我们导入相关依赖到 pom.xml 中，虽然解决了问题。但是将跑起来之后，会出现jar包冲突的问题...

这是为什么呢？

因为在本地仓库中和此项目中，出现了两个相同的重名jar包文件，本地项目中有servlet包，但是由于编译器不识别我们又导入了一份servlet包，导致冲突。

-------------------------

所以为了解决这样的问题，需要在冲突的jar包文件上加上作用域`provided`，让它只在编译时起作用

```xml
<dependency>
    <groupId>javax.servlet.jsp</groupId>

    <artifactId>javax.servlet.jsp-api</artifactId>

    <version>2.2.1</version>

    <scope>provided</scope><!--只在编译时起作用-->

</dependency>
```

pom.xml参考

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200303220607967.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

--------------------------------

【参考文章】

- [30个常用 Maven 命令](https://zhuanlan.zhihu.com/p/29208926)

- [maven命令大全](https://blog.csdn.net/keda8997110/article/details/20925449?ops_request_misc=%7B%22request%5Fid%22%3A%22158321681819724845043728%22%2C%22scm%22%3A%2220140713.130056874..%22%7D&request_id=158321681819724845043728&biz_id=0&utm_source=distribute.pc_search_result.none-task)

- [学Maven,看这一篇就够了](https://mp.weixin.qq.com/s?src=11&timestamp=1583204753&ver=2193&signature=CZcDtLVnP38oJs3Kq8RyZfTB4p0VAKsRCn0xaypJstbLJo-Zo3BRdOF7t4XLzmb03rmuY7PVeT*dEGgT033zHiyHdyRsf*jfGZmZpKhD*wmcFxeVrRJecjntfQU3jKEH&new=1)

- [开局一张图，学一学项目管理神器Maven！](https://mp.weixin.qq.com/s?src=11&timestamp=1583204753&ver=2193&signature=AVXfGAZSsVQEMrumww4rFU8kNz24Ugq9Ecqs3vOjR*SrRYK3pNhJDTko*GdY15ysga9KK1yO*nqkxkkBlGOVY8qwMBaSP1v1g0OSbzmB4*g-R8HgUvBi3eFJujS1Q9Xz&new=1)

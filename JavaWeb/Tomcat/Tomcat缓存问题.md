## Tomcat缓存区满问题

【报错信息】

> <font color=red size=3>无法将位于[/WEB-INF/classes/]的资源添加到Web应用程序[/News_Xifang_war_exploded]的缓存中，因为在清除过期缓存条目后可用空间仍不足 - 请考虑增加缓存的最大空间</font>

----------------------------------------------------------

> <font color=red size=3>警告 [main] org.apache.catalina.webresources.Cache.getResource 
> 无法将位于[/WEB-INF/classes/templates/framework/help/helpinfo.html]的资源添加到Web应用程序[/zhfx]的缓存中，
> 因为在清除过期缓存条目后可用空间仍不足 - 请考虑增加缓存的最大空间</font>

出现这种问题的原因是**Tomcat缓存区已满**，在启动Tomcat后，会出现web项目的图片资源等加载不出来。

**解决方法是清理Tomcat缓存区，或者将缓存区最大空间更改**。由于Tomcat配置出错之后比较麻烦，所以我们选择直接清理就好！



----------------------------------------



### 第一步

1.进入Tomcat的安装目录进行清理缓存，我使用的是`Tomcat-8.5.50`，不同版本的目录结构基本都是一样的，操作相同。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200127102752366.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
2.找到work文件夹。此文件下有个Catalina目录（tomcat小名叫Catalina），work目录下的文件都可以删除。删除work中的tomcat目录后，缓存已经删除
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200127103156517.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
>work目录只是tomcat的工作目录，也就是tomcat把 jsp转换为class文件的工作目录


### 第二步
找到Tomcat的安装目录，修改bin文件夹下的startup.bat文件
>`startup.bat`是Tomcat的启动命令

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200127103452641.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

**在startup.bat文件的头部加上批处理命令**

打开之后在第一行加上命令，后面为Tomcat的缓存区目录

`rd/s/q D:\apache-Tomcat-8.5.50\work\Catalina`
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200127103606464.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
关闭Tomcat服务，重新启动web项目即可！


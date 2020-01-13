@[TOC](Python中的深浅拷贝)

【原文参考链接】
- [超简单的图解 “ 深浅拷贝 ”](https://blog.csdn.net/qq_41333582/article/details/82155698)
- [Python中的深浅拷贝详解](https://blog.csdn.net/Jerry_1126/article/details/41852591)

我们都知道，Python 是面向对象对象的编程语言，典型的例子就是和Java一样，一切皆对象；但它又和Java有所区别，Python是动态类型的语言，在程序运行时候，会根据对象的类型来确认变量到底是什么类型. 典型的例子就是JavaScript.
- [**java中的类和对象**](https://blog.csdn.net/weixin_43232955/article/details/85752846)

要说清楚Python中的深浅拷贝，需要了解下几个简单的概念:

### 1.【变量-对象-引用】

- **变量**：是一个系统表的元素，拥有指向对象的连接的空间

- **对象**：是被分配的一块内存，存储其所代表的值

- **引用**：是自动形成的从变量到对象的指针

<kbd>单独赋值
<br>**a = 6**</kbd>

在运行a=6后，变量a变成了对象6的一个引用. 在内部，变量事实上是到对象内存空间的一个指针
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819195748762.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
因为Python的变量不过是对象的引用，或指向对象的指针，因此在程序中可以经常改变变量引用

赋值     | 含义
-------- | -----
x = 42  | 变量绑定到整型对象
x = 'Hello' | 变量绑定到字符串对象
x = [1,2,3]  | 变量绑定到列表对象

a = 6, 整数对象6包含了两重信息 :
1. 值为6
2. 一个头部信息：告诉Pthyon解释器，这是个整数对象(相当于一个指向int的指针)
  
**共享引用（赋值）**

比如说  <kbd>a = 6
b = a</kbd>

a 和 b 同时指向了同一个对象的内存地址
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819201540898.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819201651720.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)a 和 b 所指向的地址相同

**赋值 ： 对象之间赋值本质上 是对象之间的引用传递而已。也就是多个对象指向同一个数据空间**

【可变对象----不可变对象】

- Python中不可变对象指：一旦创建就不可修改的对象，包括 <font color=#FF7F5 size=3>字符串，元祖，数字</font>

- Python中可变对象是指：可以修改的对象，包括：<font color=	#6495ED size=3>列表、字典</font>
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819205315260.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819205235410.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819210326897.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
### 2. 【浅拷贝】
**浅拷贝是对一个对象的顶层数据的拷贝**
****
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820101434770.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820101718429.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820103928465.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
**浅拷贝的三种方式：**

`person = ['name', 'age']`

1. `p1  = copy.copy(person)`
2. `p2 = person[:]`
3. `p3 = list(person)`

### 3. 【深拷贝】

**深拷贝是对于一个对象所有层次的拷贝(递归)**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820143152127.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820143234643.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820143822733.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820144633746.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820144700838.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820145211198.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820154636568.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
***


### 4. 【浅拷贝与深拷贝的区别】

<kbd>**赋值与拷贝的区别**</kbd>
- **赋值是引用的改变，而拷贝是重新开辟一片空间**

<kbd>**深拷贝与浅拷贝的区别**</kbd>

- **浅拷贝只是拷贝最外层数据，而深拷贝是递归拷贝所有层数据**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820161411355.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
1. 深浅拷贝都是对源对象的复制，占用不同的内存空间
2. 如果源对象只有一级目录的话，源做任何改动，不影响深浅拷贝对象
3. 如果源对象不止一级目录的话，源做任何改动，都要影响浅拷贝，但不影响深拷贝
4. 序列对象的切片其实是浅拷贝，即只拷贝顶级的对象
****
【python中大部分方法都是浅拷贝如切片】
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820161917374.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
【字典的copy方法可以拷贝一个字典】


![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820161931909.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
**为什么Python中大多数都是浅拷贝呢?**

- 时间角度，浅拷贝花费**时间**更少
- 空间角度，浅拷贝花费**内存**更少
- 效率角度，浅拷贝只拷贝顶层数据，一般情况下比深拷贝**效率**高.


**浅拷贝对不可变类型和可变类型的copy不同**
- `copy.copy`对于可变类型，会进行浅拷贝
- `copy.copy` 和 `copy.deepcopy`对于不可变类型没有意义，全部等价于对象之间的赋值操作

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820163736667.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820163939965.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190820164106433.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

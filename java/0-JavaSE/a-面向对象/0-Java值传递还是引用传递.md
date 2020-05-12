> 文章多半内容为转载，转载自公众号[Hollis](https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650127218&idx=1&sn=f33a8f28e348519497921e074a01b758&chksm=f36ba653c41c2f453a1bef3715f22e07951586f12a2d9cf1f806585ced790dad7ea4968fae50&mpshare=1&scene=1&srcid=0511uiDvBikPBU2CCzsOwa3Y&sharer_sharetime=1589196963977&sharer_shareid=07633cd1d3facbfb7e1405bf63a3d2ca&key=1afad850a7d336760f3faf6ce8add0ef88c58fdd9b94dcf9db43751a28c1aa2024da35eaa45a811b564519dcb4437f710b90299b5e4c79c95b90e8263210d5bde0b29e2ce56e2d449d0a35c5fb24e73a&ascene=1&uin=MTE1Mjk1NTAwNQ%3D%3D&devicetype=Windows+10+x64&version=62090072&lang=zh_CN&exportkey=A1RgMyTHM1o8w7ArwJG77K8%3D&pass_ticket=4CGMr5smdr8Z2HI0yidJHCP%2BRg3MKjNz6TMmbhQIvTpPnIt4BjEptIc0zoiET46Y)关于**我要彻底给你讲清楚，Java就是值传递，不接受争辩的那种！**
>
> - 原文链接：[我要彻底给你讲清楚，Java就是值传递，不接受争辩的那种！](https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650127218&idx=1&sn=f33a8f28e348519497921e074a01b758&chksm=f36ba653c41c2f453a1bef3715f22e07951586f12a2d9cf1f806585ced790dad7ea4968fae50&mpshare=1&scene=1&srcid=0511uiDvBikPBU2CCzsOwa3Y&sharer_sharetime=1589196963977&sharer_shareid=07633cd1d3facbfb7e1405bf63a3d2ca&key=1afad850a7d336760f3faf6ce8add0ef88c58fdd9b94dcf9db43751a28c1aa2024da35eaa45a811b564519dcb4437f710b90299b5e4c79c95b90e8263210d5bde0b29e2ce56e2d449d0a35c5fb24e73a&ascene=1&uin=MTE1Mjk1NTAwNQ%3D%3D&devicetype=Windows+10+x64&version=62090072&lang=zh_CN&exportkey=A1RgMyTHM1o8w7ArwJG77K8%3D&pass_ticket=4CGMr5smdr8Z2HI0yidJHCP%2BRg3MKjNz6TMmbhQIvTpPnIt4BjEptIc0zoiET46Y)
> - 知乎回答链接：[**Java 到底是值传递还是引用传递？**](https://www.zhihu.com/question/31203609)
> - 知乎回答链接：[String str = "Hello"，到底有没有在堆中创建对象？](https://www.zhihu.com/question/29884421)
> - 原文链接：[请别再拿“String s = new String("xyz");创建了多少个String实例”来面试了吧](https://www.iteye.com/blog/rednaxelafx-774673)

## Java中的参数传递，到底是值传递还是引用传递？

**结论：Java只有值传递，没有引用传递！**

> 错误理解一：值传递和引用传递，区分的条件是传递的内容，如果是个值，就是值传递。如果是个引用，就是引用传递。
>
> 错误理解二：Java是引用传递。
>
> 错误理解三：传递的参数如果是普通类型，那就是值传递，如果是对象，那就是引用传递。

### 实参与形参

我们都知道，在Java中定义方法的时候是可以定义参数的。比如ava中的main方法，`public static void main(String[] args)`，这里面的args就是参数。参数在程序语言中分为形式参数和实际参数。

> 形式参数：是在定义函数名和函数体的时候使用的参数,目的是用来接收调用该函数时传入的参数。
>
> 
>
> 实际参数：在调用有参函数时，主调函数和被调函数之间有数据传递关系。在主调函数中调用一个函数时，函数名后面括号中的参数称为“实际参数”。

简单举个例子：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200511204054.png)

实际参数是调用有参方法的时候真正传递的内容，而形式参数是用于接收实参内容的参数。

### 基本类型与引用类型

```java
int num = 10;
String str = "hello";
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512171518.png)

如图所示，num 是基本类型，值就直接保存在变量中。而 `str `是引用类型，变量中保存的只是实际对象的地址。一般称这种变量为 "引用"，引用指向实际对象，实际对象中保存着内容。

### 赋值运算符“=”的作用

```java
num = 20;
str = "java";
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512171559.png)

对于基本类型 `num `，赋值运算符会直接改变变量的值，原来的值被覆盖掉。

对于引用类型 `str`，赋值运算符会改变引用中所保存的地址，原来的地址被覆盖掉。**但是原来的对象不会被改变（重要）。**

如上图所示，"hello" 字符串对象没有被改变。（**没有被任何引用所指向的对象是垃圾，会被垃圾回收器GC回收**）



### 值传递与引用传递

上面提到了，当我们调用一个有参函数的时候，会把实际参数传递给形式参数。但是，在程序语言中，这个传递过程中传递的两种情况，即值传递和引用传递。我们来看下程序语言中是如何定义和区分值传递和引用传递的

> 值传递（pass by value）是指在调用函数时将实际参数**复制**一份传递到函数中，这样在函数中如果对参数进行修改，将不会影响到实际参数。
>
> 引用传递（pass by reference）是指在调用函数时将实际参数的**地址**直接传递到函数中，那么在函数中对参数所进行的修改，将影响到实际参数。

- 值传递：将参数复制一份，修改形参不会对实参造成影响
- 引用传递：将实参的地址传递给形参，修改形参也就是在修改实参

我们来测试几段代码：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512110551.png)

上面的代码中，我们在 pass 方法中修改了参数 j 的值，然后分别在 pass 方法和 main 方法中打印参数的值。输出结果如下：

```java
print in pass , j is 20

print in main , i is 10
```

可见，pass 方法内部对 name 的值的修改并没有改变实际参数 i 的值。那么，按照上面的定义，有人得到结论：Java 的方法传递是值传递。

但是，很快就有人提出质疑了（哈哈，所以，不要轻易下结论咯。）。然后，他们会搬出以下代码：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512112429.png)

同样是一个 pass 方法，同样是在 pass 方法内修改参数的值。输出结果如下：

```java
print in pass , User{name='Tom', sex='man'}
print in main , User{name='Tom', sex='man'}
```

经过 pass 方法执行后，实参的值竟然被改变了，那按照上面的引用传递的定义，实际参数的值被改变了，这不就是引用传递了么。于是，根据上面的两段代码，有人得出一个新的结论：Java 的方法中，在传递普通类型的时候是值传递，在传递对象类型的时候是引用传递。

但是，这种表述仍然是错误的。不信你看下面这个参数类型为引用类型的参数传递：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512114944.png)

```java
print in pass , Tom
print in main , Mr.Q
```

那么，问题来了。String是引用类型，`new String("Mr.Q")`在堆上创建了对象，name指向了`Mr.Q`的引用。那按照上面来说，应该是引用传递了，输出的结果应该pass和main是相同的，可是，为什么会不同呢？

这又作何解释呢？同样传递了一个对象，但是原始参数的值并没有被修改，难道传递对象又变成值传递了？

**其实，是传递的地址值发生了改变**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512172623.png)

String类型在值传递和引用传递问题中比较特殊，为什么说特殊呢，因为对于一些常量字符串的创建，只要判断对象在堆中不存在，便会创建一个新的，如果是创建新对象，那么引用地址都会变。我们可以通过一个简单的例子来解释下：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512172853.png)

```java
a是：hello --- b是：你好
```

String a = "hello"; 在 String 池中检查并创建一个常量："hello"，给 a 分配一个栈内存，在此存储常量 hello 的地址。

String b= a; 给 b 分配一个栈内存，在此存储常量 hello 的地址。相当于 a 把自己持有的地址，复制给了 b。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512173420.png)

b = "你好"; 在 String 池中检查是否有 "你好" 的常量。

- 如果有，将 b 的地址指向 "你好" 的地址。
- 如果 String 池中没有 "你好" 常量，在堆内存中创建 "你好" 常量，并将 b 地址指向 "你好"。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512173444.png)

### Java中的值传递

值传递和引用传递之前的区别到底是什么？

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512141335.png)

**两者的最主要区别就是是直接传递的，还是传递的是一个副本**

这里我们来举一个形象的例子。再来深入理解一下传值调用和传引用调用：

--------------------------------------

- 你有一把钥匙，当你的朋友想要去你家的时候，如果你直接把你的钥匙给他了，这就是引用传递。
- 这种情况下，如果他对这把钥匙做了什么事情，比如他在钥匙上刻下了自己名字，那么这把钥匙还给你的时候，你自己的钥匙上也会多出他刻的名字。

----------------------------------------------------

- 你有一把钥匙，当你的朋友想要去你家的时候，你复刻了一把新钥匙给他，自己的还在自己手里，这就是值传递。
- 这种情况下，他对这把钥匙做什么都不会影响你手里的这把钥匙。

------------------------------------------------------------------

那我们再说回到这段代码中：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512112429.png)

```java
print in pass , User{name='Tom', sex='man'}
print in main , User{name='Tom', sex='man'}
```



看看在调用中，到底发生了什么？

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512155756.png)

在参数传递的过程中，实际参数的地址`0x666`被**拷贝**给了形参。这个过程其实就是值传递(这个值，理解为引用的地址)，只不过传递的值得内容是对象的应用。



那为什么我们改了`user`中的属性的值，却对原来的user产生了影响呢？

其实，这个过程就好像是：你复制了一把你家里的钥匙给到你的朋友，他拿到钥匙以后，并没有在这把钥匙上做任何改动，而是通过钥匙打开了你家里的房门，进到屋里，把你家的电视给砸了。

这个过程，对你手里的钥匙来说，是没有影响的，但是你的钥匙对应的房子里面的内容却是被人改动了。

也就是说，**Java对象的传递，是通过复制的方式把引用关系传递了，如果我们没有改引用关系，而是找到引用的地址，把里面的内容改了，是会对调用方有影响的，因为大家指向的是同一个共享对象。**

那么，如果我们改动一下pass方法的内容：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512160124.png)

上面的代码中，我们在pass方法中，重新new了一个user对象，并改变了他的值，输出结果如下：

```java
print in pass , User{name='Tom'}
print in main , User{name='Mr.Q'}
```

也就是说，我把我的钥匙复制给了我的朋友，但是我立马换了我家的锁。因为一`new`就会在堆上开辟新空间，地址就发生了改变，此时的`user`不再指向`0x666`了，理解为我换锁了，朋友当然进不了我家，砸不了电视了。所以此时在pass方法中修改name，不会对我家造成任何影响。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200512161121.png)

上面这种传递是什么传递？肯定不是引用传递，如果是引用传递的话，在`user = new User()`的时候，实际参数的引用也应该改为指向`0x999`，但是实际上并没有。

通过概念我们也能知道，这里是把实际参数的引用的地址复制了一份，传递给了形式参数。所以，**上面的参数其实是值传递，把实参对象引用的地址当做值传递给了形式参数。**

----------------------------------------------

所以，值传递和引用传递的区别并不是传递的内容，而是**实参到底有没有被复制一份给形参**。

在判断实参内容有没有受影响的时候，要看传的的是什么，如果你传递的是个地址，那么就看这个地址的变化会不会有影响，而不是看地址指向的对象的变化。

**所以说，Java 中其实还是值传递，只不过对于对象参数，值的内容是对象的引用。**

## 总结

无论是值传递还是引用传递，其实都是一种求值策略 ([Evaluation strategy](https://link.zhihu.com/?target=https%3A//en.wikipedia.org/wiki/Evaluation_strategy))。在求值策略中，还有一种叫做按共享传递 (call by sharing)。其实 Java 中的参数传递严格意义上说应该是按共享传递。

**按共享传递，是指在调用函数时，传递给函数的是实参的地址的拷贝（如果实参在栈中，则直接拷贝该值）。**

在函数内部对参数进行操作时，需要先拷贝的地址**寻找到具体的值**，再进行操作。

如果该值在栈中，那么因为是直接拷贝的值，所以函数内部对参数进行操作不会对外部变量产生影响。

如果原来拷贝的是原值在堆中的地址，那么需要先根据该地址找到堆中对应的位置，再进行操作。因为传递的是地址的拷贝，所以函数内对值的操作对外部变量是可见的。

**简单点说，Java 中的传递，是值传递，而这个值，实际上是对象的引用。**

- 传递的值在栈中，直接拷贝一份值传递，改变的形参不会对实参造成影响
- 传递的值在栈中存放的是地址（引用），先根据栈中的地址找到在堆上的值，然后把地址拷贝一份（**拷贝的地址**是一个值），此时形参和实参指向堆上同一个地址，形参的修改导致了实参的改变。



**<font color=red >Java中的参数传递，是值传递!</font>**

**<font color=red size=5>Java只有值传递!</font>**

**<font color=red size=5>Java只有值传递!</font>**

**<font color=red size=5>Java只有值传递!</font>**
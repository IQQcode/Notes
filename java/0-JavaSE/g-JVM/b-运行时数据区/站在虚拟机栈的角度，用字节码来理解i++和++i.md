### 面试官的拷问

👨‍🦲面试官：“说一说`i++`跟`++i`的区别”

😈我：“这个我懂！`i++`是先把i的值拿出来使用，然后再对i+1，`++i`是先对i+1，然后再去使用i”

👨‍🦲面试官：你说你懂`i++`跟`++i`的区别，那你知道下面这段代码的运行结果吗?

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626184623.png)

😈我：“以我零年的开发经验来看，它必然不会是10！”

![我开玩笑的（熊猫人）_熊猫人_开玩笑表情](http://ww4.sinaimg.cn/bmiddle/9150e4e5gw1fa84r676h8j205i048wek.jpg)

👨‍🦲面试官：![你可真会开玩笑啊_可真会_开玩笑表情](http://wx1.sinaimg.cn/bmiddle/005TGG6vly1fhvqbwls0hj304g04awee.jpg)

😈我：“哈哈…，开个玩笑，结果为0啦”

👨‍🦲面试官：“你能说说为什么吗？”

😈我：“因为`j++`这个表达式每次返回的都是0，所以最终结果就是0”

👨‍🦲面试官：“小伙子不错，那你能从JVM的角度讲一讲为什么嘛？”

😈我心想：这货明显是在搞事情啊，这么快就到JVM了？还好我有准备。

> 想要解释清楚这个问题，我们就必须要了解JVM的内存区域划分，主要涉及到的是**虚拟机栈**，通过JVM字节码指令来做具体分析！

### 暖场准备

JVM的运行时数据区Rutime Data Area分为这5大块：

![](https://img-blog.csdnimg.cn/20200406204445190.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxOTA3OTkx,size_16,color_FFFFFF,t_70)

虚拟机栈中又分为以下四块区域：

- 局部变量表（Local Variables）

- 操作数栈（Operand Stack）

- 动态链接（Dynamic Linking）

- 方法返回地址（Return Address）

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200625173710.png)

局部变量表Local Variables（局部变量数组或者本地变量表）。

1. 局部变量表是一个<font color = pink>数字数组</font>，主要用于存储方法参数和定义在方法体内的局部变量。
   
    - 数据类型包括：基本数据类型、引用类型、返回值类型

2. 线程私有数据，不存在线程安全问题

3. 局部变量表的容量大小在<font color = pink>编译期间</font>被确定，在方法运行期间不会改变

其中的局部变量表存放了编译期可知的各种基本数据类型（boolean、byte、char、short、int、float、long、double）、对象引用。局部变量表所需的内存空间在编译期间完成分配，当进入一个方法时，这个方法需要在帧中分配多大的局部变量空间是完全确定的，在方法运行期间不会改变局部变量表的大小。

> 局部变量表的最小存储单元为Slot（槽），其中**64位长度的long和double类型的数据会占用2个Slot**，其余的数据类型只占用1个。所以我们可以将局部变量表分为一个个的存储单元，每个存储单元有自己的下标位置，在对数据进行访问时可以直接通过下标来访问

操作数栈对于数据的存储跟局部变量表是一样的，但是跟局部变量表不同的是，操作数栈对于数据的访问不是通过下标而是通过标准的栈操作来进行的（压入与弹出），之后在分析字节码指令时我们会很明显的感觉到这一点。另外还有，对于数据的计算是由CPU完成的，所以CPU在执行指令时每次会从操作数栈中弹出所需的操作数经过计算后再压入到操作数栈顶。

### 开始表演

以执行下面这段代码为例：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626191221.png)

这个过程如下所示

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200407000113960.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxOTA3OTkx,size_16,color_FFFFFF,t_70)

这两步完成了局部变量a的赋值，同理b的赋值也一样，a,b完成赋值后此时的状态如下图所示

![](https://img-blog.csdnimg.cn/20200407000119578.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxOTA3OTkx,size_16,color_FFFFFF,t_70)

此时要执行a+b的运算了，所以首先要将需要的操作数加载到操作数栈，执行运算时再将操作数从栈中弹出，由CPU完成计算后再将结果压入到栈中，整个过程如下：

![](https://img-blog.csdnimg.cn/20200415150837173.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxOTA3OTkx,size_16,color_FFFFFF,t_70)

到这里还没有完哦，还剩最后一步，需要将计算后的结果赋值给c，也就是要将操作数栈的数据弹出并赋值给局部变量表中的第三个槽位

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200415150851538.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxOTA3OTkx,size_16,color_FFFFFF,t_70)

OK，到这一步整个过程就完成了

-------------------------------------------

👨‍🦲面试官：“嗯，说的不错，但是你还是没解释为什么最开始的那个问题，为什么`j=j++`的结果会是0呢？”

😈我：“面试官您好，要解释这个问题上面的知识都是基础，真正要说明白这个问题我们需要从字节码入手。”

我们进入到这段代码编译好的.class文件目录下执行反编译操作：

`javap -c xxx.class`

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626184623.png)

得到其字节码如下：

```java
  public void test1();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=2, locals=3, args_size=1
         0: iconst_0
         1: istore_1
         2: iconst_0
         3: istore_2
         4: iload_2
         5: bipush        10
         7: if_icmpge     21
        10: iload_1
        11: iinc          1, 1
        14: istore_1
        15: iinc          2, 1
        18: goto          4
        21: getstatic     #2  
        24: iload_1
        25: invokevirtual #3 
        28: return
      LineNumberTable:
        line 18: 0
        line 19: 2
        line 20: 10
        line 19: 15
        line 22: 21
        line 23: 28
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            4      17     2     i   I
            0      29     0  this   Liqqcode/pcregister/problemsAdd;
            2      27     1     j   I
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626190919.png)

```java
Code:
      0: iconst_0    // 将常数0压入到操作数栈顶
      1: istore_1    // 将操作数栈顶元素弹出并压入到局部变量表中1号槽位，也就是j=0
      2: iconst_0    // 将常数0压入到操作数栈顶
      3: istore_2     // 将操作数栈顶元素弹出并压入到局部变量表中2号槽位，也就是i=0
      4: iload_2     // 将2号槽位的元素压入操作数栈顶
      5: bipush        10    // 将常数10压入到操作数栈顶，此时操作数栈中有两个数（常数10，以及i）
      7: if_icmpge     21     // 比较操作数栈中的两个数，如果i>=10,跳转到第21行
      10: iload_1             // 将局部变量表中的1号槽位的元素压入到操作数栈顶，就是将j=0压入操作数栈顶
      11: iinc          1, 1 // 将局部变量表中的1号元素自增1，此时局部变量表中的j=1

      14: istore_1             // 将操作数栈顶的元素（此时栈顶元素为0）弹出并赋值给局部变量表中的1号    
      //槽位（一号槽位本来已经完成自增了，但是又被赋值成了0）

      15: iinc          2, 1 // 将局部变量表中的2号槽位的元素自增1，此时局部变量表中的2号元素值为1，也就是i=1

      18: goto          4     // 第一次循环结束，跳转到第四行继续循环
      21: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
      24: iload_1
      25: invokevirtual #3                  // Method java/io/PrintStream.println:(I)V
      28: return
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626191929.png)

**操作数栈主要用来保存计算过程的中间结果，同时作为计算过程中 变量临时的存储空间。**

我们着重关注第10，11，14行字节码指令，用图表示如下：

`指令10`： 将局部变量表中的1号槽位的元素压入操作数栈顶，即 j = 0 入栈

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626195227.png)

`指令11`： 将局部变量表中的1号槽位的元素自增1，即 j = 1

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626200242.png)

`指令14`： 将操作数栈顶元素（j = 0）出栈并赋给局部变量表1号槽位

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626200317.png)

此时操作数栈顶 j  = 0，局部变量表中1号槽位的值本来自增了，变成了 j = 1.  

但是操作数栈没自增就把值赋给了局部变量表1号槽，此时 j = 0

可以看到本来局部变量表中的j已经完成了自增（**`iinc`指令是直接对局部变量进行自增**），但是在进行赋值时是将操作数栈中的数据弹出，但是操作数栈的数据并没有经过计算，所以每次自增的结果都被覆盖了。

最终结果就是0。

----------------------

我们平常说的`i++`是先拿去用，然后再自增，而`++i`是先自增再拿去用。这个到底怎么理解呢？如果站在JVM的层次来讲的话，应该这样说：

1. `i++`是先被操作数栈拿去用了（先执行的`load`指令），然后再在局部变量表中完成了自增，但是操作数栈中还是**自增前的值**

2. `++1`是先在局部变量表中完成了自增（先执行`innc`指令），然后再被`load`进了操作数栈，所以操作数栈中保存的是**自增后的值**

**根本的区别就是`innc`和`load`指令先后执行的顺序问题。**

这就是它们的根本区别。

-------------------

### 拓展

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200626192637.png)

```java
public static test2() {
    int i = 4;
    int b = i++;
    int a = ++i;
}

public void test2();
Code:
       0: iconst_4
       1: istore_1
       2: iload_1
       3: iinc          1, 1
           6: istore_2
       7: iinc          1, 1
           10: iload_1
      11: istore_3
      12: return
```

安康是戴纳肯SVNAV那

----------------

原文参考自：[【面试官：你说你懂i++跟++i的区别，那你会做下面这道题吗】](https://blog.csdn.net/qq_41907991/article/details/105337049?depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-8.nonecase)

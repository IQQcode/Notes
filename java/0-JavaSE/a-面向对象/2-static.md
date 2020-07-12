> 原文转载自网络：[面试季，Java中的static关键字解析](http://www.cnblogs.com/dolphin0520/p/3799052.html)


### 1. static 关键字的用途

在《Java 编程思想》P86 页有这样一段话：

“static 方法就是没有 this 的方法。在 static 方法内部不能调用非静态方法，反过来是可以的。而且可以在没有创建任何对象的前提下，仅仅通过类本身来调用 static 方法。这实际上正是 static 方法的主要用途。”

这段话虽然只是说明了 static 方法的特殊之处，但是可以看出 static 关键字的基本作用，简而言之，一句话来描述就是：

方便在没有创建对象的情况下来进行调用（方法 / 变量）。

很显然，被 static 关键字修饰的方法或者变量不需要依赖于对象来进行访问，只要类被加载了，就可以通过类名去进行访问。

static 可以用来修饰类的成员方法、类的成员变量，另外可以编写 static 代码块来优化程序性能。

**static 方法**

static 方法一般称作静态方法，由于静态方法不依赖于任何对象就可以进行访问，因此对于静态方法来说，是没有`this`的，因为它不依附于任何对象，既然都没有对象，就谈不上 `this`了。并且由于这个特性，在静态方法中不能访问类的非静态成员变量和非静态成员方法，因为非静态成员方法 / 变量都是必须依赖具体的对象才能够被调用。

但是要注意的是，虽然在静态方法中不能访问非静态成员方法和非静态成员变量，但是在非静态成员方法中是可以访问静态成员方法 / 变量的。举个简单的例子：

![](https://mmbiz.qpic.cn/mmbiz_jpg/eQPyBffYbufSho5ToUK1aba6U4foSjF6lYABfJXrTVrgnmyw0rqwWOrts6uibGkiawfNgBBBkNkOTWFMVrDl651w/640?wx_fmt=jpeg)

在上面的代码中，由于 print2 方法是独立于对象存在的，可以直接用过类名调用。假如说可以在静态方法中访问非静态方法 / 变量的话，那么如果在 main 方法中有下面一条语句：

*MyObject.print2();*

此时对象都没有，str2 根本就不存在，所以就会产生矛盾了。同样对于方法也是一样，由于你无法预知在 print1 方法中是否访问了非静态成员变量，所以也禁止在静态成员方法中访问非静态成员方法。

而对于非静态成员方法，它访问静态成员方法 / 变量显然是毫无限制的。

因此，如果说想在不创建对象的情况下调用某个方法，就可以将这个方法设置为 static。我们最常见的 static 方法就是 main 方法，至于为什么 main 方法必须是 static 的，现在就很清楚了。因为程序在执行 main 方法的时候没有创建任何对象，因此只有通过类名来访问。

另外记住，即使没有显示地声明为 static，类的构造器实际上也是静态方法。

**2）static 变量**

static 变量也称作静态变量，静态变量和非静态变量的区别是：静态变量被所有的对象所共享，在内存中只有一个副本，它当且仅当在类初次加载时会被初始化。而非静态变量是对象所拥有的，在创建对象的时候被初始化，存在多个副本，各个对象拥有的副本互不影响。

static 成员变量的初始化顺序按照定义的顺序进行初始化。

**3）static 代码块**

static 关键字还有一个比较关键的作用就是 用来形成静态代码块以优化程序性能。static 块可以置于类中的任何地方，类中可以有多个 static 块。在类初次被加载的时候，会按照 static 块的顺序来执行每个 static 块，并且只会执行一次。

为什么说 static 块可以用来优化程序性能，是因为它的特性: 只会在类加载的时候执行一次。下面看个例子:

```java
class Person {
    private Date birthDate;
    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    boolean isBornBoomer() {
    Date startDate = Date.valueOf("1946");
    Date endDate = Date.valueOf("1964");
    return birthDate.compareTo(startDate) >= 0 && birthDate.compareTo(endDate) < 0;
    }
}
```

isBornBoomer 是用来这个人是否是 1946-1964 年出生的，而每次 isBornBoomer 被调用的时候，都会生成`startDate`和 `birthDate`两个对象，造成了空间浪费，如果改成这样效率会更好：

```java
class Person{
    private Date birthDate;
    private static Date startDate,endDate;
    static {
        startDate = Date.valueOf("1946");
        endDate = Date.valueOf("1964");
    }

    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    boolean isBornBoomer() {
        return birthDate.compareTo(startDate) >=0 && birthDate.compareTo(endDate) < 0;
    }
}
```

因此，很多时候会将一些只需要进行一次的初始化操作都放在 static 代码块中进行

### 2. static 关键字的误区

**1.static 关键字会改变类中成员的访问权限吗？**

有些初学的朋友会将 java 中的 static 与 C/C++ 中的 static 关键字的功能混淆了。在这里只需要记住一点：与 C/C++ 中的 static 不同，Java 中的 static 关键字不会影响到变量或者方法的作用域。在 Java 中能够影响到访问权限的只有 `private`、`public`、`protected`（包括包访问权限）这几个关键字。看下面的例子就明白了：

![](https://mmbiz.qpic.cn/mmbiz_jpg/eQPyBffYbufSho5ToUK1aba6U4foSjF6mcM5TCpTQ5WFulLhc0jEg4vbdHtypLdltYjdLqiadbyc4MqkrW51qmA/640?wx_fmt=jpeg)

提示错误 "Person.age 不可视"，这说明 static 关键字并不会改变变量和方法的访问权限。

**2. 能通过 this 访问静态成员变量吗？**

虽然对于静态方法来说没有 this，那么在非静态方法中能够通过 this 访问静态成员变量吗？先看下面的一个例子，这段代码输出的结果是什么？

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200521125351.png)

这里面主要考察队 this 和 static 的理解。this 代表什么？this 代表当前对象，那么通过 new Main() 来调用 printValue 的话，当前对象就是通过 new Main() 生成的对象。而 static 变量是被对象所享有的，因此在 printValue 中的 this.value 的值毫无疑问是 33。  

在 printValue 方法内部的 value 是局部变量，根本不可能与 this 关联，所以输出结果是 33。在这里永远要记住一点：静态成员变量虽然独立于对象，但是不代表不可以通过对象去访问，所有的静态方法和静态变量都可以通过对象访问（只要访问权限足够）。

**3.static 能作用于局部变量么？**

在 C/C++ 中 static 是可以作用域局部变量的，但是在 Java 中切记：static 是不允许用来修饰局部变量。不要问为什么，这是 Java 语法的规定。

**三. 常见的笔试面试题**

下面列举一些面试笔试中经常遇到的关于 static 关键字的题目，仅供参考，如有补充欢迎下方留言。

**1. 下面这段代码的输出结果是什么？**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200521224620.png)

输出：

> base static
> test static
> base constructor
> test constructor

先来看一下这段代码具体的执行过程，在执行开始，先要寻找到 main 方法，因为 main 方法是程序的入口。但是在执行 main 方法之前，必须先加载 Test 类，而在加载 Test 类的时候发现 Test 类继承自 Base 类，在有继承关系的类中，先加载的是父类，其次才是子类。

本类中加载的顺序本着：静态块---->>构造块---->>普通代码块的顺序

因此会转去先加载 Base 类，在加载 Base 类的时候，发现有 static 块，便执行了 static 块。在 Base 类加载完成之后，便继续加载 Test 类，然后发现 Test 类中也有 static 块，便执行 static 块。在加载完所需的类之后，便开始执行 main 方法。在 main 方法中执行 new Test() 的时候会先调用父类的构造器，然后再调用自身的构造器。因此，便出现了上面的输出结果。

**2. 这段代码的输出结果是什么？**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200521225456.png)

输出：

> test static
> myclass static
> person static
> person Test
> test constructor
> person MyClass
> myclass constructor

类似地，我们还是来想一下这段代码的具体执行过程。首先加载 Test 类，因此会执行 Test 类中的 static 块。接着执行 new MyClass()，而 MyClass 类还没有被加载。

因此需要加载 MyClass 类。在加载 MyClass 类的时候，发现 MyClass 类继承自 Test 类，但是由于 Test 类已经被加载了，所以只需要加载 MyClass 类，那么就会执行 MyClass 类的中的 static 块。

在加载完之后，就通过构造器来生成对象。而在生成对象的时候，必须先初始化父类的成员变量，因此会执行 Test 中的 Person person = new Person()，而 Person 类还没有被加载过，因此会先加载 Person 类并执行 Person 类中的 static 块。

接着执行`Person`类的构造器，完成了类的初始化，然后就来初始化自身了。因为是先实例化`Pserson`类，再实例化自身（按照代码的顺序执行），因此会接着执行 MyClass 中的 Person person = new Person()，最后执行 MyClass 的构造器。

**3. 这段代码的输出结果是什么？**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200521230837.png)

输出：

> test static 1
> test static 2

虽然在 main 方法中没有任何语句，但是还是会输出，原因上面已经讲述过了。另外，static 块可以出现类中的任何地方（只要不是方法内部，记住，任何方法内部都不行），并且执行是按照 static 块的顺序执行的

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200527144440.png)

### 1. 函数式编程思想

面向对象的思想：

- 做—件事情，找一个能解决这个事情的对象，调用对象的方法完成
  

函数式编程思想：

- 只要能获取到想要的结果，谁去做的怎么做的都不重要，重视的是结果不重视过程

### 2. Lambda表达式引入

为什么要使用Lambda表达式？

- 避免匿名内部类定义过多

- 让代码实现相同的逻辑看起来更加简洁



**函数式接口：** 接口中只包含唯一一个抽象方法，那么就是函数式接口

例如：

```java
public interface Runnable {
    public abstract void run();
}
```

> Lambda是JDK8引入的新特性函数式接口是Lambda表达式的关键所在

有了函数式接口，我们就可以通过 lambda表达式来创建该接口的对象。

通常情况下，对于一个接口及实现类，我们都会这么写：

```java
interface Lambda {
    void lambda();
}

class MyLambda implements Lambda {

    @Override
    public void lambda() {
        System.out.println("学习lambda表达式...");
    }
}

public class LambdaLearn {
    public static void main(String[] args) {
        Lambda lb = new MyLambda();
        lb.lambda();
    }
}
```

> 学习lambda表达式...

我们需要写三个类来实现接口，用函数式编程来看待带的话就会显得很繁琐。于是，我们可以通过内部类来改进：

> [**还好面试官还没问，赶紧把【内部类】的知识点补上**](https://blog.csdn.net/weixin_43232955/article/details/106151693)



**改进一：静态内部类**

将`MyLambda`类中的代码放到`LambdaLeadn`中，变为静态内部类

```java
interface Lambda {
    void lambda();
}

public class LambdaLearn {

    //静态内部类
    static class MyLambda implements Lambda {
        @Override
        public void lambda() {
            System.out.println("学习lambda表达式...");
        }
    }
    
    public static void main(String[] args) {
        Lambda lb = new MyLambda();
        lb.lambda();
    }
}
```

> 学习lambda表达式...

然后，继续简化

**改进二：成员内部类**

将`MyLambda`变为成员内部类

```java
interface Lambda {
    void lambda();
}

public class LambdaLearn {
    public static void main(String[] args) {
        //成员内部类
        class MyLambda implements Lambda {
            @Override
            public void lambda() {
                System.out.println("学习lambda表达式...");
            }
        }

        Lambda lb = new MyLambda();
        lb.lambda();
    }
}
```

再试试，还能简化？

**改进三：匿名内部类**

直接通过匿名内部类来实现接口

```java
interface Lambda {
    void lambda();
}

public class LambdaLearn {
    public static void main(String[] args) {
        //成员内部类
        new Lambda() {
            @Override
            public void lambda() {
                System.out.println("学习lambda表达式...");
            }
        }.lambda();
    }
}
```

通过内部类的三次改进，实现同样的功能我们简化了代码。但是，如果匿名内部类定义了很多，功能实现了，但是代码读不懂了。于是，我们在此基础上引入了lambda表达式

**lambda表达式推倒**

```java
interface Lambda {
    void lambda();
}

public class LambdaLearn {
    public static void main(String[] args) {
        Lambda lb = () -> {
            System.out.println("学习lambda表达式...");
        };
        lb.lambda();
    }
}
```

语义分析

- 前面的一对小括号即lambda方法的参数（无），代表不需要任何条件；

- 中间的一个箭头`->`代表将前面的参数传递给后面的代码； 

- 后面`{}`中的代码为重写接口中抽象方法的方法体

那，lambda还能不能再简化了？

### 3. lambda表达式简化

#### 简化参数类型

定义一个有参的lambda表达式来简化

```java
interface Lambda {
    void lambda(String str);
}

public class Simplify {
    public static void main(String[] args) {
        Lambda lb = (String str) -> {
            System.out.println(str);
        };
        lb.lambda("lambda表达式");
    }
}
```

- 简化参数类型

- 简化括号

- 简化代码块`{ }`

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200527155545.png)

如果是多个参数则不能简化

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200527155743.png)

#### Lambda表达式实现Runnable接口

```java
public class LThread {
    public static void main(String[] args) {
        //使用匿名内部类实现多线程
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("线程" + Thread.currentThread().getName() + "创建了");
            }
        }).start();

        //lambda实现多线程
        new Thread(()-> {
                System.out.println("线程" + Thread.currentThread().getName() + "创建了");
            }
        ).start();
    }
}
```

> 线程Thread-0创建了
> 线程Thread-1创建了



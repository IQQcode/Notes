> 这篇文章主要是关于 **java.util.concurrent(JUC)** 类包下的常用类
> 
> </br>
> 
> JUC是JDK5才引入的并发类库. JUC中为了满足在并发编程中不同的需求，提供了几个工具类供我们使用，分别是 
> 
> **CountDownLatch，CyclicBarrier，Semaphore和 Exchanger** 下面分别进行简单的介绍.

### 1. CountDownLatch-闭锁

CountDownLatch类位于`java.util.concurrent`包下，利⽤用它可以实现类似计数器的功能.

CountDownLatch 的主要作用是利用计数来保证线程的执行顺序，有点像倒计时，当计数为0时某个线程才能开始执行

**CountDownLatch类只提供了⼀一个构造器：**

```java
public CountDownLatch(int count) { }; //参数count为计数值
```

**CountDownLatch中的常用方法**，包括：

- `CountDownLatch(int count)` ： 构造方法，需要传入计数的初始值
- `void await()` ：等待线程调⽤用`await()`方法的线程会被一直被阻塞，它会等待直到count计数器的值为0才继续执行
- `boolean await(long timeout, TimeUnit unit)` ： 同上，但是加入了超时参数，如果超时了计数还不为0，也会照样执行，避免了一直阻塞
- `void countDown()` ： 计数减一

<img src = "https://img-blog.csdnimg.cn/2019081514311175.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "50%">

- **闭锁 : 每个 `CountDowmLatch`对象的计数器在值减为0时不可恢复原值**

> **使用场景**
> 
> 比如有一个任务A，它要等待其他3个任务执行完毕之后才能执行，此时就可以利用**CountDownLatch**来实现这种功能.

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815190401103.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

<kbd>模拟三个运动员跑步的场景</kbd>

```java
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-12 13:56
 * @Description:CountDownLatch阻塞线程,等到子线程减到相应count主线程才继续执行
 */
class CountDownTest implements Runnable {
    private CountDownLatch countDownLatch;

    public CountDownTest(CountDownLatch countDownLatch) {
        this.countDownLatch = countDownLatch;
    }

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() +"已经到达终点");
        countDownLatch.countDown();
    }
}

public class CountDownLatchTest {
    public static void main(String[] args) throws InterruptedException {
        // 主线程等待三个子线程减为 0再恢复执行
        //参数count为计数值
        CountDownLatch countDownLatch = new CountDownLatch(3); 
        System.out.println("Game start...");
        new Thread(new CountDownTest(countDownLatch),"Runner A").start();
        TimeUnit.SECONDS.sleep(1);
        new Thread(new CountDownTest(countDownLatch),"Runner B").start();
        TimeUnit.SECONDS.sleep(1);
        new Thread(new CountDownTest(countDownLatch),"Runner C").start();
        // 主线程阻塞,等待 Runner A,B,C都到达终点后再执行
        countDownLatch.await();
        System.out.println("All Runners have reached destination.\nGame end!");
    }
}
```

运行结果：

<img src = "https://img-blog.csdnimg.cn/20190815145130454.gif" width ="60%">

如果在输出 `All Runners have reached destination.\nGame end!`之前不调用 `await()`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815145224365.png)

则运行结果会出现：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815144804432.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

此时主线程和A，B，C 三个线程并行，没有调用`await()`的主线程将不再阻塞.

### 2. CyclicBarrier-循环栅栏

**循环栅栏** ： 

- 循环：每个CyclicBarrier的对象可以重复使用
- 栅栏 ： 每个子线程都阻塞，让一组线程同时到达某个时间节点

> **使用场景**
> </br>
> 例如三个子线程 A,B,C 在分别写入数据，其中 A线程写完数据后会阻塞，等待 B,C线程也写完数据后，才恢复执行；此时主线程才能读数据

![在这里插入图片描述](【JUC包下的常用工具类】.assets/20190815191955880.png)

**CyclicBarrier提供2个构造器器：**

- `public CyclicBarrier(int parties) {}`

<font color=#FF7F50 size=3>所有子线程调用</font>`await()`后，将计数器值减1并进入==阻塞状态==；
<font color=#FF7F50 size=3>直到计数器值减为0</font>时，所有调用`await()`阻塞的子线程再同时恢复执行

- `public CyclicBarrier(int parties, Runnable barrierAction) {}`

所有调用`await()`阻塞的子线程在计数器值减为0后，随机挑选一个线程执行 **barrierAction** 任务后，所有子线程恢复执行

**CyclicBarrier中常用的方法：**

`int await()` : 挂起当前线程，直到所有线程组中的线程都完成后继续执行，返回当前线程到达次序

`int await(long timeout, TimeUnit unit)` ： 加了一个超时参数

我们来拿做饭举个例子，众所周知，在脱单这一环节，会做饭的蓝人，在广大只会敲代码的搬砖工面前是有绝对优势的，有空了我一定要习得一手好厨艺...

<img src = "https://img-blog.csdnimg.cn/20190815152522273.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "35%">

[**大葱牛肉饺子做法**](http://www.xiachufang.com/recipe/103530154/)

<kbd>以做饺子为例，A,B,C三道工序</kbd>

```java
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.TimeUnit;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-12 15:02
 * @Description:所有调用await()阻塞的子线程在计数器值减为 0后
 * 随机挑选一个线程执行 barrierAction任务后,所有子线程恢复执行
 */
class CyclicActionTest implements Runnable {
    private CyclicBarrier cyclicBarrier;

    public CyclicActionTest(CyclicBarrier cyclicBarrier) {
        this.cyclicBarrier = cyclicBarrier;
    }

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + "做饺子中...");
        try {
            TimeUnit.SECONDS.sleep(3);
            // 所有子线程再次都阻塞
            cyclicBarrier.await();
            System.out.println("所有操作都已完成！\t开吃...");
        } catch (InterruptedException | BrokenBarrierException e) {
            e.printStackTrace();
        }
    }
}
public class CyclicBarrierActionTest {
    public static void main(String[] args) throws InterruptedException {
        // 传入线程组的数量和当线程达到时间节点后要做的操作
        CyclicBarrier cyclicBarrier = new CyclicBarrier(3, new Runnable() {
            @Override
            public void run() {
                System.out.println("\n哪个环节最重要？: "+Thread.currentThread().getName()+"\n");
            }
        });
        new Thread(new CyclicTest(cyclicBarrier),"A 和面中,勿扰 ").start();
        TimeUnit.SECONDS.sleep(1);
        new Thread(new CyclicTest(cyclicBarrier),"B 剁饺子馅,包饺子").start();
        TimeUnit.SECONDS.sleep(1);
        new Thread(new CyclicTest(cyclicBarrier),"C 下锅煮饺子").start();
    }
}
```

待 A，B，C分别完成任务后，饺子才可以吃.

执行内容好像忘记改了，但是步骤是一样的

<img src = "https://img-blog.csdnimg.cn/20190815155130827.gif" width = "60%">

执行过程分析：

1. A和完面之后便阻塞
2. 此后B剁饺子馅,包饺子，完成之后也阻塞
3. A，B此时在阻塞中，C下锅煮饺子
4. 调用`await()`阻塞的子线程在计数器值减为0后(即A，B，C执行完之后，随机挑选一个线程执行 **barrierAction**任务(`new Runnable()`,哪个环节最重要?)
5. 然后**所有**子线程恢复执行

### 3. Semaphore-信号量

**Semaphore**用于控制信号量的个数，构造时传入个数. 总数就是控制并发的数量.

控制并发的数量假如是5，程序执行前用`acquire()`方法获得信号，则可用信号变为4，程序执行完通过`release()`方法归还信号量，可用信号又变为5.

如果可用信号为0，**acquire**就会造成阻塞，等待**release**释放信号. `acquire()`和`release()`可以不在同一个线程使用. 

****

Semaphore实现的功能就类似厕所有5个坑位，假如有10个人要上厕所，那么同时只能有5个人能够占用，当5个人中 的任何一个人让开后，其中等待的另外5个人中又有一个人可以占用了. 

另外等待的5个人中可以是随机获得优先机会，也可以是按照先来后到的顺序获得机会，这取决于构造**Semaphore**对象时传入的参数选项.  单个信号量的**Semaphore**对象可以实现互斥锁的功能，并且可以是由一个线程获得了“锁”，再由另一个线程释放“锁”，这可应用于死锁恢复的一些场合.

***

**Semaphore类提供了2个构造器：**

- 参数permits表示许可数目，即同时可以允许多少线程进行访问
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815161600707.png)
- 多了⼀个参数fair表示是否是公平的，即等待时间越久的越先获取许可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815161701375.png)

**Semaphore类中常用的方法**

- `acquire()` : 用来获取一个许可，若无许可能够获得，则会一直等待，直到获得许可
- 获取一个许可![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815162050713.png)获取permits个许可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815162114233.png)
- `release()` : 用来释放许可；(在释放许可之前，必须先获得许可)
- 释放一个许可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815162351743.png)
  释放permits个许可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019081516241628.png)

<kbd>8说了，网吧开黑走起！！！</kbd>

```java
import java.util.concurrent.Semaphore;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-12 16:25
 * @Description:Semaphore
 */

// 网吧开黑
class SemaphoreDemo implements Runnable {
    private Semaphore semaphore;
    private int num;

    public SemaphoreDemo(Semaphore semaphore, int num) {
        this.semaphore = semaphore;
        this.num = num;
    }

    @Override
    public void run() {
        //尝试申请设备
        try {
            semaphore.acquire();
            System.out.println("玩家"+ this.num +"使用一台电脑打游戏...");
            Thread.sleep(2000);
            System.out.println("玩家"+ this.num +"释放一台设备！");
            semaphore.release();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
public class SemaphoreTest {
    public static void main(String[] args) {
        //信号量为5
        Semaphore semaphore = new Semaphore(5); //5台设备
        for(int i = 0; i < 8; i++) { //8名玩家
            new Thread(new SemaphoreDemo(semaphore,(i+1))).start();
        }
    }
}
```

<img src = "https://img-blog.csdnimg.cn/2019081516405373.gif" width = "60%">

可以看到这一组线程是同步的去执行的

### 4. Exchanger-线程数据交换器

> **使用场景**
> </br>
> 用于两个线程的数据交换(不能用于多个)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815192047651.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

**调用exchange()方法会阻塞当前线程，必须等到另外一个线程时才可进行数据交换**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815165146228.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
<kbd>期待在最美的年华，遇到最美的你...</kbd>

```java
import java.util.concurrent.Exchanger;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-12 16:08
 * @Description:
 */
public class ExchangerTest {
    public static void main(String[] args) {
        Exchanger<String> exchanger = new Exchanger<>();
        Thread boyThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    String boy = exchanger.exchange("我明白你会来，所以我等！\n");
                    System.out.println("The boy said : To the most beautiful you ↓ \n" + boy);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        boyThread.start();

        Thread girlThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    String girl = exchanger.exchange("一个人心头上的微风，吹到另外一个人生活里去时，是偶然还是必然？\n" +
                            "人生的理想，是情感的节制恰到好处，还是情感的放肆无边无涯？\n" +
                            "生命的取与，是昨天的好，当前的好，还是明天的好？");
                    System.out.println("\nThe girl said : To the world who knows me the most ↓ \n" + girl);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        girlThread.start();
    }
}
```

boy 和 girl 说的话交换...
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815173928376.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

文章部分内容参考自：

- [JUC包下的工具类CountDownLatch、CyclicBarrier和Semaphore
  ](https://www.cnblogs.com/puyangsky/p/6260404.html)

- [Java多线程---JUC包下的常见类](https://blog.csdn.net/u013080921/article/details/42922409)

- boy 和 girl said 来自 **沈从文**
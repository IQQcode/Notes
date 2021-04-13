## 1. COW思想

写入时复制（CopyOnWrite，简称COW）思想是计算机程序设计领域中的一种优化策略。其核心思想是，如果有多个调用者（Callers）同时要求相同的资源（如内存或者是磁盘上的数据存储），他们会共同获取相同的指针指向相同的资源，直到某个调用者视图修改资源内容时，系统才会真正复制一份专用副本（private copy）给该调用者，而其他调用者所见到的最初的资源仍然保持不变。这过程对其他的调用者都是透明的（transparently）。此做法主要的优点是如果调用者没有修改资源，就不会有副本（private copy）被创建，因此多个调用者只是读取操作时可以共享同一份资源。

### 1.1 什么是CopyOnWrite容器

Copy-On-Write简称COW，是一种用于程序设计中的优化策略。见名知意就是在**写时复制**，其本质思想就是”**读时共享，写时分离**“。这是一种延时懒惰策略，从JDK1.5开始Java并发包里提供了两个使用CopyOnWrite机制实现的并发容器,它们是`CopyOnWriteArrayList`和`CopyOnWriteArraySet`。CopyOnWrite容器非常有用，可以在非常多的并发场景中使用到。

### 1.2 基本原理

我们以CopyOnWriteArrayList为例，因为CopyOnWriteArraySet是基于CopyOnWriteArrayList来实现的：

> 我们可以看到CopyOnWriteArraySet在初始化是是new的CopyOnWriteArrayList

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs02/20201207191915.png)

`CopyOnWriteArrayList`使用了一种叫**写时复制**的方法，当有新元素添加到`CopyOnWriteArrayList`时，先从原有的数组中拷贝一份出来，然后在新的数组做写操作，写完之后，再**将原来的数组引用指向到新数组**。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs02/20201207193126.png)

当有新元素加入的时候，创建新数组，并往新数组中加入一个新元素。

- 这个时候，array这个引用仍然是指向原数组的
- 当元素在新数组添加成功之后，才将array的引用指向新数组

这样做的好处是我们可以对CopyOnWrite容器进行并发的读，而不需要加锁，因为当前容器不会添加任何元素。所以CopyOnWrite容器也是一种读写分离的思想，读和写不同的容器。

## 2. CopyOnWrite容器如何保证线程安全

### 2.1 源码分析

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs02/640.png)

相关参数

```java
public class CopyOnWriteArrayList<E>
    implements List<E>, RandomAccess, Cloneable, java.io.Serializable {
    private static final long serialVersionUID = 8673264195747942595L;
    
    // 数据有变动时使用 
    final transient ReentrantLock lock = new ReentrantLock();

    // 数组 只能通过 getArray/setArray 访问
    private transient volatile Object[] array;

    final Object[] getArray() {
        return array;
    }

    // 将数组指向传入的新数组
    final void setArray(Object[] a) {
        array = a;
    }
    
    // 构造函数
    public CopyOnWriteArrayList() {
        setArray(new Object[0]);
    }
}
```

由上可知：

1. CopyOnWriteArrayList基于数组(Object[])实现
2. 使用了 ReentrantLock 互斥锁

### 2.2 add方法

```java
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        // 得到原数组的长度和元素
        Object[] elements = getArray();
        int len = elements.length;
        // 复制出新数组
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        // 把新元素添加到新数组里
        newElements[len] = e;
         // 将volatile Object[] array 的指向替换成新数组
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
```

add 方法逻辑很简单：

1. 通过加互斥锁（ReentrantLock）从而保证在写的时候只有一个线程可以写，否则内存中会有多份被复制的数据；
2. 新增元素时，先使用 `Arrays.copyOf(elements, len + 1)` 复制出一个长度 +1 的新数组
3. 添加元素到新数组
4. 然后再将原数组对象指向新数组，数组引用是`volatile`修饰的，因此将旧的数组引用指向新的数组，根据volatile的happens-before规则，写线程对数组引用的修改对读线程是可见的。

> 添加(写)的时候是需要加锁的，否则多线程写的时候会Copy出N个副本出来

由于所有的写操作都是在新数组进行的，这个时候如果有线程并发的写，则通过锁来控制，如果有线程并发的读，则分几种情况：

1. 如果写操作未完成，那么直接读取原数组的数据；
2. 如果写操作完成，但是引用还未指向新数组，那么也是读取原数组数据；
3. 如果写操作完成，并且引用已经指向了新的数组，那么直接从新数组中读取数据

<br>

### 2.3 get方法

```java
public E get(int index) {
    return get(getArray(), index);
}
```

1. 获取元素并**没有加锁**
2. 从**原(旧)**数组获取的元素

读的时候不需要加锁，如果读的时候有多个线程正在向ArrayList添加数据，读还是会**读到旧的数据**，因为写的时候不会锁住旧的ArrayList。所以在并发情况下，**并不能保证很及时的读取的刚插入或者移除的元素**

<br>

### 2.4 remove方法

```java
public E remove(int index) {
    // 加锁
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        // 源数组
        Object[] elements = getArray();
        int len = elements.length;
        // 移除的值
        E oldValue = get(elements, index);
        int numMoved = len - index - 1;
        if (numMoved == 0)
            // 如果移除最后一个元素，直接复制该元素前的所有元素到新的数组
            setArray(Arrays.copyOf(elements, len - 1));
        else {
            /** 移除中间的元素，进行两次复制 */
            // 创建新的数组
            Object[] newElements = new Object[len - 1];
            // 将index + 1 至最后一个元素向前移动一格
            System.arraycopy(elements, 0, newElements, 0, index);
            System.arraycopy(elements, index + 1, newElements, index,
                             numMoved);
            setArray(newElements);
        }
        return oldValue;
    } finally {
        lock.unlock();
    }
}
```

remove 方法相对多了一些判断：

1. 通过加互斥锁（ReentrantLock）从而保证在写的时候只有一个线程可以移除元素
2. 如果移除的是最后一个元素，则直接复制前面的元素到新数组，并指向新数组即可
3. 如果移除的是中间的元素，则需要进行两次复制，然后指向新数组

![image-20201207203721364](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/imgs02/image-20201207203721364.png)

### 2.5 Set方法

```java
public E set(int index, E element) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {

        // 得到原数组的旧值
        Object[] elements = getArray();
        E oldValue = get(elements, index);

        // 判断新值和旧值是否相等
        if (oldValue != element) {

            // 复制新数组，新值在新数组中完成
            int len = elements.length;
            Object[] newElements = Arrays.copyOf(elements, len);
            newElements[index] = element;

            // 将array引用指向新数组
            setArray(newElements);
        } else {
            // Not quite a no-op; enssures volatile write semantics
            // 不是完全禁止操作； 确保可变的写语义
            setArray(elements);
        }
        return oldValue;
    } finally {
        lock.unlock();
    }
}
```

方法通过 ReentrantLock 可重入锁控制加锁和解锁。

这样做的好处就是写是不阻塞读的，缺点就是比较浪费内存，拷贝数组也是要花时间的。

----------

**【小结】**

- 在 add、remove 操作时会进行加锁，然后复制出来一个新数组，**操作的都是新数组**，而此时**原数组是可以提供查询**的。当操作结束之后，会将对象指针指向新数组
-  复制是使用本地方法 `System.arraycopy` 进行数组的复制

当我们往一个容器添加元素的时候，不直接往当前容器添加，而是先将当前容器进行Copy，**复制出一个新的容器**，然后新的容器里添加元素，添加完元素之后，再将原容器的引用指向新的容器

对CopyOnWrite容器进行并发的读的时候，不需要加锁，因为当前容器不会添加任何元素。所以CopyOnWrite容器也是**一种读写分离的思想**，**延时更新的策略**是通过在写时针对不同的容器来实现，放弃**数据实时性**达到数据的最终**一致性**。

<br>

## 3. 适用场景

CopyOnWrite并发容器用于**读多写少**的并发场景；比如白名单、黑名单，商品类目的访问和更新场景。

假如我们有一个搜索网站，用户在这个网站的搜索框中，输入关键字搜索内容，但是某些关键字不允许被搜索。这些不能被搜索的关键字会被放在一个黑名单当中，黑名单每天晚上更新一次。当用户搜索时，会检查当前关键字在不在黑名单当中，如果在，则提示不能搜索。

> JDK中并没有提供CopyOnWriteMap，我们可以参考CopyOnWriteArrayList来实现一个
>
> 代码来自 https://www.jb51.net/article/178587.htm

**CopyOnWriteMap**

```java
public class CopyOnWriteMap<K, V> {
    private volatile Map<K, V> internalMap;

    public CopyOnWriteMap() {
        internalMap = new HashMap<K, V>();
    }

    public V put(K key, V value) {
        synchronized (this) {
            Map<K, V> newMap = new HashMap<K, V>(internalMap);
            V val = newMap.put(key, value);
            internalMap = newMap;
            return val;
        }
    }

    public V get(Object key) {
        return internalMap.get(key);
    }

    public void putAll(Map<? extends K, ? extends V> newData) {
        synchronized (this) {
            Map<K, V> newMap = new HashMap<K, V>(internalMap);
            newMap.putAll(newData);
            internalMap = newMap;
        }
    }
}
```

黑名单Demo如下：

```java
public class Solution {
    private static CopyOnWriteMap<String, Boolean> blackList = new CopyOnWriteMap<>();

    public static boolean isBlackList(String id) {
        return blackList.get(id) == null ? false : true;
    }

    public static void addBlackList(String id) {
        blackList.put(id, true);
    }
    
    public static void addBlackListAll(Map<String,Boolean> ids) {
        blackList.putAll(ids);
    }
}
```

### 3.1 优势

1. **保证多线程的并发读写的线程安全**。读写分离的思想**，**延时更新的策略是通过在写的时候针对不同的容器来实现的，放弃数据实时性达到数据的最终一致性。
2. **适用于“多度少写的场景”**。写时复制的思想来通过延时更新的策略来实现数据的最终一致性，并且能够保证读线程间不阻塞。

### 3.2 劣势

CopyOnWrite容器同时也存在两个问题：

1. 内存占用问题
2. 数据一致性问题

**内存占用问题**。

因为CopyOnWrite的写时复制机制，所以在进行写操作的时候，内存里会同时驻扎两个对象的内存，旧的对象和新写入的对象

> 注意:在复制的时候只是复制容器里的引用，只是在写的时候会创建新对象添加到新容器里，而旧容器的对象还在使用，所以有两份对象内存

如果这些对象占用的内存比较大，比 如说200M左右，那么再写入100M数据进去，内存就会占用300M，那么这个时候很有可能造成频繁的 **minor GC** 和 **major GC**。

**数据一致性问题**。

CopyOnWrite容器只能保证数据的**最终一致性**，不能保证数据的**实时一致性**。所以如果你希望写入的的数据，马上能读到，请不要使用CopyOnWrite容器，建议使用ConcurrentHashMap并发性和实时性更好。

## 4. COW vs 读写锁

### 读写锁特点

> 读锁共享，写锁独占

- **多个读者可以同时进行读**
- **写者必须互斥**（只允许一个写者写，也不能读者写者同时进行）
- **写者优先于读者**（一旦有写者，则后续读者必须等待，唤醒时优先考虑写者）
- **持有写锁可以继续持有读锁，持有读锁不能再持有写锁。** 如果一个线程已经持有了写锁，则可以**再持有读锁**。相反，如果一个线程已经持有了读锁，则在释放该读锁之前，不能再持有写锁。

如果解锁时有一个以上的线程阻塞，那么所有该锁上的线程都被编程就绪状态， 第一个变为就绪状态的线程又执行加锁操作，那么其他的线程又会进入等待。 在这种方式下，只有一个线程能够访问被互斥锁保护的资源

<br>

**线程进入读锁的前提条件：**

- 没有其他线程的写锁

- 没有写请求或者**有写请求，但调用线程和持有锁的线程是同一个**

**线程进入写锁的前提条件：**

- 没有其他线程的读锁

- 没有其他线程的写锁

读写锁有以下三个重要的特性：

1. 公平选择性：支持非公平（默认）和公平的锁获取方式，吞吐量还是非公平优于公平

2. 重进入：读锁和写锁都支持线程重进入

3. 锁降级：遵循获取写锁、获取读锁再释放写锁的次序，写锁能够降级成为读锁

<br>

**【小结】**

在线程持有读锁的情况下，该线程不能取得写锁。

> 因为获取写锁的时候，如果发现当前的读锁被占用，就马上获取失败，不管读锁是不是被当前线程持有

在线程持有写锁的情况下，该线程可以继续获取读锁

> 获取读锁时如果发现写锁被占用，只有写锁没有被当前线程占用的情况才会获取失败

- 当线程获取读锁时，可能有其他线程同时也在持有读锁，因此不能把获取读锁的线程“升级”为写锁；
- 而对于获得写锁的线程，它一定独占了读写锁，因此可以继续让它获取读锁，当它同时获取了写锁和读锁后，还可以先释放写锁继续持有读锁，这样一个写锁就“降级”为了读锁。

综上：

- 一个线程要想同时持有写锁和读锁，必须**先获取写锁再获取读锁**；

- 写锁可以“降级”为读锁；读锁不能“升级”为写锁

> **ReentrantReadWriteLock读写锁还是很复杂的，这里只做简单的结论性说明来对比COW**

--------------

相同点：

1. 两者都是通过读写分离的思想实现；
2. 读线程间是互不阻塞的

不同点：

其实就是一句话：<font color = red>**一种读写分离的思想，延时更新的策略通过在写时针对不同的容器来实现，放弃数据实时性达到数据的最终一致性**</font>

**对读线程而言**，为了实现数据实时性：

- 当写锁被获取后，读线程会等待
- 或者当读锁被获取后，写线程会等待，因为在读时不能写入，从而解决“**脏读**”等问题

也就是说如果使用读写锁依然会出现读线程阻塞等待的情况。

**而COW则完全放开了牺牲数据实时性而保证数据最终一致性，即读线程对数据的更新是延时感知的，因此读线程不会存在等待的情况。**

<br>

## 5. 为什么没有并发List

> 以下内容来自参考资料 [2].https://houbb.github.io/2019/01/18/jcip-07-copyonwritelist

问：JDK 5在java.util.concurrent里引入了ConcurrentHashMap，在需要支持高并发的场景，我们可以使用它代替HashMap。

但是为什么没有ArrayList的并发实现呢？

难道在多线程场景下我们只有Vector这一种线程安全的数组实现可以选择么？为什么在java.util.concurrent 没有一个类可以代替Vector呢？

【比较中肯的回答】

在java.util.concurrent包中没有加入并发的ArrayList实现的主要原因是：**很难去开发一个通用并且没有并发瓶颈的线程安全的List**。

像ConcurrentHashMap这样的类的真正价值（The real point/value of classes）并不是它们保证了线程安全。而在于它们在保证线程安全的同时不存在并发瓶颈。

举个例子，ConcurrentHashMap采用了锁分段技术和弱一致性的Map迭代器去规避并发瓶颈。

所以问题在于，像“Array List”这样的数据结构，你不知道如何去规避并发的瓶颈。拿contains() 这样一个操作来说，当你进行搜索的时候如何避免锁住整个list？

另一方面，Queue 和Deque (基于Linked List)有并发的实现是因为他们的接口相比List的接口有更多的限制，这些限制使得实现并发成为可能。

CopyOnWriteArrayList是一个有趣的例子，它规避了只读操作（如get/contains）并发的瓶颈，但是它为了做到这点，在修改操作中做了很多工作和修改可见性规则。

而ArrayList中很多操作很难避免锁整表，就如contains()、随机取get()等，进行查询搜索时都是要整张表操作的，那多线程时数据的实时一致性就只能通过锁来保证，这就限制了并发。

所以从理论上来说，CopyOnWriteArrayList并不算是一个通用的并发List。

----------------------

**🧐Q：** **CopyOnWriteArrayList 和 ArrayList 有什么区别？**

**🤓A：** CopyOnWriteArrayList 在读多写少的场景下可以提高效率，而 ArrayList 只是普通数组集合，并不适用于并发场景，而如果对 ArrayList 加锁，则会影响一部分性能。

同样对 CopyOnWriteArrayList 而言，仅能保证**最终一致性**。因为刚写入的数据，是写到的复制的数组中，此时并不能立即查询到。如果要保证实时性可以尝试使用 `Collections.synchronizedList` 或者加锁等方式。

--------------------

【参考资料】

[1]Java专栏.知道CopyOnWriteArrayList吗.公众号.https://urlify.cn/mInAvq

[2]老马啸西风.CopyOnWriteArrayList使用入门及源码详解.公众号.https://houbb.github.io/2019/01/18/jcip-07-copyonwritelist

[3]程序员小航.CopyOnWriteArrayList.公众号

[4]ThinkWon.并发容器之CopyOnWriteArrayList详解.CSDN.https://thinkwon.blog.csdn.net/article/details/102508258

[5]脚本之家.Java并发CopyOnWrite容器原理解析.https://www.jb51.net/article/178587.htm
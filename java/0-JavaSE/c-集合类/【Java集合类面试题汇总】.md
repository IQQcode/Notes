> Java类集面试题汇总

## Java集合类概述

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524205446.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525154022.png)

- **List(顺序好帮手)：** List接口存储顺序不唯一，可以有序的存储对象
- **Set(有序不重复):** 不允许重复的集合，不会有多个元素引用相同的对象。
- **Map(用key找value):** 使用键值对存储。Key唯一，Value可重复

Collection

- List：以特定顺序存储
- ArrayList、LinkList、Vector
- Set：不能包含重复的元素
- HashSet、TreeSet

Map

- HashMap
- HashTable
- TreeMap

----------------

Collection：Collection是一个父接口，List和Set是继承自他的子接口，Collection是最基本的集合接口，Java SDK中不提供直接继承自Collection的类，而是提供继承自他子接口的类，如List何Set。所用的Collection类都支持一个`Iterator()`方法来遍历。

List：List接口是有序的，会精确的将元素插入到指定的位置，和下面的Set接口不同，List接口允许有相同元素

- ArrayList：实现可变大小的数组，线程不安全

- LinkedList：允许null元素，通常在首部或者尾部操作，所以常被使用做堆栈(stack)、队列(queue)和双向队列(deque)

- Vector：类似于ArrayList，但Vector是同步的，Stack继承自Vector

Set：是一种不包含重复元素的Collection接口

- HashSet：不能有重复元素，底层是使用HashMap来实现的
- TreeSet： 不能有重复元素，对元素做排序（升序），底层是使用TreeMap来实现的

Map：此接口实现的Key到Value的映射，一个Map中不能包含相同的Key，每个Key只能映射一个Value

- HashTable：实现了一个Key-Value的哈希表，每一个非null元素都可作为Key或者Value，HashA

- Table是同步的

- HashMap：和HashTable的不同之处是，非同步的，且允许null元素的存在

--------------------

**List**

1. ArrayList 与 Vector区别；
2. ArrayList 与 LinkedList区别；
3. ArrayList是线程不安全的List集合；
4. 了解JUC包下的线程安全List(CopyWiterArrayList)

**Set**

1. Set集合与Map集合的关系
2. hashCode，equals方法关系
3. Comparable，Compartor接口的关系

**Map**

1. 请对比HashMap，hashtable关系
2. 是否了解ConcurrentHashMap以及实现原理

------------------------

## List问题汇总

### 1. ArrayList和LinkedList的区别

1. **线程安全：** ArrayList和LinkedList都是不同步的，不保证线程安全；
2. **底层实现：** ArrayList底层是用Object动态数组实现的，LinkedList是用双向链表实现的
3. **扩容问题：** ArrayList默认长度是10，使用1.5倍数组拷贝扩容；LinkedList链表实现，不存在扩容问题
4. **插入删除：** ArrayList采用数组存储，所以插入和删除元素的时间复杂度受元素位置的影响。指定位置插入需要将后面的元素挪后，删除时要往前覆盖，插入删除效率低下；LinkedList删除元素时间复杂度不受元素位置的影响，更换节点指向即可，插入删除效率高
5. **查询访问：** ArrayList是数组实现，支持任意位置元素访问，查询高效；LinkedList是链表实现，查询需要重头遍历链表，查询低下
6. **内存空间占用：** ArrayList的空间浪费主要体现在在list列表的结尾会预留一定的容量空间，而LinkedList的空间花费则体现在它的每一个元素都需要消耗比ArrayList更多的空间（因为要存放直接后继和直接前驱以及数据）

### 2. ArrayList和Vector的区别

**【相同点】**

- 底层都使用数组实现
- 功能相同，实现增删改查等操作的方法相似
- 长度可变的数组结构

**【不同点】**

- Vector是早期JDK1.0 版本提供，ArrayList是JDK1.2 新版本替代Vector的
- Vector 的方法都是同步的，线程安全；ArrayList非线程安全，异步操作，但性能比Vector好
- 默认初始化容量都是10，Vector 扩容默认会翻倍，可指定扩容的大小；ArrayList默认大小是10，1.5倍扩容机制

### 3. ArrayList扩容机制

--------------------------

## Set问题汇总

### 1. HashSet如何检查重复

> HashSet不允许插入重复元素，会对插入的元素进行排序

- hash值相同，调用equals比较
   - equals比较相同，元素重复，不能插入
   - equals比较不同，元素不存在，可以插入
- hash值不同，元素不存在，可以插入

### 2. Set集合与Map集合的关系

HashSet的底层是基于HashMap实现的，TreeSet的底层是基于TreeMap实现的，Set集合的元素是Map集合中的`value`。

- Set集合中存放的数据不允许重复
- Map集合的数据是`key-value`的形式

### 3. hashCode，equals方法关系

- `hashCode`相同，则`equals`不一定相同，会存在哈希冲突
- `equals`相同，`hashCode`则一定相同
- equals方法被覆写过，则hashCode方法也必须被覆写

### 4. TreeSet怎么实现的？TreeMap用的什么

TreeSet基于TreeMap实现，TreeMap基于红黑树实现。TreeSet内部维持了—个简化版的TreeMap，存放的元素就是TreeMap中的`key`，会对元素排序且不允许重复。

------------------------

## Map问题汇总

### 1. HashMap 和 Hashtable的区别

1. **线程安全：** HashMap是线程不安全的，Hashtable是线程安全的。Hashtable的方法都是同步的`synchronized`修饰（不建议使用，用ConcurrentHashMap替代）
2. **效率：** 因为线程安全的问题，HashMap 要比 HashTable 效率高。Hashtable基本被淘汰（ConcurrentHashMap替代），不要在代码中使用它；
3. **null-key，null-value：** HashMap允许存放null-`key`，null-`value`（null-`key`只允许存放一次）；Hashtable中put进的键值只要有一个 null，直接抛出 NullPointerException
4. **初始容量和扩容 ：** ①Hashtable 默认的初始大小为11，之后每次扩充，容量变为原来的2n+1；HashMap 默认的初始化大小为16。之后每次扩充，容量变为原来的2倍（HashMap 总是使用2的幂作为哈希表的大小）
5. **底层数据结构：** JDK1.8 以后的 HashMap 在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为8）时，将链表转化为红黑树，以减少搜索时间。Hashtable 没有这样的机制。

### 2. HashMap 和 HashSet区别

HashSet 底层就是基于 HashMap 实现的。

【HashSet源码】

```java
private transient HashMap<E,Object> map;

// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();

/**
 * Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
 * default initial capacity (16) and load factor (0.75).
 */
public HashSet() {
    map = new HashMap<>();
}
```

我们可以看到，在初始化map时，其实就是使用了HashMap

| HashMap                   | HashSet                                                               |
| ------------------------- | --------------------------------------------------------------------- |
| 实现了Map接口                  | 实现Set接口                                                               |
| 存储键值对                     | 仅存储对象                                                                 |
| 调用 `put()`向map中添加元素       | 调用 `add()`方法向Set中添加元素                                                 |
| HashMap使用键（Key）计算hashCode | HashSet使用成员对象来计算hashCode值，对于两个对象来说hashCode可能相同，所以equals()方法用来判断对象的相等性 |

### 3. HashMap的底层实现

> TreeMap、TreeSet以及JDK1.8之后的HashMap底层都用到了红黑树。红黑树就是为了解决二叉查找树的缺陷，因为二叉查找树在某些情况下会退化成一个线性结构。

HashMap底层的实现采用了哈希表，哈希表的实现：

- JDK 1.8之前：数组 + 单向链表
- JDK 1.8之后：数组 + 单向链表 / 红黑树（链表的长度超过8）

`Node<K,V>[] table`就是HashMap核心的数据结构，也称之为“位桶数组”。

HashMap集合是一个无序的集合，不保证映射的顺序，存储元素和取出元素的顺序有可能不一致。

### 4. ConcurrentHashMap的底层实现

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200601152340.jpeg)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200601152410.jpeg)

ConcurrentHashMap将数据分为一段一段的存储，然后给每一段数据配一把锁，当一个线程占用锁访问其中一个段数据时，其他段的数据也能被其他线程访问。

### 5. 说说HashMap的扩容机制？是什么时候扩容，扩容干了什么？

HashMap的位桶数组，初始大小为16。实际使用时，显然大小是可变的。如果位桶数组中的元素达到`0.75 * 数组length`，就重新调整数组大小变为原来的2倍大小。

HashMap 总是使用2的幂作为哈希表的大小，`tableSize`方法保证了 HashMap 总是使用2的幂作为哈希表的大小：

```java
    /**
     * Returns a power of two size for the given target capacity.
     */
    static final int tableSizeFor(int cap) {
        int n = cap - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }
```

如果我们传入的大小不是2的幂次方，那么通过`tableSize`方法会使我们传入的数变为最捷径2的幂次方的数

> 比如传入的是3，那么就变成4；
> 
> 传入的是5，就变成8；

`int n = cap - 1; `处理传入的数本身就是2的幂次方，在通过运算之后保持不变。

如果不`cap - 1`，比如传入的是2，再移位或+1之后变为了4，而2本身就是2的幂次方，不需要做处理。`-1`保证了移位或+1之后不变。

**扩容很耗时，扩容的本质是定义新的更大的数组，并将原数组内容拷贝到新数组中。**

### 6. ConcurrentHashMap 和 Hashtable 的区别

### 7. 说说常见的hash算法,解决hash冲突的方式有哪些

目前流行的 Hash 算法包括 MD5、SHA-1 和 SHA-2

> [**Hash算法总结**](https://blog.csdn.net/qq_32534441/article/details/89669106)

解决hash冲突的方式有哪些

- 拉链法
- 开放地址法
- 再散列法

> [**解决哈希冲突的三种方法（拉链法、开放地址法、再散列法）**](https://blog.csdn.net/qq_32595453/article/details/80660676)

### List、Map、Set 三个接口，存取元素时，各有什么特点

- List 以索引来存取元素，元素可重复
- Set 不能存放重复元素
- Map 保存键值对映射，映射关系可以一对一、多对一
- List 有基于数组和链表实现两种方式
- Set、Map 容器有基于哈希存储和红黑树两种方式实现
- Set 基于 Map 实现，Set 里的元素值就是 Map 里 key

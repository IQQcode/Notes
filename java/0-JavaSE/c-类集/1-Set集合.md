## 1. Set接口

<img title="" src="https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524205446.png" alt="" data-align="inline">

**【特点】**

1. 不允许存储重复元素

2. 无索引，迭代器遍历

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531222523.png)

HashSet的底层原理，就是简化的HashMap。插入的数据就是放到了HashMap的`key`上，因为hashMap的`key`不允许重复。

### Set集合保证元素不重复

**Set集合存储元素不重复的前提：存储的元素必须重写 hashCode方法和equals方法**

Set集合在调用`add()`的时候，`add()`会自动调用`hashCode()`和`equals()`来判断待插入的元素是否重复

- hash值相同，调用equals比较
  
   - equals比较相同，元素重复，不能插入
    
   - equals比较不同，元素不存在，可以插入

- hash值不同，元素不存在，可以插入

【实例说明】

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524231513.png)

> [a, 重地, 通话]

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524234758.png)

1. `set.add(s1)` ：add法会调用s1的 hashCode方法计算字符串"a"的哈希值（哈希值是97），在集合中找有没有97这个哈希值的元素，就会把s1存储到集合中

2. `set.add(s2)` ： add方法会调用s2的 hashCode方法计算字符串"a"的哈希值（哈希值是97），在集合中发现有哈希值为97的元素，此时产生了**哈希冲突**。s2会调用 equals方法和哈希值相同的元素进行比较`s2.equals(s1)`，返回true，两个元素的哈希值相同 且equals方法返回true。认定两个元素相同，就不会把s2存储到集合中

3. `set.add("重地")`：add方法会调用"重地"的 hashCode方法计算字符串"重地"的哈希值（哈希值是1179395），在集合中找有没有1179395这个哈希值的元素，把"重地"存到集合中

4. `set.add("通话")`：add方法会调用"通话"的 hashCode方法计算字符串"通话"的哈希值（哈希值是1179395），发现有哈希冲突。"通话"会调用 equals方法和哈希值相同的元素进行比较，`"通话".equals("重地")`，返回 false。两个元素的哈希值相同，equa不同，认定两个元素不同，最终把通话"存储到集合中。

## 2. HashSet

**【HashSet特点】**

1. 不允许存储重复元素

2. 没有索引，得用迭代器遍历

3. 是一个无序的集合，存储元素和取出元素顺序可能不一致

4. 底层是一个哈希表结构（查询速度快）

**哈希值：** 是一个十进制的整数，由系统随机给出（模拟出来的对象的逻辑地址）

**hashCode()：** Object类中的方法（任何对象都能调用），返回该对象的哈希码值

`public native int hashCode()`：本地方法，调用的是操作系统的方法

**哈希表：** HashSet集合存储数据的结构（哈希表）

将元素按照Hash值进行分组，相同Hash值的元素放到一起，提高查询的效率

- JDK 1.8之前是 哈希表 = 数组 + 链表

- JDK 1.8之后是 哈希表 = 数组 + 链表 / 红黑树

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524222943.png)

## 3. LinkedHashSet

HashSet是一个无序的集合，但是LinkedHashSet是有序的集合，它继承自HashSet

LinkedHashset集合特点：  

- 底层是一个哈希表（数组+链表/红黑树）+ 链表

- 多一条链表（记录元素的存储顺序）保证元素有序

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525000318.png)

## 4. TreeSet

TreeSet底层实际是用TreeMap实现的，内部维持了—个简化版的TreeMap，通过key来存储Set的元素。

TreeSet内部需要对存储的元素进行排序。因此，我们对应的类需要实现Comparable接口，这样，才能根据compareTo方法比较对象之间的大小，才能进行内部排序。

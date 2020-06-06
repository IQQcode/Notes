## 1. Map集概述

**Map集合的特点：**

1. Map集合是一个双列集合，一个元素包含两个值（`key`和`value`）

2. `key`和`value`的数据类型，可以相同，也可以不同

3. `key`是不允许重复的（唯一性），`value`可以重复

4. `key`和`value`一一对应，一个key只能对应一个value

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525154022.png)

【Map集合常用方法】

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525084656.png)

## 2. HashMap

HashMap底层的实现采用了哈希表，哈希表的实现：

- JDK 1.8之前：数组 + 单向链表

- JDK 1.8之后：数组 + 单向链表 / 红黑树（链表的长度超过8）

`Node<K,V>[] table`就是HashMap核心的数据结构，也称之为“位桶数组”。

HashMap集合是一个无序的集合，不保证映射的顺序，存储元素和取出元素的顺序有可能不一致。

### HashMap原理探究

HashMap内部节点

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531090151.png)

一个节点类存储了：

- `hasn`：键对象的哈希值

- `key`：键

- `value`：值

- `next`：下一个节点的位置

每一个Node对象就是就是一个单链表结构

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531091255.png)

然后，我们映射出`Node<K,V>[]`数组的结构（HashMap的结构）：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531093153.png)

其实就是在数组中存放一个链表。那数组中是怎么存放的链表呢？`hash`又怎么计算呢？

怎么能通过`key`来找到对应的`value`呢？

我们接着来探讨。

#### 存储数据的过程

我们的目的是将`key-value`两个对象**成对**存放到 HashMap的Node数组中。**核心就是产生hash值，该值用来对应数组的存储位置**

```java
put(1,"test");
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531101145.png)

**第一步：获取Key对象的hashCode**

调用key对象的`hashCode`方法，获得哈希码

> hashCode是Object类中的对象，所以任何类对象都可以调用

**第二步：计算hsah值**

根据hashCode计算出`hash`值（要求在 [0 ， 数组长度-1] 之间）

hashCode是一个整数，我们需要将它转化成 [0 ， 数组长度-1] 的范围。我们要求转化后的hash值尽量均匀地分布在 [0 ， 数组长度-1] 这个区间，减少**hash冲突**

> hash(哈希)冲突：不同的hashCode转换为hash值时计算出的结果相同

**【hash值的计算】**

I. 极端情况

```java
hash =  hashCode / hashCode;
```

hash值总是1。意味着，键值对对象都会存储到数组索引`1`位置，这样就形成一个非常长的链表。相当于每存储一个对象都会发生“hash冲突”， HashMap也退化成了一个“链表”。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531114308.png)

hash值都不相同，退化为长度为N的数组。此时hash成为了数组下标

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531114706.png)

**所以，我们必须采用折中的算法，让数组的容量不能太大，让链表的长度不能太长。让存储在哈希表中的数据尽量散开均匀分布，提高查询速度。**

—种简单和常用的算法是**相除取余算法**

```java
hash值 = hashCode % 数组长度;
```

这种算法可以让hash值均匀的分布在 [0 ， 数组长度-1] 的区间。早期的Hashtable就是采用这种算法。但是，这种算法由于使用了“除法″，效率低下。

JDK后来改进了算法。首先约定数组长度必须为2的整数幂，这样采用位运算可实现取余的效果：

```java
hash值 = hashCode &(数组长度 - 1);
```

**第三步：生成Node对象**

一个Node对象包含4部分：key对象、 value对象、hash值、指向下一个Node对象的引用。

我们现在算出了hash值，下一个 Entry对象的引用为null

**第四步：将Node对象放到table数组中**

- 如果本Node对象对应的数组索引位置还没有放Node对象，则直接将Node对象存储进数组；

- 如果对应索引位置已经有Node对象，则将已有Node对象的next指向本Node对象，形成链表

**总结：**

当添加一个元素`key-value`时，首先计算`key`的hash值，以此确定插入数组中的位置。但是可能存在同hash值的元素已经被放在数组同一位置了，这时就添加到同一hash值的元素的后面，他们在数组的同一位置，就形成了链表。

同一个链表上的hash值是相同的，所以说数组存放的是链表。

JDK8及之后，当链表长度大于8时，链表就转换为红黑树，这样又大大提高了查找的效率

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200524222943.png)

-----------------------

#### 取出数据的过程

```java
get(1); //test
```

我们需要通过key对象获得“键值对”对象，进而返回value对象。明白了存储数据过程，取数据就比较简单了，参见以下步骤：

**第一步：获取Key对象的hashCode**

同存储数据一样，获取数据也要先计算hash值。获得key的hashcode，通过Hash散列算法得到hash值，进而定位到数组的位置

**第二步：遍历链表/红黑树**

遍历相同hash的链表，在链表上挨个比较Key对象。调用`equals`方法，将Key对象和链表上所有节点的Key对象进行比较，直到碰到返回true的节点对象为止。

- 先计算hash值定位到存储数据的链表

- 遍历链表，通过`equaks`来确定Key对象，查找到链表上对应的节点

- 返回该节点的`Value`值

**【hashCode和equals方法的关系】**

- equals相同，hashCode一定相同，hash值一定相同；（在同一个链表上）

- hashCode相同，equals不一定相同；（hash冲突）

**总结**

不管是存储数据还是取出数据，都必须先计算hash值，根据哈希值来确定数据在Node[]数组上存放/取出的位置

#### 扩容问题

HashMap的位桶数组，初始大小为16。实际使用时，显然大小是可变的。如果位桶数组中的元素达到`0.75 * 数组length`，就重新调整数组大小变为原来的2倍大小。

- 16为初始容量
- 0.75为加载因子

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

扩容很耗时，扩容的本质是定义新的更大的数组，并将原数组内容拷贝到新数组中。

--------------------------------------------

### LinkedHashMap

继承自HashMap，底层采用数组 + 链表/红黑树 + 链表实现，一个链表记录元素的顺序。所以同LinkedHashSet类似，LinkedHashMap的迭代顺序是有序的。

## 3. TreeMap

TreeMap底层是红黑树，能够实现该Map集合有序。

在源码中root用来存储整个树的根节点，Entry是TreeMap的节点类：

```java
private transient Entry<K,V> root;
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531141957.png)

可以看到里面存储了本身数据、左节点、右节点、父节点、以及节点颜色。TreeMap的put / remove方法大量使用了红黑树的理论。

TreeMap和HashMap实现了同样的接口Map，因此，用法对于调用者来说没有区别

- HashMap效率高于TreeMap

- 在需要排序的Map时才选用 TreeMap

#### TreeMap元素的排序

TreeMap有序是通过Comparator来进行比较的

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531143132.png)

> key: 202001   value: 张三
> key: 202007   value: 王五
> key: 202020   value: 李四
> key: 202133   value: 赵六

在自定义类对象进行比较时，要重新覆写`compareTo`方法

```java
class Person implements Comparable<Person>{
    int id;
    String name;
    int age;

    public Person(int id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }

    @Override
    public int compareTo(Person o) {
        if (this.age > o.age) {
            return 1;
        }else if (this.age < o.age) {
            return -1;
        }else {
            //年龄相同按照id比较
            if (this.id > o.id) {
                return 1;
            }else if (this.id < o.id) {
                return -1;
            }else {
                return 0;
            }
        }
    }
}
public class ObjCompare {
    public static void main(String[] args) {
        Map<Person,String> treemap = new TreeMap<>();
        treemap.put(new Person(1001,"张三",18),"2020-01");
        treemap.put(new Person(1002,"李四",20),"2020-02");
        treemap.put(new Person(1003,"王五",18),"2020-03");
        for (Person per : treemap.keySet()) {
            String value = treemap.get(per);
            System.out.println("key: " + per + "   value: " + value);
        }
    }
}
```

> key: Person{id=1001, name='张三', age=18}   value: 2020-01
> key: Person{id=1003, name='王五', age=18}   value: 2020-03
> key: Person{id=1002, name='李四', age=20}   value: 2020-02

## 4. Hashtable

`java.util.Hashtable<K,V>`集合实现了接口

- Hashtable：底层也是一个哈希表，是一个**线程安全**的集合，是单线程集合，速度慢

- HashMap：底层是一个哈希表，是一个**线程不安全**的集合，是多线程的集合，速度快

- HashMap集合：可以存储null`key`（只允许有一个），可以存储null`value`

- Hashtable集合，不能存储null`key`，不能存储null`value`

- hash的计算方式不同。HashMap计算了hash值；Hashtable使用了key的hashCode方法。

- 默认初始大小和扩容方式不同。HashMap默认初始大小16，容量必须是2的整数次幂，扩容时将容量变为原来的2倍；Hashtable默认初始大小11，扩容时将容量变为原来的2倍加1。

> Hashtable和 Vector集合一样，在jdk1.2版本之后被更先进的集合（ HashMap， ArrayList）取代了。Hashtable的子类 Properties使用频繁，Properties集合是一个唯一和IO流相结合的集合 

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525112147.png)

## 5. Map集合的遍历

**【方式一】通过map.keySet()获取key，通过key找到value**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525110552.png)

**【方式二】通过Map.Entry(String,String)获取，然后使用entry.getKey()获取到键，通过entry.getValue()获取到值**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525111456.png)

**【方式三】先放入Set集合中，Iterator遍历获取**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525111943.png)

**【方式四】只遍历键或者值，通过加强for循环**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525112035.png)

----------------------------------------------------------------------------------

**计算一个字符串中每个字符出现次数**

解题思路：

1. 使用 Scanner获取用户输入的字符串  

2. 创建Map集合，key是字符串中的字符， value是字符的个数  

3. 遍历字符串获取每一个字符  

4. 使用获取到的字符，去Map集合判断key是否存在  
   
    - key存在：  
      
       - 通过字符（key），获取vaue（字符个数）  
       
       - value++  
       
       - put（key, value）把新的 value存储到Map集合中  
      
    - key不存在：  
      
       - put（key, 1）  

5. 遍历Map集合，输出结果

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525114532.png)



## 6. 表格数据存储

> 使用容器来存储表格数据

### 使用List和Map

| ID   | 姓名  | 年龄  | 毕业日期    |
| ---- | --- | --- | ------- |
| 1001 | 张三  | 18  | 2020-09 |
| 1002 | 李四  | 20  | 2021-07 |
| 1003 | 王五  | 22  | 2017-07 |

- 每一行使用一个Map

- 整个表格使用List

```java
public class ListMapTable {
    public static void main(String[] args) {
        Map<String,Object> map1 = new HashMap<>();
        map1.put("ID",1001);
        map1.put("姓名","张三");
        map1.put("年龄",18);
        map1.put("毕业日期","2020-09");

        Map<String,Object> map2 = new HashMap<>();
        map2.put("ID",1002);
        map2.put("姓名","李四");
        map2.put("年龄",20);
        map2.put("毕业日期","2021-07");

        Map<String,Object> map3 = new HashMap<>();
        map3.put("ID",1003);
        map3.put("姓名","王五");
        map3.put("年龄",22);
        map3.put("毕业日期","2017-07");

        List<Map<String,Object>> table = new ArrayList<> ();
        table.add(map1);
        table.add(map2);
        table.add(map3);

        for (Map<String, Object> row : table) {
            //将每行的内容放入到Set中
            Set <String> keyset= row.keySet();
            for (String key : keyset) {
                System.out.print(key+": " + row.get(key) + "\t");
            }
            System.out.println();
        }
    }
}

```

> 姓名: 张三    毕业日期: 2020-09    ID: 1001    年龄: 18    
> 姓名: 李四    毕业日期: 2021-07    ID: 1002    年龄: 20    
> 姓名: 王五    毕业日期: 2017-07    ID: 1003    年龄: 22    

如果想要列的信息和上面表格的顺序一致，可以使用`LinkedHashMap`来保证有序



### JavaBean对象

对JavaBean不太了解的伙伴先了解一下

👉[JavaBean、Spring Bean对象的理解](https://blog.csdn.net/weixin_43232955/article/details/105755021)

- 每一行使用JavaBean对象

- 整张表格使用Map/List

```java
public static void main(String[] args) {
    Student stu1 = new Student(1001,"张三",18,"2020-09");
    Student stu2 = new Student(1002,"李四",20,"2021-07");
    Student stu3 = new Student(1003,"王五",22,"2017-07");
    List<Student> list = new ArrayList<> ();
    list.add(stu1);
    list.add(stu2);
    list.add(stu3);
    for (Student stu : list) {
        System.out.println(stu);
    }
    System.out.println("\n" +"-----------------------------" + "\n");
    Map<Integer,Student> map = new HashMap<> ();
    map.put(1001,stu1);
    map.put(1002,stu2);
    map.put(1003,stu3);
    Set<Integer> keys = map.keySet();
    for (Integer key : keys) {
        System.out.println(map.get(key));
    }
}
```

> Student{id=1001,  name='张三',  age=18,  graduation=2020-09}
> Student{id=1002,  name='李四',  age=20,  graduation=2021-07}
> Student{id=1003,  name='王五',  age=22,  graduation=2017-07}

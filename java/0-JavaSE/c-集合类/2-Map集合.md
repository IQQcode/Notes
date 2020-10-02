## 1. Map集概述

**Map集合的特点：**

1. Map集合是一个双列集合，一个元素包含两个值（`key`和`value`）
2. `key`和`value`的数据类型，可以相同，也可以不同
3. `key`是不允许重复的（唯一性），`value`可以重复
4. `key`和`value`一一对应，一个key只能对应一个value
5. 一个`key-value`构成一个Entry对象，Entry无序不可重复，Set存储所有Entry

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525154022.png)

【Map集合常用方法】

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525084656.png)

--------------------------------------------

## 3. LinkedHashMap

**此类适用于频繁的遍历数据**

- 继承自HashMap，底层采用数组 + 链表/红黑树 + 双链表实现，顺序链表记录元素的顺序。

- 所以同LinkedHashSet类似，LinkedHashMap的迭代顺序是有序的。

## 4. TreeMap

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

TreeMap有序是通过Comparator来对`key`进行比较的

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200531143132.png)

```java
key: 202001   value: 张三
key: 202007   value: 王五
key: 202020   value: 李四
key: 202133   value: 赵六
```

### Comparable和Comparator接口的区别：

- Comparable相当于“内部比较器”，而Comparator相当于“外部比较器”；

- Comparable接口位于 java.lang包下，Comparator接口位于java.util包下；

- Comparable：内部比较器，一个类如果想要使用`Collections.sort(list) `方法进行排序，则需要实现该接口
- Comparator：外部比较器，用于对那些没有实现Comparable接口或者对已经实现的Comparable中的排序规则不满意，需要再次进行排序，无需改变类的结构，更加灵活

--------------------

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

```java
key: Person{id=1001, name='张三', age=18}   value: 2020-01
key: Person{id=1003, name='王五', age=18}   value: 2020-03
key: Person{id=1002, name='李四', age=20}   value: 2020-02
```



## 5. Hashtable

`java.util.Hashtable<K,V>`集合实现了接口

- Hashtable：底层也是一个哈希表，是一个**线程安全**的集合，是单线程集合，速度慢

- HashMap：底层是一个哈希表，是一个**线程不安全**的集合，是多线程的集合，速度快

- HashMap集合：可以存储null`key`（只允许有一个），可以存储null`value`

- Hashtable集合，不能存储null`key`，不能存储null`value`

- hash的计算方式不同。HashMap计算了hash值；Hashtable使用了key的hashCode方法。

- 默认初始大小和扩容方式不同。HashMap默认初始大小16，容量必须是2的整数次幂，扩容时将容量变为原来的2倍；Hashtable默认初始大小11，扩容时将容量变为原来的2倍加1。

> Hashtable和 Vector集合一样，在jdk1.2版本之后被更先进的集合（ HashMap， ArrayList）取代了。Hashtable的子类 Properties使用频繁，Properties集合是一个唯一和 IO流 相结合的集合 

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200525112147.png)

<br>

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
>
> 姓名: 李四    毕业日期: 2021-07    ID: 1002    年龄: 20    
>
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

```java
Student{id=1001,  name='张三',  age=18,  graduation=2020-09}

Student{id=1002,  name='李四',  age=20,  graduation=2021-07}

Student{id=1003,  name='王五',  age=22,  graduation=2017-07}
```

## 7. 是否可以存储null

|   结构    | null |
| :-------: | :--: |
|  HashSet  |  ✔   |
|  TreeSet  |  ❌   |
|  HashMap  |  ✔   |
|  TreeMap  |  ❌   |
| Hashtable |  ❌   |


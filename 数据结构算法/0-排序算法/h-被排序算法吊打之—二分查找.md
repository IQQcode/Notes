![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200520084507.png)

### 1. 二分查找思想

猜数字的游戏大家都玩过吧？我说一个0~100之间的数字，你来猜。猜对了，也没有奖励。

那你会怎么猜？从0~100逐个猜？显然这样是不行的。我们都会先说50，大了再猜25，小了再猜75，然后再折半的缩小区间，最终猜出数字。

上面的这种思想，就是二分查找的思想。我们归纳出他的要点：

- 待查找的数是有序的

- 每次折半来缩小区间查找

### 2. 二分查找详解

比如我们在已知的有序序列中查找数字`7`，那么经过以下折半，则三次即可查找完成。

<img title="" src="https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200520092641.png" alt="" data-align="inline">

### 3. 代码实现

**I. 基础二分排序**

- 范围在`[L,R]`闭区间中，`low = 0`、`right = arr.length - 1`；

- 注意循环条件为 `low < right` ，而不是`low <= right`；

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200520095602.png)

**II. 查找第一个等于key的下标**

例如：arr[1，2，2，4，5，6，7，8]

- 查找2，返回第一个2的下标`index = 1`

- 查找4，返回5的下标`index = 4`

- 查找5，返回6的下标`index = 5`



### 4. 复杂度分析

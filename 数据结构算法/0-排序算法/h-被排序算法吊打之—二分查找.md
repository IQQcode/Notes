![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200520084507.png)

## 1. 二分查找思想

猜数字的游戏大家都玩过吧？我说一个0~100之间的数字，你来猜。猜对了，也没有奖励。

那你会怎么猜？从0~100逐个猜？显然这样是不行的。我们都会先说50，大了再猜25，小了再猜75，然后再折半的缩小区间，最终猜出数字。

上面的这种思想，就是二分查找的思想。我们归纳出他的要点：

- 待查找的数是有序的

- 每次折半来缩小区间查找

比如我们在已知的有序序列中查找数字`7`，那么经过以下折半，则三次即可查找完成。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200520092641.png)

二分查找并不简单，Knuth 大佬（发明 KMP 算法的那位）都说二分查找：**思路很简单，细节是魔鬼**。很多人喜欢拿整型溢出的 bug 说事儿，但是二分查找真正的坑根本不是那个细节问题，而是在于到底要给 `mid` 加一还是减一，while 里到底用 `<=` 还是 `<`

你要是没有正确理解这些细节，写二分肯定就是玄学编程，基本就是一看就会，一写就废；感觉良好，bug难找！有没有 bug 只能靠菩萨保佑。

### 二分查找算法简介

> 图片内容来自[liweiwei1419](https://leetcode-cn.com/u/liweiwei1419)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722081932.png)

----------------------------

## 2. 二分查找详解

> 🔈~~ **【声明】**：这里并非只有减治才能用`<`，常规的写法也可以用`<`。这两种边界两种不同的写法均可使用，只是边界条件不同而已

这个场景是最简单的，肯能也是大家最熟悉的，即搜索一个数，如果存在，返回其索引，否则返回 -1。

```java
public int binarySearch(int[] nums, int target) {
    int left = 0; 
    int right = nums.length - 1; // 注意

    while(left <= right) {  //注意
        int mid = (left + right) >>> 1;
        if(nums[mid] == target)
            return mid; 
        else if (nums[mid] < target)
            left = mid + 1; // 注意
        else if (nums[mid] > target)
            right = mid - 1; // 注意
    }
    return -1;
}
```

JDK8源码的二分查找：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722091003.png)

### while循环的条件

**1、为什么 while 循环的条件中是 <=，而不是 <**

答：因为初始化 `right` 的赋值是 `nums.length - 1`，即最后一个元素的索引，而不是 `nums.length`。

这二者可能出现在不同功能的二分查找中，区别是：前者相当于两端都闭区间 `[left, right]`，后者相当于左闭右开区间 `[left, right)`，因为索引大小为 `nums.length` 是越界的。

文中所有的算法都是基于前者 `[left, right]` 两端都闭的区间。**这个区间其实就是每次进行搜索的区间**。

**2、 <=，和 < 结束的临界值是什么**

- **`<=`：right == left - 1**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722085830.png)

**`<=`：right == left**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722090616.png)

-----------------------

### 停止搜索的临界条件

什么时候应该停止搜索呢？当然，找到了目标值的时候可以终止：

```java
    if(nums[mid] == target)
        return mid;
```

但如果没找到，就需要 while 循环终止，然后返回 -1。那 while 循环什么时候应该终止？**搜索区间为空的时候应该终止**，意味着你没得找了，就等于没找到嘛。

`while(left <= right)` 的终止条件是 `left == right + 1`，写成区间的形式就是 `[right + 1, right]`，或者带个具体的数字进去 `[3, 2]`，可见**这时候区间为空**，因为没有数字既大于等于 3 又小于等于 2 的吧，这个集合为空集。所以这时候 while 循环终止是正确的，直接返回 -1 即可。

`while(left < right)` 的终止条件是 `left == right`，写成区间的形式就是 `[left, right]`，或者带个具体的数字进去 `[2, 2]`，**这时候区间非空**，<font color = red>还有一个数 2</font>，但此时 while 循环终止了。也就是说这区间 `[2, 2]` 被漏掉了，索引 2 没有被搜索，如果这时候直接返回 -1 就是错误的。

当然，如果你非要用 `while(left < right)` 也可以，我们已经知道了出错的原因，就打个补丁好了：

```java
    //...
    while(left < right) {
        // ...
    }
    return nums[left] == target ? left : -1;
```

------------------------------------------------

### 中间值mid

关于取中间数 `int mid = (left + right) / 2`; `在 left + right` 很大的时候会发生整形溢出，一般这样改写：

```java
int mid = left + (right - left) / 2;
```

这两种写法事实上没有太大的区别，在 left 和 right 都表示数组下标的时候，几乎不会越界，因为绝大多数情况下不会开那么长的数组。

在 Java 中还可以这样写

```java
int mid = (left + right) >>> 1;
```

> 表示无符号右移，它表示在 left + right 发生整型溢出的时候，高位补 0，结果依然正确。这一点是从 JDK 的源码中 Arrays.binarySearch() 方法借鉴来的。

在 Python 中不用这样改写，Python 在 `left + right` 发生整型溢出的时候会自动转成长整形。

**这里不建议把 `/ 2` 改写成 `>> 1`，理由是高级语言在编译期间会做优化，会将 `/ 2`，以及除以2 的方幂的操作，在内部修改为 `>>`**，只需要写程序本来的逻辑就好了。

如果使用位运算，在 C++ 中可能还需要注意运算优先级的问题。

**为什么取二分之一？三分之一、五分之四可不可以？**

结合二分查找的思路并不难理解，其实只要在数组中间任意找一个位置的元素，如果恰好是目标元素，则直接返回。如果不是根据这个元素的值和目标元素的大小关系，进而在当前位置的左侧还是右侧继续查找。

还有一个细节，**`/ 2` 表示的是下取整**，当数组中的元素个数为偶数的时候，`int mid = left + (right - left) / 2`; 只能取到位于左边的那个元素。

取右边中间数的表达式是（其实就是在括号里 + 1，表示上取整）：

`int mid = left + (right - left + 1) / 2;`

--------------------

### 二分的区间划分

**为什么 `left = mid + 1`，`right = mid - 1`？我看有的代码是 `right = mid` 或者 `left = mid`，没有这些加1减1，到底怎么回事，怎么判断**？

答：这也是二分查找的一个难点，不过只要你能理解前面的内容，就能够很容易判断。

刚才明确了「搜索区间」这个概念，而且本算法的搜索区间是两端都闭的，即 `[left, right]`。那么当我们发现索引 `mid` 不是要找的 `target` 时，下一步应该去搜索哪里呢？

当然是去搜索 `[left, mid-1]` 或者 `[mid+1, right]` 对不对？**因为** **`mid`** **已经搜索过，应该从搜索区间中去除**。

`left = mid + 1`，`right = mid - 1`我们是将区间划分成了三个部分

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722115242.png)

`left = mid `或者`right = mid`我们划分了两个区间

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722115743.png)

---------------------------------------------

### 算法的缺陷

**此算法有什么缺陷**？

答：至此，你应该已经掌握了该算法的所有细节，以及这样处理的原因。但是，这个算法存在局限性。

比如说给你有序数组 `nums = [1,2,2,2,3]`，`target` 为 2，此算法返回的索引是 2，没错。但是如果我想得到 `target` 的左侧边界，即索引 1，或者我想得到 `target` 的右侧边界，即索引 3，这样的话此算法是无法处理的。

这样的需求很常见，**你也许会说，找到一个 target，然后向左或向右线性搜索不行吗？可以，但是不好，因为这样难以保证二分查找对数级的复杂度了**。

我们后续的算法就来讨论这两种二分查找算法的拓展。

---------------------------------------------

## 3. 代码模板

### 基础二分查找

**基础二分排序 [left <= right]**

- 范围在`[left, right]`闭区间中，`left = 0`、`right = arr.length - 1`；

- 注意循环条件为 `left <= right`

```java
public int binarySearch(int[] nums, int target) {

    int left = 0;
    int right = nums.length - 1;

    while (left <= right) {
        int mid = (left + right) >>> 1;
        if (target == nums[mid]) {
            return mid;
        } else if (target > nums[mid]) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;
}
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722075229.png)

这个思路把待搜索区间 `[left, right]` 分为 3 个部分：

- `mid` 位置（只有 1 个元素）；
- `[left, mid - 1]` 里的所有元素；
- `[mid + 1, right]` 里的所有元素；

循环可以继续的条件是 `while (left <= right)`，特别地，当 `left == right` 即当待搜索区间里只有一个元素的时候，查找也必须进行下去；

------------------------

### 减治思想

**【中位数向下取整】**

```java
public int binarySearch(int[] nums, int target) {

    int left = 0;
    int right = nums.length - 1;

    while (left < right) {
        // 选择中位数时下取整
        int mid = (left + right) >>> 1;
        // check(mid)
        if(target > nums[mid]) {
            // 下一轮搜索区间是 [mid + 1, right]
            left  = mid + 1;
        } else {
            // 下一轮搜索区间是 [left, mid]
            right = mid;
        }
    }
    // 退出循环的时候，程序只剩下一个元素没有看到 (left = right指向的元素)
    // 视情况，是否需要单独判断 left（或者 right）这个下标的元素是否符合题意
    return nums[left] == target ? left : -1;
}
```

**【中位数向上取整】**

```java
public int search(int[] nums, int target) {
    while (left < right) {
        // 选择中位数时上取整
        int mid = left + (right - left + 1) / 2;
        if (check(mid)) {
            // 下一轮搜索区间是 [left, mid - 1]
            right = mid - 1;
        } else {
            // 下一轮搜索区间是 [mid, right]
            left = mid;
        }
    }
    // 退出循环的时候，程序只剩下一个元素没有看到。
    // 视情况，是否需要单独判断 left（或者 right）这个下标的元素是否符合题意
}
```

**上取整还是下取整？**

**只有看到分支是 left=mid 与 right=mid-1，才需要将中间数上取整**

-----------------------------------------------

二分查找算法是典型的「减治思想」的应用，我们使用二分查找将待搜索的区间逐渐缩小，以达到「缩减问题规模」的目的；

这个版本的模板推荐使用的原因是：需要考虑的细节最少，编码时不容易出错。二分得处处考虑周到，不然就是死循环❌！

> 👉[**减治思想写二分查找问题**](https://www.bilibili.com/video/BV147411i7zu)，图片来自weiwei大佬的视频讲解

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722102654.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722102653.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722102657.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722102656.png)![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722102655.png)

> 图片及视频内容来自[liweiwei1419](https://leetcode-cn.com/problems/search-insert-position/solution/te-bie-hao-yong-de-er-fen-cha-fa-fa-mo-ban-python-/)，[减治思想写二分查找问题](https://www.bilibili.com/video/BV147411i7zu?p=1)

理解模板代码的要点：

- 核心思想：虽然模板有两个，但是核心思想只有一个，那就是：把待搜索的目标元素放在最后判断，每一次循环排除掉不存在目标元素的区间，目的依然是确定下一轮搜索的区间；
- 特征：`while (left < right)`，这里使用严格小于 `<` 表示的临界条件是：当区间里的元素只有 2 个时，依然可以执行循环体。换句话说，退出循环的时候一定有 `left == right` 成立，**这一点在定位元素下标的时候极其有用**；
- 在循环体中，先考虑 `nums[mid]` 在满足什么条件下不是目标元素，进而考虑两个区间 `[left, mid - 1]` 以及 `[mid + 1, right]` 里元素的性质，目的依然是确定下一轮搜索的区间；
- <font color = red>**注意 1**</font>：先考虑什么时候不是解，是一个经验，在绝大多数情况下不易出错，重点还是确定下一轮搜索的区间，由于这一步不容易出错，它的反面（也就是 `else` 语句的部分），就不用去考虑对应的区间是什么，直接从上一个分支的反面区间得到，进而确定边界如何设置；
- 根据边界情况，看取中间数的时候是否需要上取整；
- <font color = red>**注意 2**</font>： 这一步也依然是根据经验，建议先不要记住结论，在使用这个思想解决问题的过程中，去思考可能产生死循环的原因，进而理解什么时候需要在括号里加 1 ，什么时候不需要；
- 在退出循环以后，根据情况看是否需要对下标为 `left` 或者 `right` 的元素进行单独判断，这一步叫「后处理」。在有些问题中，排除掉所有不符合要求的元素以后，剩下的那 1 个元素就一定是目标元素。如果根据问题的场景，目标元素一定在搜索区间里，那么退出循环以后，可以直接返回 `left`（或者 `right`）。

【注意事项】：

- 先写分支，再决定中间数是否上取整；
- 在使用多了以后，就很容易记住，只要看到 `left = mid` ，它对应的取中位数的取法一定是 `int mid = left + (right - left + 1) / 2;`。

## 4. 寻找左侧边界的二分搜索



以下是最常见的代码形式，其中的标记是需要注意的细节：

```java
public int binarySearch(int[] nums, int target) {
    if (nums.length == 0) return -1;
    int left = 0;
    //因为要搜索左右侧边界，所以索引最大位置必须大于数组长度，搜索的区间为[left, right)
    int right = nums.length;
    
    //其他代码
    while (left < right) {
        int mid = (left + right) >>> 1;
        if (nums[mid] == target) {
            right = mid;
        } else if (target > nums[mid]) {
            // 下一轮搜索区间是 [mid + 1, right]
            left = mid + 1;
        } else {
            // 下一轮搜索区间是 [left, mid)
            right = mid;
        }
    }
    return nums[left] == target ? left : -1;
}
```

**1、为什么 while 中是 < 而不是 <=?**

答：用相同的方法分析，因为 ​`right = nums.length`​ 而不是 `nums.length - 1`。因此每次循环的「搜索区间」是 `[left, right)` 左闭右开。

`while(left < right)` 终止的条件是 `left == right`，此时搜索区间 `[left, left)` 为空，所以可以正确终止。

**2、为什么没有返回 -1 的操作？如果 nums 中不存在 target 这个值，怎么办？**

答：因为要一步一步来，先理解一下这个「左侧边界」有什么特殊含义：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722125116.png)

对于这个数组，算法会返回 1。这个 1 的含义可以这样解读：nums 中小于 2 的元素有 1 个。

- 比如对于有序数组 nums = [2,3,5,7]，target = 1，算法会返回 0，含义是：nums 中小于 1 的元素有 0 个。

- 再比如说 nums = [2,3,5,7], target = 8，算法会返回 4，含义是：nums 中小于 8 的元素有 4 个。

综上可以看出，函数的返回值（即 left 变量的值）取值区间是闭区间 `[0, nums.length]`，所以我们在循环结束后添加判断就能在正确的时候 return -1：

```java
while (left < right) {
    //...
}

// target 比所有数都大
if (left == nums.length) return -1;

// 类似之前算法的处理方式
return nums[left] == target ? left : -1;
```



**3、为什么 left = mid + 1，right = mid ？和之前的算法不一样？**

答：这个就是减治的思想，先排除不存在的区间。因为我们的「搜索区间」是 `[left, right)` 左闭右开，所以当 `nums[mid]` 被检测之后，下一步的搜索区间应该去掉 `mid `分割成两个区间，即 `[left, mid) `或 `[mid + 1, right)`

**4、为什么该算法能够搜索左侧边界？**

答：关键在于对于 `nums[mid] == target` 这种情况的处理：

```java
if (nums[mid] == target) {
    right = mid;
}
```

可见，找到 target 时不要立即返回，而是缩小「搜索区间」的上界 `right`，在区间 `[left, mid)` 中继续搜索，即不断向左收缩，达到锁定左侧边界的目的。

**5、为什么返回 left 而不是 right？**

答：都是一样的，因为 while 终止的条件是 `left == right`。

**6、能不能想办法把 right 变成 `nums.length - 1`，也就是继续使用两边都闭的「搜索区间」？这样就可以和第一种二分搜索在某种程度上统一起来了。**

答：当然可以，只要你明白了「搜索区间」这个概念，就能有效避免漏掉元素。下面我们严格根据逻辑来修改：

因为你非要让搜索区间两端都闭，所以 right 应该初始化为 `nums.length - 1`，while 的终止条件应该是 `left == right + 1`，也就是其中应该用 `<=`：

```java
int left_bound(int[] nums, int target) {
    
    // 搜索区间为 [left, right]
    int left = 0, right = nums.length - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        // if else ...
    }
```

因为搜索区间是两端都闭的，且现在是搜索左侧边界，所以 left 和 right 的更新逻辑如下：

```java
if (nums[mid] < target) {
    // 搜索区间变为 [mid+1, right]
    left = mid + 1;
} else if (nums[mid] > target) {
    // 搜索区间变为 [left, mid-1]
    right = mid - 1;
} else if (nums[mid] == target) {
    // 收缩右侧边界
    right = mid - 1;
}
```



由于 while 的退出条件是 `left == right + 1`，所以当 target 比 nums 中所有元素都大时，会存在以下情况使得索引越界：

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722125350.png)

因此，最后返回结果的代码应该检查越界情况：

```java
if (left >= nums.length || nums[left] != target) {
    return -1;
}
   
return left;
```



至此，整个算法就写完了，完整代码如下：

```java
public int left_bound(int[] nums, int target) {
    int left = 0, right = nums.length - 1;
    // 搜索区间为 [left, right]
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] < target) {
            // 搜索区间变为 [mid+1, right]
            left = mid + 1;
        } else if (nums[mid] > target) {
            // 搜索区间变为 [left, mid-1]
            right = mid - 1;
        } else if (nums[mid] == target) {
            // 收缩右侧边界
            right = mid - 1;
        }
    }
    // 检查出界情况
    if (left >= nums.length || nums[left] != target)
        return -1;
    return left;
}
```



这样就和第一种二分搜索算法统一了，都是两端都闭的「搜索区间」，而且最后返回的也是 left 变量的值。只要把住二分搜索的逻辑，两种形式大家看自己喜欢哪种记哪种吧。

## 5. 寻找右侧边界的二分查找

类似寻找左侧边界的算法，这里也会提供两种写法，还是先写常见的左闭右开的写法，只有两处和搜索左侧边界不同，已标注：

```java
public int right_bound(int[] nums, int target) {
    if (nums.length == 0) return -1;
    int left = 0, right = nums.length;

    while (left < right) {
        int mid = (left + right) / 2;
        if (nums[mid] == target) {
            left = mid + 1; // 注意
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else if (nums[mid] > target) {
            right = mid;
        }
    }
    return left - 1; // 注意
}
```



**1、为什么这个算法能够找到右侧边界？**

答：类似地，关键点还是这里：

```java
int right_bound(int[] nums, int target) {
    if (nums.length == 0) return -1;
    int left = 0, right = nums.length;

    while (left < right) {
        int mid = (left + right) / 2;
        if (nums[mid] == target) {
            left = mid + 1; // 注意
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else if (nums[mid] > target) {
            right = mid;
        }
    }
    return left - 1; // 注意
}
```



当`nums[mid] == target`时，不要立即返回，而是增大「搜索区间」的下界 left，使得区间不断向右收缩，达到锁定右侧边界的目的。

**2、为什么最后返回 left - 1 而不像左侧边界的函数，返回 left？而且我觉得这里既然是搜索右侧边界，应该返回 right 才对。**

答：首先，while 循环的终止条件是 `left == right`，所以 left 和 right 是一样的，你非要体现右侧的特点，返回 `right - 1` 好了。

至于为什么要*减一*，这是搜索右侧边界的一个特殊点，关键在这个条件判断：

```java
if (nums[mid] == target) {
    left = mid + 1;
}
```

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722134715.png)

这样想: `mid = left - 1`

因为我们对 left 的更新必须是 `left = mid + 1`，就是说 while 循环结束时，`nums[left]` 一定不等于 target 了，而 `nums[left-1]` 可能是 target。

至于为什么 left 的更新必须是 left = mid + 1，同左侧边界搜索，就不再赘述。

**3、为什么没有返回 -1 的操作？如果 nums 中不存在 target 这个值，怎么办？**

答：类似之前的左侧边界搜索，因为 while 的终止条件是 left == right，就是说 left 的取值范围是 [0, nums.length]，所以可以添加两行代码，正确地返回 -1：

```java
while (left < right) {
    // ...
}
if (left == 0)  return -1;

return nums[left-1] == target ? (left-1) : -1;
```



**4、是否也可以把这个算法的「搜索区间」也统一成两端都闭的形式呢？这样这三个写法就完全统一了，以后就可以闭着眼睛写出来了。**

答：当然可以，类似搜索左侧边界的统一写法，其实只要改两个地方就行了：

```java
int right_bound(int[] nums, int target) {
    int left = 0, right = nums.length - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] == target) {
            // 这里改成收缩左侧边界即可
            left = mid + 1;
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else (nums[mid] > target) {
            right = mid - 1;
        } 
    }
    // 这里改为检查 right 越界的情况，见下图
    if (right < 0 || nums[right] != target)
        return -1;
    return right;
}
```

当 target 比所有元素都小时，right 会被减到 -1，所以需要在最后防止越界。

## 6. 模板总结

对于寻找某一元素是否存在的二分搜索，常见的手法是使用**左闭右闭「left, right」，right = [数组长度 - 1]**

```java
public int binarySearch(int[] nums, int target) {
    int left = 0;
    int right = nums.length - 1;
    while (left < right) {
        // 选择中位数时下取整
        int mid = (left + right) >>> 1;
        // check(mid)
        if(target > nums[mid]) {
            // 下一轮搜索区间是 [mid + 1, right]
            left  = mid + 1;
        } else {
            // 下一轮搜索区间是 [left, mid]
            right = mid;
        }
    }
    // 退出循环的时候，程序只剩下一个元素没有看到 (left = right指向的元素)
    // 视情况，是否需要单独判断 left（或者 right）这个下标的元素是否符合题意
    return nums[left] == target ? left : -1;
}
```



对于寻找左右边界的二分搜索，常见的手法是使用**左闭右开「left, right），right = [数组长度]**

【搜所左边界】

```java
public int binarySearch_left(int[] nums, int target) {
    int left = 0;
    //因为要搜索左右侧边界，所以索引最大位置必须大于数组长度，搜索的区间为[left, right)
    int right = nums.length;
    while (left < right) {
        int mid = (left + right) >>> 1;
        if (target > nums[mid]) {
            // 下一轮搜索区间是 [mid + 1, right]
            left = mid + 1;
        } else {
            // 下一轮搜索区间是 [left, mid)
            right = mid;
        }
    }
    return nums[left] == target ? left : -1;
}
```

【搜所右边界】

```java
public static int binarySearch(int[] nums, int target) {
    int left = 0;
    //因为要搜索左右侧边界，所以索引最大位置必须大于数组长度，搜索的区间为[left, right)
    int right = nums.length;
    while (left < right) {
        int mid = (left + right) >>> 1;
        if (target == nums[mid]) {
            left = mid + 1;
        } else if (target > nums[mid]) {
            // 下一轮搜索区间是 [mid + 1, right]
            left = mid + 1;
        } else {
            // 下一轮搜索区间是 [left, mid)
            right = mid;
        }
    }
    return nums[left-1] == target ? left-1 : -1;
}
```

--------------------------------------

**left <= right**

我们还根据逻辑将「搜索区间」全都统一成了两端都闭，便于记忆，只要修改两处即可变化出三种写法：

```java
public int binary_search(int[] nums, int target) {
    int left = 0, right = nums.length - 1; 
    while(left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] < target) {
            left = mid + 1;
        } else if (nums[mid] > target) {
            right = mid - 1; 
        } else if(nums[mid] == target) {
            // 直接返回
            return mid;
        }
    }
    // 直接返回
    return -1;
}

public int left_bound(int[] nums, int target) {
    int left = 0, right = nums.length - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] < target) {
            left = mid + 1;
        } else if (nums[mid] > target) {
            right = mid - 1;
        } else if (nums[mid] == target) {
            // 别返回，锁定左侧边界
            right = mid - 1;
        }
    }
    // 最后要检查 left 越界的情况
    if (left >= nums.length || nums[left] != target)
        return -1;
    return left;
}


public int right_bound(int[] nums, int target) {
    int left = 0, right = nums.length - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] < target) {
            left = mid + 1;
        } else if (nums[mid] > target) {
            right = mid - 1;
        } else if (nums[mid] == target) {
            // 别返回，锁定右侧边界
            left = mid + 1;
        }
    }
    // 最后要检查 right 越界的情况
    if (right < 0 || nums[right] != target)
        return -1;
    return right;
}
```



----------------------------------------

【参考链接】

1. [用减治思想写二分查找问题、几种模板写法的介绍与比较](https://leetcode-cn.com/problems/search-insert-position/solution/te-bie-hao-yong-de-er-fen-cha-fa-fa-mo-ban-python-/)
2. [二分查找算法](https://ojeveryday.github.io/AlgoWiki/#/BinarySearch/01-introduction?id=二分查找算法-1)
3. [二分查找详解](https://labuladong.gitbook.io/algo/suan-fa-si-wei-xi-lie/er-fen-cha-zhao-xiang-jie)
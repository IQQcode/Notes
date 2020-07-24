![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418183123.png)

### 1. 希尔排序思想

希尔排序(Shell Sort)是插入排序的一种，是**直接插入排序**算法的一种更高效的改进版本。具体高效在何处呢？

前面俺讲插入排序的时候，我们会发现一个很费劲的事儿，如果已排序的分组元素为`[2,5,6,7,8,9]`，未排序的分组元素为`[1]`。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418200834.png)

我们需要拿着`1`从后往前，依次和`2,5,6,7,8,9`进行交换位置，才能完成真正的插入，每次交换只能和相邻的元素交换位置，这样比实在是效率低下。但是，在插入排序时俺说了**折半插入**，这算是一种优化，但是如果我要是将`1`插入到`2,5,1,7,8,9`当中，是不是就不行啦？

那我可不可以这样做呢？

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418202300.png)

把`1`放到更前面的位置，比如一次交换就能把`1`插到`6`和`7`之间，这样一次交换1就向前走了3个位置，可以减少交换的次数，然后再通过一次交换，直接结束排序。这样的需求如何实现呢？接下来我们来看看**希尔排序**的原理。

### 2. 希尔排序详解

**排序原理：**

1. 选定一个增长量`ans`，按照增长量`ans`作为数据分组的依据，对数据进行分组；

2. 对分好组的每一组数据完成**插入排序**（每个子组的排序使用的是插入排序）；

3. 减小增长量，最小减为1，重复第二步操作

-----------------------------------

**增长量ans：** 我们这里采用以下规则

​    <img src="https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418203555.png" style="zoom:67%;" />

**【第一趟排序】**

初始增量为`ans = length/2 = 4`，即将整个数组划分为4个子组，分别为`4,6`，`8,2`，`9,6`，`7,1`

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722224144.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418185830.png)

将每个子组独立的看为一个要排序的数组，然后分别进行直接排序。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418185852.png)

可以看到，每个子序列现在已经有序了。但是将每个子序列回归放到整个数组中，发现整个数组还是乱序的。我们接着进行第二趟排序。

**【第二趟排序】**

二次增量为`ans = 4/2 = 2`，即将整个数组划分为4个子组，分别为`4,6,6,9`，`2,1,8,7`

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200722224510.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418195035.png)

然后在分别对两个子组进行插入排序

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418192053.png)

**【第三趟排序】**

第三次增量为`ans = 2/2 = 1`，即将每个元素看成一组，子序列合并为一组，`4,1,6,2,6,7,9,8`。

其实，这就是相当于**直接插入排序**。

但是，经过第一趟、第二趟的处理之后，此时第三趟要排序的数组对比于原数组，我们发现它其实是被**粗略调整**过了，**数组中的逆序对个数明显减少**，数组在一定程度上变得相对有序了。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418192910.png)

此时，仅仅需要对以上数列简单微调，无需大量移动操作即可完成整个数组的排序。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418192926.png)

### 3. 代码实现

```java
public void shellSort(Integer[] arr) {
        //根据数组长度，确定增长量ans
        int ans = 1;
        while (ans < arr.length/2) {
            ans = 2 * ans + 1; //3,7,15...
        }

        // 减小ans的值
        while ((ans >>= 1) > 0) {
            //找到待插入的元素
            //第一个待插入元素的索引为ans，该子组中ans之前的元素已有序
            for (int i = ans; i < arr.length; i++) {
                //待插入的元素插入到分组的有序序列中
                for (int j = i; j >= ans; j -= ans) {
                    //将待排序元素arr[j]倒序依次与有序序列中元素比较，放入有序序列中合适位置
                    if(arr[j] < arr[j-ans]) {
                        int temp = arr[j];
                        arr[j] = arr[j-ans];
                        arr[j-ans] = temp;
                    } else {
                        // 有序则不做处理(等同于break)，此处不加else也可以
                        break;
                    }
                }
            }
        }
    }
```

### 4. 复杂度分析

希尔排序，利用分组粗调的方式减少了直接插入排序的工作量，使得算法的平均时间复杂度低于0(n^2^)

**【时间复杂度】O(nlogn)**

**【空间复杂度】O(1)**

### 5. 希尔排序与插入排序比较

我们可以使用事后分析法对希尔排序和插入排序做性能比较。

测试从`100000 ~ 1`的逆向数据数组，我们可以根据执行时间来完成测试。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200418205606.png)

【执行时间】

- 希尔排序：29ms
- 直接插入排序：76826ms
- 折半插入排序：13075ms

可以看出，希尔排序的效率相比其他两种效率很高。这就是得益于每趟对数组进行的**粗略调整，有效的减少了数列中逆序对的个数**
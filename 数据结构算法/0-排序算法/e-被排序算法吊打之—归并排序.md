![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419080543.png)

### 1. 归并排序思想

归并排序（MERGE-SORT）是建立在归并操作上的一种有效的排序算法，该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为二路归并。

其实说白了，就是基于**分治**的思想，先将数组才分成为不可再分的原子，然后对他们合并排序。把乱序的数组拆开，然后再合并的时候排序。

可能有的小伙伴就好奇了，咱昨天唠了[**希尔排序**](https://blog.csdn.net/weixin_43232955/article/details/105605403)（没看的伙伴去回顾一下哈），希尔排序也是将数组不断地分成子序列，然后对子序列排序呀，这不是一样一样的么！

<img src="http://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20181212/a62a5640a9764867b73a332e896fa8e7.jpeg" alt="img" style="zoom:50%;" />

嘿嘿，其实还真不一样！

那有啥子区别嘞？

-----------------------

**希尔排序**是将待排序的数组划分成子序列，且子序列的长度随着排序的趟数是递增的。它分组的好处就是能够明显的提高插入排序的效率，就像下面这样：

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9pcXFjb2RlLWJsb2cub3NzLWNuLWJlaWppbmcuYWxpeXVuY3MuY29tL2ltZy8yMDIwMDQxODIwMjMwMC5wbmc?x-oss-process=image/format,png)

说到底，希尔排序的原理还是基于[插入排序](https://blog.csdn.net/weixin_43232955/article/details/105577372)的，插入排序的原理就是比较交换。

**归并排序**的思想是基于`分治`思想的，那门我们就是用递归的思路来解决问题，将大问题分解为小问题，层层递归调用。

假设现在有一个待排序的序列，[8，4，5，7，1，3，6，2]，那么我们就需要将该序列进行分治，先将其分成两份：[8，4，5，7] 和 [1，3，6，2]，再将这两份分别分成两份：[4，4]和[5，7]；[1，3] 和 [6，2]，最后将这四部分再次分别分为两份，最后就将整个序列分为了八份（如果是奇数个数同样最后都分为一个子元素）。需要注意的是，在分的过程中，不需要遵循任何规则，关键在于归并，归并的过程中便实现了元素的排序。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419082907.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200723094717.png)

我们可以很明显的看出，归并排序是一个递归的过程。不断地划分子区间，子问题解决了回退到上一层的问题，依次归并回去。

**【排序原理】**

1. 尽可能的将一组数据拆分成两个元素相等的子组，并对每一个子组继续拆分，直到拆分后的每个子组只剩1个元素为止。
2. 将相邻的两个子组进行合并成一个`有序`的大组；
3. 不断的重复步骤2，直到最终只有一个组为止。

这就是归并排序的分组，先分再合，在合起来的同时对其进行排序。

### 2. 归并排序详解

**递归排序动画详解**

![img](https://imgconvert.csdnimg.cn/aHR0cDovL3d3dy5jeHl4aWFvd3UuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE5LzEwLzE1NzEwNTgyODEtNDFiNGMzYjk5N2FmMmNhLmdpZg)

> 动画来源——[动画图解：十大经典排序算法动画与解析，看我就够了](https://blog.csdn.net/kexuanxiu1163/article/details/103051357)

归并排序的思想后我知道了，但是，在合并子元素时，是怎么操作就让子序列有序了？它们是如何操作将子序列合为一个有序的组呢？

**【归并原理】：**

我们通过三个指针来指向元素交换，通过辅助数组（与原数组等长）完成交换，最后将辅助数组中的有序序列拷贝到原数组中。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419092623.png)

**细节操作**

如果按照上图直接进行排序，排完之后为`1,3,4,5,6,2,7,8`我们会发现还是不行的。

我们必须要确保子序列一定是有序的，然后再依次放入到辅助数组中。这一步，就是递归调用来完成有序交换的。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419093618.png)

**第一次填充**

指针`p1`和指针`p2`比较各自指向的当前元素，谁的小，就将谁放到辅助数组中，`1`比`3`小，将`1`放入。

指针`p2`指向下一个元素，`index`指向下一个空位置。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419094141.png)

**第二次填充**

`2`比`3`小，指针`p2`指向下一个元素，`index`指向下一个空位置。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419094157.png)

**第三次填充**

`3`比`4`小，指针`p1`指向下一个元素，`index`指向下一个空位置。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419094335.png)

**第六次填充**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419094628.png)

**第七次填充**

我们发现，此时右边序列都填充完毕了。左边还剩`7,8`，那我们直接将它放入到辅助数组即可。

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419094844.png)

**第八次填充**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419095202.png)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419095457.png)

对于归并排序算法，有两个部分组成，分解和合并。首先讲讲分解，在前面也说到了，我们需要将待排序的序列不停地进行分解，通过两个索引变量控制，一个初始索引，一个结尾索引。只有当两索引重合才结束分解。此时序列被分解成了八个小份，这样分解工作就完成了。

接下来是合并，合并操作也是最麻烦的，也是通过两个索引变量`p1`，`p2`。开始`p1`在左边序列的第一个位置，在右边序列的第一个位置，然后就是寻找左右两个序列中的最小值，放到新序列中，这时可能会出现一边的元素都放置完毕了，而另外一边还存在元素，此时只需将剩余的元素按顺序放进新序列即可，因为这时左右两边的序列已经是有序的了，最后将新序列复制到旧序列。

**这里也特别需要注意，因为合并的过程是分步的，而并非一次合并完成，所以数组的索引是在不断变化的。**

### 3.代码实现

```java
/**
 * @Author: Mr.Q
 * @Date: 2020-04-12 21:32
 * @Description:归并排序
 * left: 记录数组中的最小索引
 * right:记录数组中的最大索引
 * temp: 辅助数组
 */
public class MergeSort {
    public static void mergeSort(int[] arr, int low, int high) {
        //初始化辅助数组
        int[] temp = new int[arr.length];
        //递归出口,安全性校验
        if(low < high) {
            //中间索引将low与high之间的数据分为两组
            int mid = low + (high-low)/2;
            //对两组数据分别进行递归排序
            //向左递归，对[left, mid]区间进行分解排序
            mergeSort(arr, low, mid);
            //向右递归，对[mid+1, high]区间进行分解排序
            mergeSort(arr, mid+1, high);
            //此时左右子组已经有序
            //将两组排好序的子序列进行归并再排序
            merge(arr, low, high, mid, temp);
        }
    }

    /**
     * 从low到mid为一组，从mid+1到high为一组，对这两组数据进行归并
     * 归并方法：通过三指针的移动，将左右子序列重新再排序放入到辅助数组中，然后将辅助数组中的有序序列放回到源数组
     * @param arr 待排序的数组
     * @param low 左子有序序列的初始索引
     * @param high 右子有序序列的末位索引
     * @param mid 中间索引
     * @param temp 做中转的辅助数组
     */
    public static void merge(int[] arr, int low, int high, int mid, int[] temp) {
        //左边有序序列的初始索引 
        int p1 = low;
        //右边有序序列的初始索引(为中间位置的后一个位置)
        int p2 = mid + 1;
        //指向temp数组的当前索引
        //此处index初始化必须为low,不能为0;因为merge()在mergeSort()中递归调用
        //这里也特别需要注意，因为合并的过程是分步的，而并非一次合并完成，所以数组的索引是在不断变化的。
        int index = low;

        // 移动p1、p2指针,先把左右两边的(已经有序)数据按排序规则填充到temp数组
        // 直到左右两边的有序序列，有一边处理完成为止
        while (p1 <= mid && p2 <= high) {
            if (arr[p1] < arr[p2]) {
                temp[index++] = arr[p1++];
            }else {
                temp[index++] = arr[p2++];
            }
        }
        //如有左右有一方没有走完(子序列没有全部放到temp)，那么顺序移动相应指针，将剩余元素放入temp
         while (p1 <= mid) {
             temp[index++] = arr[p1++];
         }

         while (p2 <= high) {
             temp[index++] = arr[p2++];
         }

        //将辅助数组中的有序序列放回到源数组
        for (int i = low; i <= high; i++){
            arr[i] = temp[i];
        }
    }
}
```

【代码精简】

```java
public class MergeSort {
    public static void mergeSort(int[] arr, int low, int high) {
        if (low >= high) return;
        int[] temp = new int[arr.length];
        int pivot = (low + high) >>> 1;
        mergeSort(arr, low, pivot);
        mergeSort(arr, pivot + 1, high);
        merge(arr, low, pivot, high, temp);
    }

    private static void merge(int[] arr, int low, int pivot, int high, int[] temp) {
        int p1 = low, p2 = pivot + 1;
        int index = low;
        while (p1 <= pivot && p2 <= high) {
            temp[index++] = arr[p1] < arr[p2] ? arr[p1++] : arr[p2++];
        }
        while (p1 <= pivot) temp[index++] = arr[p1++];
        while (p2 <= high)  temp[index++] = arr[p2++];

        for (int i = low; i <= high; i++) {
            arr[i] = temp[i];
        }
    }
}
```



### 4. 复杂度分析

**【时间复杂度分析】**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200419100028.png)

用树状图来描述归并，如果一个数组有8个元素，那么它将每次除以2找最小的子数组，共拆log8次，值为3，所以树共有3层,那么自顶向下第k层有(2^k) 个子数组，每个数组的长度为(2 ^ (3-k))，归并最多需要2^(3-k)次比较。因此每层的比较次数为 2^k * 2 ^ (3-k)=2^3,那么3层总共为 3\*2^3。

假设元素的个数为n，那么使用归并排序拆分的次数为log2(n)，所以共log2(n)层，那么使用log2(n)替换上面3\*2^3中的3这个层数，最终得出的归并排序的时间复杂度为：log2(n)* 2^(log2(n))=log2(n)*n，根据大O推导法则，忽略底数，最终归并排序的时间复杂度为***O(nlogn)**

**【空间复杂度】**

由于新开辟了辅助数组，空间复杂度为**O(n)**
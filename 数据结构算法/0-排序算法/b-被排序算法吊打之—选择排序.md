![在这里插入图片描述](https://img-blog.csdnimg.cn/20200414212716447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

### 1. 选择排序思想

选择排序，就是通过选择，将元素放到合适的位置上。那么，如何进行选择呢？

举个例子，大家在买东西时，一定会货比三家吧。我们肯定是希望花最少的钱，买最优的货，这种比较选择，就是选择排序的思想。

我现在要在某宝买三顶假发，在购物车添加了五个不同的店家商品（假定我只在一家店只买一件商品）。首先，我会以一家的价钱作为标准，然后和其他四家店的价格比较。比完之后我会选出一件最便宜的付款，然后再剩下的四家中再次选出最便宜的进行比较购买。这就是选择排序的**选择**。

### 2. 选择排序详解

对序列【4 , 6 , 8 , 7 , 6 , 2 , 9 , 1】递增排序
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020041500084213.png)

- [ ] 我们让**min**作为进行选择探测的指针

- 对原数据而言，假定第一个索引处的元素是最小值，即当前`min = 4`；

- 第一趟排序：min依次和之后索引处的数进行比较，当它到索引5所指向的数`2`时，发现此索引处的数比自己小，于是让自己指向当前元素，即`min = 2`；然后`min`继续向后探测，发现末尾索引处元素`2`比自己还小，继续更换，`min = 1`；

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200415000040575.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

- 此时，遍历完了序列，min发现自己等于`1`时是最小的。于是和当初假装自己是最小的`4`进行交换位置
- 交换完之后，min后移一位，然后又假装此时自己指向的是最小的元素，第二趟选择排序开始
- 以此类推继续排序。倘若比较完后·`min`位置的元素是最小值，那就无需交换，不动即可

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200414234639335.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

- 直到剩余最后一个元素时，min也不用假装自己指向的最小元素了，这次是真的了。只剩一个了，一定是最大的了，就不用管了。到此，选择排序完成！

【动图详解】
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200414223917402.gif)

------------

**选择排序就是通过改变——指向最小元素索引的位置来寻找每趟最小的数，每趟遍历交换指针min指向的值，来比较确定出每趟的最小元素，之后交换元素位置**

------------

### 3. 代码实现

**外层循环完成了数据交换，内层循环完成了数据比较**

```java
public static void selectSort(int[] arr) {
        //参与选择排序的元素：只剩一个元素时不用选择，到倒数第二个元素截止
        for (int i = 0; i < arr.length - 1; i++) {
            //假定本次遍历最小值所在的索引是i，默认第一个
            int minIndex = i;
            //让当前最小元素与它后面的元素依次进行比较
            for (int j = i + 1; j < arr.length; j++) {
                if(arr[minIndex] > arr[j]) {
                    //交换最小值所在的索引
                    minIndex = j;
                }
            }
            //将最小元素所在索引minIndex处的值与i索引的值交换
            int temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
```

> <font color = pink size = 4>测试</font>

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200415003511572.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

> 归并排序后为：[1, 2, 4, 6, 6, 7, 8, 10]

### 4. 复杂度分析

**【时间复杂度】**

选择排序使用了双层`for`循环，其中外层循环完成了数据交换，内层循环完成了数据比较，数据
交换次数和数据比较次数：

**数据交换次数：N-1**

**数据比较次数：(N-1)+(N-2)+(N-3)+...+2+1=((N-1)+1)*(N-1)/2=N^2/2-N/2**

时间复杂度：N^2 / 2 -  N / 2 + (N-1) = N ^ 2/2 + N/2-1;

根据大O推导法则，保留最高阶项，去除常数因子，**时间复杂度为O(N^2)**

**【空间复杂度】O(1)**



### 问题描述

> 👉[**相交链表**](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)👈

如下面的两个链表：

【情况一】

![](https://assets.leetcode.com/uploads/2018/12/13/160_example_1.png)

【情况二】

![](https://assets.leetcode.com/uploads/2018/12/13/160_example_2.png)

【情况三】

![](https://assets.leetcode.com/uploads/2018/12/13/160_example_3.png)

编写一个程序，找到两个单链表相交的起始节点

### 1. 最直观：暴力求解

对链表A中的每一个结点nodeA​，遍历整个链表 `B` 。并检查链表 `B` 中是否存在结点nodeB和nodeA相同（注意不是数值相等）

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200605170931.png)

```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        if(headA == null || headB == null) {
            return null;
        }
        while(headA != null) {
            ListNode p = headB;  
            while(p != null) {
                if(p == headA) {
                    return p;
                } else{
                    p = p.next;
                }
            }
            headA = headA.next;
        }
        return null;
    }
}
```

----------------------------------------------------

### 2. 爱情浪漫相遇法

一种比较巧妙的方式是，分别为链表A和链表B设置指针A和指针B，然后开始遍历链表，如果遍历完当前链表，则将指针指向另外一个链表的头部继续遍历，直至两个指针相遇。


最终两个指针分别走过的路径为：

- 指针A：a+c+b

- 指针B ：b+c+a

- 明显 `a+c+b = b+c+a`，因而如果两个链表相交，则指针A和指针B必定在相交结点相遇。

> 动画作者：[noraZh](https://leetcode-cn.com/u/norazh/)
>
> 链接：[力扣](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/solution/lian-biao-xiang-jiao-shuang-zhi-zhen-onshi-jian-fu/)

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200605173445.gif)

**思路理解：**

思路是设定两个指针分别指向两个链表头部，一起向前走直到其中一个到达末端，另一个与末端距离则是两链表的 长度差。再通过长链表指针先走的方式消除长度差，最终两链表即可同时走到相交点。

**两个指针在遍历链表时，总路径都是a+b+c是相同的，每次两个指针所走的步长是相同的，我们把相遇点理解为终点，两个两表最终会相遇。**

![](https://iqqcode-blog.oss-cn-beijing.aliyuncs.com/img/20200605180907.png)

![Picture1.png](https://pic.leetcode-cn.com/5651993ddb76ae6a42f0b338aec9382206f567041113f49d6ca670832ac75791-Picture1.png)

```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        ListNode ha = headA, hb = headB;
        while (ha != hb) {
            ha = ha != null ? ha.next : headB;
            hb = hb != null ? hb.next : headA;
        }
        return ha;
    }
}
```

------------------

### 3. 栈解法

将两个链表分别进行压栈操作，之后进行对比出栈，当元素一致时就不断出出出，不一致就停止出栈操作，之后开始判断两个栈是否为空的情况，分别讨论应该返回哪个元素

```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        if(headA == null || headB == null) {
            return null;
        }
        Stack<ListNode> st1 = new Stack<>();
        Stack<ListNode> st2 = new Stack<>();
        ListNode nodeA = headA;
        ListNode nodeB = headB;
        while(nodeA != null) {
            st1.push(nodeA);
            nodeA = nodeA.next;
        }

        while(nodeB != null) {
            st2.push(nodeB);
            nodeB = nodeB.next;
        }

        ListNode t1 = st1.peek();
        ListNode t2 = st2.peek();

        //在没有弹出元素之前，栈顶元素一定相同，否则两链表没有相交
        if(t1 != t2)  
            return null;

        //两个栈都不为空开始弹栈
        while(t1 == t2 && !st1.empty() && !st2.empty()) {
            t1 = st1.peek();
            st1.pop();
            t2 = st2.peek();
            st2.pop();
        }

        //一个空一个不为空
        if(st1.empty() && !st2.empty())  {
            //如果栈此时已空直接返回next
            if(t1 != t2)  
                return t2.next;
            else {
                //如果栈不空
                t2 = st2.peek();
                st2.pop();
                return t2.next;
            }
        } else if(!st1.empty() && st2.empty()) {
            if(t1 != t2) {
                return t1.next;
            } else {
                t1 = st1.peek();
                st1.pop();
                return t1.next;
            }
        } else if(st2.empty() && st1.empty())  {
            //两个栈都空
            if(t1 == t2)
                return t1;
            return t2.next;
        } else  {
            //两个栈都不为空
            return t1.next;
        }    
    }
}
```





------------------

【参考链接】

1. [belinda题解](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/solution/jiao-ni-yong-lang-man-de-fang-shi-zhao-dao-liang-2/)

2. [Krahets题解](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/solution/intersection-of-two-linked-lists-shuang-zhi-zhen-l/)

3. [相交链表[3种解法]](https://blog.csdn.net/weixin_40740059/article/details/89406325)



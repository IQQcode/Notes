@[toc]
##  ECMAScript语法基础

### 1. 数据类型：
#### 1.1 原始数据类型（基本数据类型）：
1.number：数字。整数/小数/NaN（not a number一个不是数字的数字类型）

- var a =  + "1213abc";//将字符串转换为数字

2.string：字符串。字符串`“abc"`,`"a"`,`'abc'`

3.boolean：true 和 false

4.null：一个对象为空的占位符

5.undefined：未定义。如果一个变量没有给初始化值，则会被默认赋值为undefined

#### 1.2 引用数据类型：对象



### 2. 变量

变量：一块存储数据的内存空间

Java语言是强类型的语言，JavaScript是弱类型的语言

- 强类型在申请空间时必须 规定类型，弱类型在申请空间时不用规定类型（可以存放任意类型的数据）

语法：

`var 变量名 = 初始化值;`

**typeof运算符**：获取变量的类型。注：null 运算后得到的是object



### 3.运算符

JavaScript运算符与Java相似，类比Java即可

- 一元运算符：只有一个运算数的运算符

> ++，-，+（正号）

- 算数运算符

> +，-，*，/，%，

- 赋值运算符 

> \=， +=， -=， 

- 比较运算符

> \>，<， >=， <= ， =\=， \\===

- 逻辑运算符

> &&， ||， ！

- 三元运算符

> ?  :



### 4. 特殊语法(作用域)

变量的定义使用**var**关键字，也可以不使用

- 用：定义的是局部变量
- 不用：定义的是全局变量

![image-20200112111155128](C:\U![image20200112111155128.png](0)sers\j2726\AppData\Roaming\Typora\typora-user-images\image-20200112111155128.png)



### 5. 流程控制语句

1. if...else...
2. while
3. do...while
4. for
5. switch(任意类型)

- Java中switch可接受的数据类型：byte，int，short，char，enum(JDK1.5)，String

```javascript
        var c = "abc";
        switch(c) {
            case 1:
                alert("number");
                break;
            case "abc":
                alert("string");
                break;
            case true:
                alert("boolean");
                break;
            case null:
                alert("null");
                break;
            case undefined:
                alert("undefined");
                break;
        }
```

### 6.基本对象

**基本对象：**
Function：函数对象
Array
Boolean
Date
Math
Number
String
RegExp
Global


[TOC]



> Python是一个动态类型的语言.（JavaScript）
>
> 一个变量在运行的过程中，类型可以发生变化



![1565568251577](C:\Users\j2726\AppData\Roaming\Typora\typora-user-images\1565568251577.png)

**Python的交互式解释器**

**导入第三方库**

导入 **Image** :  `pip install Image`

如导入 **qrcode** : `pip install qrcode`

**变量命名**

1. 数字字母下划线构成，数字不能开头
2. 见名知意

**列表解析**

```python
# 要求： 给定一个列表，列表中是一些数字，需要把其中的数字生成一个新的列表.
# 例如按照乘方的形式变换
arr = [1, 2, 3, 4, 5, 6]
brr = []
for num in arr:
    if num %2  == 0:
        continue
    num = num * num
    brr.append(num)
print(brr)
```

```python
#列表解析
arr = [1, 2, 3, 4, 5, 6]
brr = [num ** 2 for num in arr if num % 2 ==1]
print(brr)
```


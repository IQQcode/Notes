### String转为int

**Integer.parseInt转为int**

```java
int i = Integer.parseInt(str);
```

**Integer.valueOf转为Integer，intValue再转为int**

```java
int i = Integer.valueOf(s).intValue();
```



### int转为String

**String.valueOf**

```java
String s = String.valueOf(i);
```

**Integer.toString**

```java
String s = Integer.toString(i);
```

**加空串，效率低**

```java
String s = “” + i;
```


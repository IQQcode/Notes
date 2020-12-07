**javaIO--BIO(阻塞式IO)**

掌握核心的五个类：

`File`,`OutputStream`,`InputStream`,`Reader`,`Writer`

 一个接口：`Serializable`

### 1. File

#### 1.1 File文件操作

File类是唯一一个与文件本身操作有关的程序类(创建、删除、取得信息,但是无法操作文件的内容)**

产生File对象：

```java
 public File(String pathname):根据文件的绝对路径产生file对象
 
 public File(URI uri):根据网络产生File对象

 if(file.exists()) {  //判断是否存在
      file.delete();  //删除
  }else {
      file.createNewFile();  //创建文件
  }
```

文件分隔符：`File.separator` 



#### 1.2 目录操作

- 取得父路径的File对象 ：`public File getParentFile() {}`
- 取得父路径的目录        :  `public String getParent() {}`
- 创建多级父路径(一次性创建多级不存在的父路径) : `public boolean mkdirs()`

**在多级父路径下创建文件**
```java
import java.io.File;
import java.io.IOException;

public class CreateFile {
    public static void main(String[] args) {
        //1.取得File对象
        File file = new File(File.separator + "C:" + File.separator +
                "Users" + File.separator + "j2726" + File.separator + "Desktop" + File.separator +"javaIO" + File.separator + "Mr.Q" + File.separator +"File" + File.separator + "Hello!");

        //2.判断父路径是否存在，不存在则创建多级父路径
        if(!file.getParentFile().exists()) {
            //多级父路径 + mkdirs()创建文件
            file.getParentFile().mkdirs();
            // 如果直接 file.mkdirs()则会创建为文件夹
        }

        //3.判断文件是否存在，不存在则创建文件
        if(file.exists()) {
            System.err.println("文件已存在！删除后重新创建...");
            file.delete();
        }else {
            try {
                file.createNewFile();
                System.out.println("javaTest文件夹创建成功！");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```
桌面上出现了此文件：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815195118416.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815195355804.png)
#### 1.3 取得文件信息

- 判断File对象是否是文件： `public boolean isFile()`
- 取得文件大小（字节为单位） ：`` public long length()`` 
- 取得上次修改时间： `public long lastModified()`
- 判断File对象是否是文件夹： `public  boolean isDirectory()`
- 列出一个目录的全部组成： `public File[] listFiles()`

**取得文件大小信息：**
```java
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * @Author: Mr.Q
 * @Date: 2019-07-22 12:24
 * @Description:取得文件信息
 */

public class GainFileInformation {
    public static void main(String[] args) {

        //1.取得File对象 C:\Users\HASEE\Desktop

        File file = new File(File.separator + "C:" + File.separator +
                "Users" + File.separator + "j2726" + File.separator + "Desktop"
                + File.separator + "0.jpg");

        //保证文件存在，且一定是文件
        if(file.exists() && file.isFile()) {
            System.out.println(file.length()/1024 + "kb");
            System.out.print("创建时间为: ");
            Date date = new Date(file.lastModified());
            SimpleDateFormat simpleDateFormat =
                    new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            System.out.println(simpleDateFormat.format(date));
        }
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815200719664.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190815200607723.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

### 2. 字节流

**java.io包分为两类：输入流与输出流**

**字节流(byte)** ：原生操作，无需转换；可以处理文本文件、图像、音乐、视频等资源`InputStream`,`OutputStream`

**字符流(char)** ： 经过处理后的操作；只用于处理中文文本`Reader`,`Writer`



**流模型的操作流程：**

1. 取得终端对象

2. 根据终端对象取得输入输出流

3. 根据输入输出流进行数据的读取与写入

4. 关闭流(I/O操作属于资源处理，所有的资源处理（IO操作、数据库操作、网络操作]在使用后一定要关闭）

   > -----JDK1.7追加了AutoCloseble[自动关闭接口]，此接口必须使用 **try-catch** 代码块

   

#### 2.1 字节输出流 OutputStream

`public abstract class OutputStream implements Cloneable,Flushable`

核心方法：

- 将给定的字节数组全部输出

  `write(byte b[]) `

- 将给定的字节数组以 off 位置开始输出 len 长度后停止输出
      `write (byte b[],int off, int len) `

- 输出单个字节
      `abstract void write(int b) `

> 使用注意：
> ***
> 使用 OutputStream **输出数据**时，若指定的文件不存在，FileOutputStream 会自动创建文件(父路径存在的前提下，不包含创建目录)
>***
> 使用 OutputStream **输出内容**时，默认是文件内容的覆盖操作；
>
> 若要进行文件的追加，使用如下的构造方法：`public FileOutputStream(File file,boolean append)`

**将程序中的内容输出到文件中**

为了阅读代码的相对直观，所以将文件之间的分隔符没有用**separator**来替换，不同的操作系统可自己更改
```java
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-13 08:51
 * @Description:字节的输出流OutputStream
 */
public class OutputStreamDemo {
    public static void main(String[] args) throws Exception {
        //1.取得终端对象
        File file = new File("C:\\Users\\j2726\\Desktop\\Test_javaIO.txt");

        //保证文件存在
        if(!file.getParentFile().exists()) {//保证父目录文件存在
            file.getParentFile().mkdirs();  //创建多个父级目录
        }

        //2.取得指定文件的输出流

        //无论文件是否存在,都会自动创建文件;
        //若需要进行内容的追加而非覆盖,则需要添加 true
        OutputStream outputStream = new FileOutputStream(file,true);

        //3.进行数据的输出
        String str = "Hello java!";
        outputStream.write(str.getBytes());//将内容变为字节数组

        //追加内容
        String strAdd = "\nStick on!";
        outputStream.write(strAdd.getBytes());
        //4.关闭流
        outputStream.close();
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019081914523832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819145303261.png)

#### 2.2 字节输入流 InputStream

   **public abstract class InputStream implements Cloneable**

核心方法:

- 读取一个字节
`publicint read(){}`

- 将读取的内容放入字节数组中，返回此次执行的长度
 `public int read(byte b[]) {}`   

返回值有如下三种情况：

**a. 返回 b.length**：

未读取的数据 > 存放的缓存区的大小 ----->  返回字节数组大小

**b. 返回大于0的整数,此整数小于 b.length**

未读取的数据 < 存放的缓存区大小 -----> 返回剩余数据大小

**c. 返回 ==-1==<终止标记>**

此时数据已经读取完毕

**读取文件中的内容到程序中**

相比于*将程序中的内容输出到文件中*的代码，区别仅仅是第三部进行数据的**读取/输出**不同而已

```java
import java.io.*;


public class InputStreamDemo {
    public static void main(String[] args) throws  Exception {
        //1.取得终端对象
        File file = new File("C:\\Users\\j2726\\Desktop\\Test_javaIO.txt");
        //保证文件存在
        if(!file.getParentFile().exists()) { //保证父目录文件存在
            file.getParentFile().mkdirs(); //创建多个父级目录
        }

        //2.取得相应输入流
        InputStream inputStream = new FileInputStream(file);

        //3.进行数据的读取
        byte[] data = new byte[1024];
        int len = inputStream.read(data);
        System.out.println(new String(data,0,len));

        //4.关闭流
        inputStream.close();
    }
}
```
读取刚才通过程序创建的文件 Test_javaIO.txt 的内容
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819150342974.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
> 那么，问题来了：在进行 IO操作时，我们都要关闭流，如果忘记关了怎么办？
> <br>
> 答案是：不好办，还是要记得自己关
> - 如果不关闭的话，那么这个IO资源就会被他一直占用，这样别人想用就没有办法用了，所以这回造成资源浪费.
> - 该资源还是被占用着,没有释放,如果再来一个请求,就会抛出 RuntimeExcetion.

虽然前面提到说
>-----JDK1.7追加了AutoCloseble[自动关闭接口]，此接口必须使用 **try-catch** 代码块

但是，若果你仅仅是单纯的文本创建，输入输出，还是忘了它吧.用它还得单独放到 **try-catch** 代

码块中，否则是不会生效的...

```java
class CloseTest implements AutoCloseable {
    @Override
    public void close() throws Exception {
        System.out.println("自动调用close方法");
    }
    public void fun() {
        System.out.println("显示调用");
    }
}

public  class AutoCloseableTest {
    public static void main(String[] args) {
        // AutoCloseable接口必须在try代码块中才会自动调用close()
        try(CloseTest closeTest = new CloseTest()) {
            closeTest.fun();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
我们通过`InputStream,OutputStream`对文件进行了输入输出，那么，我们结合起来，实现一个文件拷贝

#### 2.3 文件拷贝Demo

**向IDEA传递路径参数，将A文件中的内容拷贝到B文件**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819153649664.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70) 	
```java
import java.io.*;
/**
 * @Author: Mr.Q
 * @Date: 2019-08-13 10:09
 * @Description: A文件中的内容拷贝到B文件
 */
public class CopyFileSource {
    public static void main(String[] args) throws IOException {
        //源文件
        File sourceFile = new File("C:\\Users\\j2726\\Desktop\\0.jpg");
        //目标文件
        File targetFile = new File("G:\\javaTest\\test.jpg");
        InputStream in = new FileInputStream(sourceFile);
        OutputStream out = new FileOutputStream(targetFile);
        //文件拷贝
        copyFileSource(in,out);
    }
    private static void copyFileSource(InputStream in, OutputStream out) throws IOException {
        System.out.println("文件拷贝开始...");
        long start = System.currentTimeMillis();
        int len = 0;
        //缓存区边读边写
        byte [] data = new byte [4096];
        while ((len = in.read(data)) != -1) {//返回 -1<终止标记>此时数据已经读取完毕
            out.write(data, 0, len);
        }
        long end = System.currentTimeMillis();
        System.out.println("文件拷贝结束！\n共耗时" + (end - start) + "ms");
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819153714730.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819153812420.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
### 3. 字符流

#### 3.1 字符输出流 writer

writer 字符流 : 适合处理中文     **public void write(String str)**

输入流与输出流在 **字节流** 和 **字符流** 上的差别

<kbd>差别就是：一个农夫三拳，是大自然的搬运工;另一个是康湿氟，经过添加矿物质处理</kbd>

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819155102350.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819155124449.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
- **字符流**在字节流的基础上做了处理，先将数据默认放在缓存区中，调用`close()`**先输出缓存区的内容，再关闭流**；<font color=#FF7F50 size=3>若未关闭流，则数据不会输出</font>
- **字节流**不关闭流也可以输出，因为数据不放在缓存区
- 在不关闭字符流的基础上输出缓存区数据，使用`flush()`强制刷新缓存区输出，但流并未关闭

**输出内容到文件中**
```java
import java.io.*;
/**
 * @Author: Mr.Q
 * @Date: 2019-08-13 11:13
 * @Description:字符输出流Writer
 */
public class WriterTest {
    public static void main(String[] args) throws IOException {
        File file = new File("C:\\Users\\j2726\\Desktop\\Test_javaIO.txt");
        Writer writer = new FileWriter(file);
        writer.write("字符输出流Writer\n");
        writer.close();
        //writer.flush();  //不关闭流，强制刷新缓存区输出数据
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019081916130812.png)
字符流和字节流的操作步骤是完全一样的
#### 3.2 字符输入流Reader

与字节输入流除了单位不同之外都一致（ 1字符 = 2字节）

### 4. 字符编码

**GBK** ： 国标码（包括简体与繁体）

**GB2312** : 简体中文编码

**UTF-8** : 支持所有语言，国际通用

**UNICODE** : java发明的16进制编码，支持所有语言

**ISO-8859-1** : 浏览器默认编码（不支持中文）

> 产生乱码的原因：
>
> 1. 编解码不一致 (99%)
> 2. 数据不完整（1%）

- 编解码不一致

```java
import java.io.File;
import java.io.IOException;

// 编解码不一致
public class CharTest {
    public static void main(String[] args) throws IOException {
       String fileName = new String("测试".getBytes(),"GBK");
        File file = new File("C:\\Users\\j2726\\Desktop\\" + fileName);
        file.createNewFile();
    }
}
```

- 数据不完整

```java
//2.数据不完整
public class CharTest {
    public static void main(String[] args) throws IOException {
        String str = "数据不完整导致乱码";
        byte[] array = str.getBytes();
        //UTF-8一个汉字为三个字节; GBK编码为两个字节
        System.out.println(new String(array,0,5));
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019081916160574.png)
系统信息输出   `System.getProperties().list(System.out);`

> 我自己遇到乱码问题有很多，刚开始用文本编辑器写代码时没有加`-encoding UTF-8`出现过乱码，还有启动 Tomcat 时日志文件乱码，还有访问浏览器出现的乱码问题
> 还有C语言的 **烫烫烫**
### 5. 转换流

**字节流 -----> 字符流**

- `OutputStreamWriter` : 将字节输出流变为字符输出流
- `InputStreamReader` :   将字节输入流变为字符输入流



### 6. 内存流
之前所有的操作都是针对于文件进行的IO处理.   除了文件之外，IO的操作也可以发生在内存之中，这种流称之为**内存操作流**


1. 字节内存流 : `ByteArrayInputStream`、`ByteArrayOutputStream`
2. 字符内存流 : `CharArrayReader`、`CharArrayWriter`

**通过内存流来实现大小写的转换**

```java
import java.io.*;

public class LowerToUpper {
    public static void main(String[] args) throws IOException {
        String str = "iqqcode";
        //使用指定的字符集将字符串编码为byte序列，并将结果存储到一个新的byte数组中
        InputStream in = new ByteArrayInputStream(str.getBytes());
        OutputStream out = new ByteArrayOutputStream();
        int len = 0;
        while ((len = in.read()) != -1) {
            out.write(Character.toUpperCase(len));
        }
        System.out.println(out);
        in.close();
        out.close();
    }
}
```
我们可以看到，将 iqqcode 装换为了 IQQCODE
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819164048407.png)

### 7. 打印流
打印流解决的就是OutputStream的设计缺陷，属于OutputStream功能的加强版。如果操作的不是二
进制数据，只是想通过程序向终端目标输出信息的话，OutputStream不是很方便，其缺点有两个：
> 1. 所有的数据必须转换为字节数组
> 2. 如果要输出的是 int、double 等类型就不方便了


打印流设计的主要目的是为了解决 OutputStream 的设计问题，其本质不会脱离 OutputStream，仅仅是对`OutputStream`做了二次封装而已

- `PrintStream`
- `PrintWriter`

打印流采用的是**装饰设计模式**，基于抽象类的设计模式

**装饰模式：** 核心类依然是某个类的方法，基于此类做了二次包装，使其支持的功能更多，使用更方便而已

**系统输出：** 显示器

`System.out`（系统输出）(实际上就是打印流 **PrintStream** 对象

`System.err`（标准错误输出）也是打印流对象

`System.out.println();`可以输出任意类型的原因就是有很多重载函数

<img src = "https://img-blog.csdnimg.cn/20190819154818286.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "35%">

**系统输入：** 键盘

`System.in`: 从键盘输入，直接是 **InputStream** 的对象，没有任何包装

**自定义实现简单的打印流输出到文件**

```java
import java.io.*;
import java.util.Scanner;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-16 08:32
 * @Description:自己实现简单的打印流
 *
 * 除了String之外支持其他类型的输出
 * String ---> byte
 * boolean,int,double,float ---> String ---> byte
 */
 
class MyPrint {
    //最终调用的是write
    private OutputStream out;

    public MyPrint(OutputStream out) {
        this.out = out;
    }
    //对write()进行包装
    public void print(String str) throws IOException {
        out.write(str.getBytes());
    }
    public void println(String str) throws IOException {
        this.print(str + "\n");
    }
    public void print(double data) throws IOException {
        this.print(String.valueOf(data));
    }
    public void println(double data) throws IOException {
        this.print(data + "\n");
    }
    public void close() throws IOException {
        this.out.close();
    }

}

public class MyPrintStream {
    public static void main(String[] args) throws IOException {
        File file = new File(File.separator + "C:" + File.separator +
                "Users" + File.separator + "j2726" 
                + File.separator + "Desktop" + File.separator +"javaIO.php");
        MyPrint myPrint = new MyPrint(new FileOutputStream(file));
        myPrint.println("Hello,IO");
        myPrint.println(3.1415926);
        myPrint.print("哈哈哈哈哈");
    }
}
```
<img src  = "https://img-blog.csdnimg.cn/20190819170044725.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70" width = "60%">

### 8. Scanner
BufferedReader 类属于一个缓冲的输入流，而且是一个字符流的操作对象。在java中对于缓冲流也分为两类：字节缓冲流(BufferedInputStream)、字符缓冲流(BufferedReader）

打印流解决的是OutputStream类的缺陷，BufferedReader解决的是InputStream类的缺陷。而Scanner解决的是BufferedReader类的缺陷(替换了BufferedReader类)

**Scanner类中常用方法**

`java.util.Scanner`

- `boolean hasNextXxx()` : 判断是否有指定类型数据输入
- `nextXxx()` : 取得指定类型的数据
- `public Scanner useDelimiter(Pattern pattern)` : 定义分隔符
- `public Scanner(InputStream source)` : 构造方法

```java
        //输入到文件中
        File file = new File("C:\Users\Java" + "Test.java");
        Scanner input = new Scanner(new FileInputStream(file)); 
        System.out.println("Please enter Date of birth:");
        String str = input.nextLine();
        if(input.hasNext("\\d{4}-\\d{2}-\\d{2}")) {
            
        }else {
            System.err.println("Enter having error!");
        }
```
在程序中，如果我们想向C语言中的`scanf()`那样等待用户从键盘输入，用`Scanner`即可：

```java
Scanner input = new Scanner(System.in);
String str = input.nextLint(); //输入字符串，回车结束输入
int num = input.nextInt();输入数字
```


### 9. 序列化

**序列化** ：将内存中保存的对象转换为二进制输出

在 java中实现序列化使用`java.io.Serializable`，只要实现了 **Serializable** 接口，就具备序列化的能力

Serializable interface 称为**标记接口**(无任何方法)

**public class ObjectOutputStream extends OutputStream**

- `ObjectOutputStream` : 将对象序列化输出（将对象变成二进制流输出）
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819171503120.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)

1. 指定要输入的端

```java
public ObjectOutputStream(OutputStream out)
```

2. 将指定对象变为二进制流

```java
public final void writeObject(Object obj)
```



- `ObjectInputStream` ： 将对象反序列化输入

根据指定的输入端将对象反序列化

```java
 public final Object readObject()
```

**transient**

`Serializable`默认会将所有的属性全部进行序列化，若某些属性值不想被序列化保存，使用`transient`修饰此属性即可.

**序列化**

```java
import java.io.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-16 11:04
 * @Description:
 */
class TestSerializable implements Serializable {
    private transient Integer age;
    private String name;

    public TestSerializable(Integer age, String name) {
        this.age = age;
        this.name = name;
    }

    @Override
    public String toString() {
        return "TestSerializable{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }
}
public class Serialization {
    public static void main(String[] args) throws Exception {
        TestSerializable msg = new TestSerializable(20,"Mr.Q");
        File file = new File("C:\\Users\\j2726\\Desktop\\" + "Serialization");
        ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(file));
        out.writeObject(msg);
        out.close();
    }
}
```
name被序列化
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819172036963.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)
**反序列化**

```java
import java.io.*;

/**
 * @Author: Mr.Q
 * @Date: 2019-08-16 11:04
 * @Description:
 */
public class DeSerialization {
    public static void main(String[] args) throws Exception {
        File file = new File("C:\\Users\\j2726\\Desktop\\" + "Serialization");
        ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
        Object test = in.readObject();
        System.out.println(test);
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190819172304221.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzIzMjk1NQ==,size_16,color_FFFFFF,t_70)


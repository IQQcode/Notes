java I/O ---打印流和System

一、常用字符编码

1. GBK、GB2312：表示的是国标编码，GBK包含简体中文和繁体中文，而GB2312只包含简体中文。

2. UNICODE编码：java提供的16进制编码，可以描述世界上任意的文字信息，但是编码进制数太高，
编码体积较大

3. ISO8859-1：国际通用编码，浏览器·默认编码

4. UTF编码：相当于结合了UNICODE、ISO8859-1，常用的就是UTF-8编码形式。

二、乱码(编解码不一致，数据丢失)

//读取java运行属性：

public class PrintStreamAndSystem {
    public static void main(String[] args) throws  Exception {
        System.getProperties().list(System.out);
    }
}




三、内存操作流

内存流也分为两类：
1. 字节内存流:ByteArrayInputStream、ByteArrayOutputStream
2. 字符内存流:CharArrayReader、CharArrayWriter

    将指定的字节数组内容存放到内存中：
             public ByteArrayInputStream(byte buf[])

             public ByteArrayOutputStream()


    核心类依然是某个类(ByteArrayOutputStream提供的write())的功能，
    但是为了得到更好的操作效果，让其支持的功能更多一些，使用装饰类(PrintStream)
    
    装饰类设计模式
    优点：很容易更换装饰类来达到不同的操作效果；
    缺点：造成类结构复杂；




四、System类对 I/O的支持

标准输出(显示屏)：System.out
标准输入(键盘)：  System.in
错误输出： System.err

1.系统输出
    out输出的是希望用户能看到的内容(黑色)
    err输出的是不希望用户看到的内容(红色)


2.系统输入

  System.in 是InputStream的直接对象

***两种输入流

--BufferedReader, BufferedInputStream
      readline()直接读取一行输入，默认以回车换行


---java.util.Scanner; 

hasNextXX():判断是否有指定类型的数据输入
nextXX():获取指定类型数据
useDelimiter("指定分隔符") 


java I/O 掌握的类： File，PrintStream,Scanner
                  装饰类设计模式  

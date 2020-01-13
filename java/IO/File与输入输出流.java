javaIo--BIO(阻塞式IO)

java.io;

       掌握核心的五个类：
       File,OutputStream,InputStream,Reader,Writer

       一个接口：Serializable

一、File文件操作类

1.File类是唯一一个与文件本身操作有关的程序类(创建、删除、取得信息)
   产生File对象：
       public File(String pathname):根据文件的绝对路径产生file对象
       public File(URI uri):根据网络产生File对象

       if(file.exists()) {  //判断是否存在
            file.delete();  //删除
        }else {
            file.createNewFile();  //创建文件
        }

     文件分隔符： File.separator

2.目录操作
    取得父路径的File对象：   public File getParentFile() { }
    取得父路径的目录    ：   public String getParent() { }

    创建多级父路径(一次性创建多级不存在的父路径)    public boolean mkdirs()


3.取得文件信息

    判断File对象是否是文件： public boolean isFile()

             取得文件大小： public long length()  --字节为单位
             
                 取得上次修改时间： public long lastModified()

    判断File对象是否是文件夹： public  boolean isDirectory()

    列出一个目录的全部组成： public File[] listFiles()





二、字节流与字符流
                   java.io包分为俩类：输入流与输出流

字节流(byte)：原生操作，无需转换；可以处理文本文件、图像、音乐、视频等资源
InputStream,OutputStream


字符流(char)： 经过处理后的操作；只用于处理中文文本
Reader,Writer


*** 流模型的操作流程：
1).取得终端对象
2).根据终端对象取得输入输出流
3).根据输入输出流进行数据的读取与写入
4).关闭流(I/O操作属于资源处理，所有的资源处理[IO操作、数据库操作、网络操作]在使用后一定要关闭 )

            -----JDK1.7追加了AutoCloseble[自动关闭接口]，此接口必须使用try-catch代码块


1.字节的输出流 OutputStream
    public abstract class OutputStream implements Cloneable,Flushable//抽象类，使用时必须先实例化子类

核心方法：

将给定的字节数组全部输出--
    public void write(byte b[]) throws IOException

将给定的字节数组以off位置开始输出len长度后停止输出---
    public void write (byte b[],int off, int len) throws IOException

输出单个字节----
    public abstract void write(int b) throws IOException


***使用OutputStream 输出数据时，若指定的文件不存在，FileOutputStream会自动创建文件
(父路径存在的前提下，不包含创建目录)

***使用OutputStream输出内容时，默认是文件内容的覆盖操作；
    若要进行文件的追加，使用如下的构造方法：
    public FileOutputStream(File file,boolean append)



2.字节输入流InputStream
   public abstract class InputStream implements Cloneable

   public int read(byte b[]) throws IOException---将读取的内容放入字节数组中

返回值有如下三种情况：

a.返回 b.length：未读取的数据 > 存放的缓存区的大小，返回字节数组大小

b.返回大于0的整数,此整数小于b.length
未读取的数据 < 存放的缓存区大小；返回剩余数据大小

c.返回-1<终止标记>  
                 ---此时数据已经读取完毕





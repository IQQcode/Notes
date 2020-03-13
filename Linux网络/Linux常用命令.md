# linux常用命令大全

- [**学习linux命令**](https://mp.weixin.qq.com/s?src=11&timestamp=1583504947&ver=2200&signature=BqR6czOCxLmyg*3qXaGb6g2qV9IG68WWZW5DJOHzv2Dx5R6QgSD2oKXJGPZQx2WYGsFjE4BmxgRAj5-BTVfToyVtv8iSDQ3aUqiQHX*FEXaOxkdj*KiK0LeA5iwMX9Gn&new=1)
- [**linux常用命令大全**](https://www.cnblogs.com/360minitao/p/11696537.html)

## 系统信息

arch 显示机器的处理器架构(1) 

uname -m 显示机器的处理器架构(2) 

uname -r 显示正在使用的内核版本 

dmidecode -q 显示硬件系统部件 - (SMBIOS / DMI) 

hdparm -i /dev/hda 罗列一个磁盘的架构特性 

hdparm -tT /dev/sda 在磁盘上执行测试性读取操作 

cat /proc/cpuinfo 显示CPU info的信息 

cat /proc/interrupts 显示中断 

cat /proc/meminfo 校验内存使用 

cat /proc/swaps 显示哪些swap被使用 

cat /proc/version 显示内核的版本 

cat /proc/net/dev 显示网络适配器及统计 

cat /proc/mounts 显示已加载的文件系统 

lsusb -tv 显示 USB 设备 

date 显示系统日期 

## 关机 (系统的关机、重启以及登出 )

shutdown -h now 关闭系统(1) 

init 0 关闭系统(2) 

telinit 0 关闭系统(3) 

shutdown -c 取消按预定时间关闭系统 

shutdown -r now 重启(1) 

reboot 重启(2) 

logout 注销 

## 文件和目录

cd /home 进入  '/ home' 目录' 

cd .. 返回上一级目录 

cd ../.. 返回上两级目录 

cd 进入个人的主目录 

cd ~user1 进入个人的主目录 

cd - 返回上次所在的目录 

pwd 显示工作路径 

ls 查看目录中的文件 

ls -F 查看目录中的文件 

ls -l 显示文件和目录的详细资料 

ls -a 显示隐藏文件 

ls *[0-9]* 显示包含数字的文件名和目录名 

tree 显示文件和目录由根目录开始的树形结构(1) 

lstree 显示文件和目录由根目录开始的树形结构(2) 

mkdir dir1 创建一个叫做 'dir1' 的目录' 

mkdir dir1 dir2 同时创建两个目录 

mkdir -p /tmp/dir1/dir2 创建一个目录树 

rm -f file1 删除一个叫做 'file1' 的文件' 

rmdir dir1 删除一个叫做 'dir1' 的目录' 

rm -rf dir1 删除一个叫做 'dir1' 的目录并同时删除其内容 

rm -rf dir1 dir2 同时删除两个目录及它们的内容 

mv dir1 new_dir 重命名/移动 一个目录 

cp file1 file2 复制一个文件 

cp dir/* . 复制一个目录下的所有文件到当前工作目录 

cp -a /tmp/dir1 . 复制一个目录到当前工作目录 

cp -a dir1 dir2 复制一个目录 

touch 创建一个新的文件

echo 写文件

echo “hello”   显示到屏幕上，输出一个字符串

echo “hello” > a.txt    把字符串写入文件 a.txt中写入内容 “hello”

## 打包和压缩文件

bunzip2 file1.bz2 解压一个叫做 'file1.bz2'的文件 

bzip2 file1 压缩一个叫做 'file1' 的文件 

gunzip file1.gz 解压一个叫做 'file1.gz'的文件 

gzip file1 压缩一个叫做 'file1'的文件 

gzip -9 file1 最大程度压缩 

rar a file1.rar test_file 创建一个叫做 'file1.rar' 的包 

rar a file1.rar file1 file2 dir1 同时压缩 'file1', 'file2' 以及目录 'dir1' 

rar x file1.rar 解压rar包 

unrar x file1.rar 解压rar包 

tar -cvf archive.tar file1 创建一个非压缩的 tarball 

tar -cvf archive.tar file1 file2 dir1 创建一个包含了 'file1', 'file2' 以及 'dir1'的档案文件 

tar -tf archive.tar 显示一个包中的内容 

tar -xvf archive.tar 释放一个包 

tar -xvf archive.tar -C /tmp 将压缩包释放到 /tmp目录下 

tar -cvfj archive.tar.bz2 dir1 创建一个bzip2格式的压缩包 

tar -xvfj archive.tar.bz2 解压一个bzip2格式的压缩包 

tar -cvfz archive.tar.gz dir1 创建一个gzip格式的压缩包 

tar -xvfz archive.tar.gz 解压一个gzip格式的压缩包 

zip file1.zip file1 创建一个zip格式的压缩包 

zip -r file1.zip file1 file2 dir1 将几个文件和目录同时压缩成一个zip格式的压缩包 

unzip file1.zip 解压一个zip格式压缩包 

## 浏览文件内容

cat file1 从第一个字节开始正向查看文件的内容 

tac file1 从最后一行开始反向查看一个文件的内容 

more file1 查看一个长文件的内容 

less file1 类似于 'more' 命令，但是它允许在文件中和正向操作一样的反向操作 

head -2 file1 查看一个文件的前两行 

tail -2 file1 查看一个文件的最后两行 

tail -f /var/log/messages 实时查看被添加到一个文件中的内容 



## 网络 - （以太网和WIFI无线）

ifconfig eth0 显示一个以太网卡的配置 

ifup eth0 启用一个 'eth0' 网络设备 

ifdown eth0 禁用一个 'eth0' 网络设备 

ifconfig eth0 192.168.1.1 netmask 255.255.255.0 控制IP地址 

ifconfig eth0 promisc 设置 'eth0' 成混杂模式以嗅探数据包 (sniffing) 

dhclient eth0 以dhcp模式启用 'eth0' 

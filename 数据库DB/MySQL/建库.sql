use master
--判断当前数据库是否存在
if exists (select* from sysdatabases where name='TestSchool')

--创建数据库
create database TestSchool
on primary
(
 name = 'TestSchool_data',
 size = 3mb,
 maxsize = 100mb,
 filename = 'F:\SQL DateBase\TestSchool_data.maf' --全路径
)

log on  --创建日志文件
(
 name = 'TestSchool_log',
 size = 3mb,
 --maxsize = 100mb,
 filename = 'F:\SQL DateBase\TestSchool_log.ldf' 
)

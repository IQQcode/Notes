
-创建数据表

--语法：
--create table表名
--（
--字段名称字段类型字段特征（是否非空标识列默认值主键唯一键check约束），
--字段名称字段类型字段特征（是否非空标识列默认值主键唯一键check约束）
--）

--创建老师表Teacher Id、Name、Gender、Age、Salary、Birthday 

use TestSchool 
if exists（select*from sysobjects where name='Teacher'）
    drop table Teacher
     go

create table Teacher 
   (  Id int identity（1，1）primary key，--设置标识列identity（标识种子，标识增量）
     Name nvarchar not null，--not null标记字段不能为nul值
     Gender bit not null， 
     Aae int check（age>0and agec=100）not null
     Salary money，--当一个字段可以为nul的时候可以不写也可以写null
     Birthday datetime not null default"2000-9-9）
    );
    
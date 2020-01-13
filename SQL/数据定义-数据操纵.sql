
 **表中插入数据

1.单行数据 + 全列插入 --不跟任何的表名，直接全列插入，values赋上全列的字段，缺省的为null
INSERT INTO Students VALUES (100, 10000, '唐三藏', NULL); 



2.多行数据 + 指定列插入 --表名后面添加列名(指定列批量插入)
INSERT INTO students (id, sn, name) VALUES(102, 20001, '曹孟德'),(103, 20002, '孙仲谋');



3.由于主键(primary key)或者唯一键(unique)对应的值已经存在而导致插入失败

--更新插入(在源数据上修改)：
INSERT INTO students (id, sn, name) VALUES (100, 10010,'张三')
ON DUPLICATE KEY UPDATE sn = 10010, name = '张三';

--替换插入(删除冲突数据，重新插入)
REPLACE INTO students (sn, name) VALUES (20001, '阿三');



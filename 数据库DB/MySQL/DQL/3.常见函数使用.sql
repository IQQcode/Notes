单行函数

##-----------------------------------单行函数-------------------------------------##

## 一、字符串函数===================

# 1.length-字符串长度
select LENGTH('iqqcode');

# 2.concat-字符串拼接
select CONCAT(last_name,'_',first_name) 姓名 from employees;

# 3.upper-lower大小写
select CONCAT(UPPER(last_name),'_',LOWER(first_name)) AS name from employees;

# 4.substr-截取字符<索引从1开始> 
select SUBSTR(str FROM pos FOR len);
# 姓名中-前两个字符大写，其他字符小写然后用拼接，显示出来
SELECT
	CONCAT(
		UPPER(
		SUBSTR( last_name, 1, 2 )),
		'_',
		LOWER(
		SUBSTR( last_name, 3 ))
	) AS NAME 
FROM
	employees;
	
# 5.instr-返回子串<第一次>出现的索引，如果找不到返回
select INSTR(str,substr)
select INSTR('iqqcode_好好学习_iqqcode','学习') AS 输出;

# 6.去空格
# trim()去掉字符串左右两边的空格(或指定字符)
# ltrim()去掉字符串左边的空格(或指定字符)
# rtrim()去掉字符串右边的空格(或指定字符)
select TRIM([remstr FROM] str)
select TRIM('a' FROM 'aaaaaaaaaa_好好aa学习_aaaaaaa') AS 输出;

# 7.replace字符串替换
select replace('iqqcdoe爱学习', '学习' , 'Mr.Q') AS 输出;



## 二、数学函数

# 1. rounds四舍五入
select ROUND(-1.55) AS Result;
select ROUND(-1.554, 2) AS Result;

# 2. 向上取整cell、向下取整floor
select CEIL(3.1415);

# 3.随机数rand
select RAND();


## 三、日期函数====================

# str_to_date字符串转日期
#查询入职日期为1992--4-3的员工信息
SELECT
	* 
FROM
	employees 
WHERE
	hiredate = STR_TO_DATE( '4-3 1992', '%c-%d %Y' );
	
# date_format---将日期转为字符串
#查询有奖金的员工名和入职日期(xx月/xx日 xxxx年)
SELECT
	last_name,
	DATE_FORMAT( hiredate, '%m月/%d日 %y年' ) AS 入职日期 
FROM
	employees 
WHERE
	commission_pct IS NOT NULL;
	
	

## 四、流程函数====================

# 1. if...els
select if(10 < 5, '是','否') As Result;

# 2.case
#如果工资>20000，显示A级别
#如果工资>15000，显示B级别
#如果工资>10000，显示C级别
#否则，显示D级别
SELECT salary,
CASE 
	WHEN salary > 20000 THEN 'A'
	WHEN salary > 15000 THEN 'B'
	WHEN salary > 10000 THEN 'C'
	ELSE 'D'
END AS 工资级别
from employees;
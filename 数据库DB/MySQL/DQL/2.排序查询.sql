排序查询

##----------------------------------排序查询---------------------------------##
 
## ORDER BY
 
# 查询员工信息，要求工资从高到低排序
 SELECT * from employees ORDER BY salary desc;
 
# 查询部门编号>=90的员工信息，按入职时间的先后进行排序
 select * from employees where employee_id >= 90 ORDER BY hiredate;
 
# 按年薪的高低显示员工的信息和年薪【按表达式排序】
SELECT
	*,
	salary *12*(1 + IFNULL( commission_pct, 0 )) AS 年薪
FROM
	employees 
WHERE
	employee_id >= 90 
ORDER BY
	salary *12*(1 + IFNULL( commission_pct, 0 )) desc;
 
# 按年薪的高低显示员工的信息和年薪【按别名排序】
SELECT
	*,
	salary *12*(1 + IFNULL( commission_pct, 0 )) AS 年薪
FROM
	employees 
WHERE
	employee_id >= 90 
ORDER BY
	年薪 desc;
 
# 按姓名的长度显示员工的姓名和工资【按函数排序】
SELECT
	LENGTH(last_name) AS 姓名长度,
	last_name,
	salary
FROM
	employees 
ORDER BY
	姓名长度 desc;
 
# 查询员工信息，要求先按工资升序，再按员工编号降序【按多个字段排序】
SELECT
	*
FROM
	employees 
ORDER BY
	salary desc,employee_id desc;

连接查询--多表查询


##------------------------------- 连接查询<多表查询> ----------------------------##


#------------------------        一、【内连接】          ------------------------#
I. 等值连接

# 1.查询女神名和对应的男神名
use girls;
select name,boyName
from beauty,boys
where beauty.boyfriend_id = boys.id;

# 2.查询员工名和对应的部门名
use myemployees;
select last_name,department_name
from employees,departments
where employees.department_id = departments.department_id;


# 3.为表起别名，防止不同表的相同字段名产生歧义

[如果为表起了别名, 则查询的字段就不能使用原来的表名去限定, 表的顺序可以交换]

##查询员工名、工种号、工种名
select last_name, e.job_id, job_title
from employees AS e, jobs AS j
where e.job_id = j.job_id;


# 4. 查询有奖金的员工名、部门名
select last_name, department_name, commission_pct
from employees AS e, departments AS d
WHERE e.department_id = d.department_id
AND e.commission_pct IS NOT NULL;


# 5.查询城市名中第二个字符为o的部门名和城市名
SELECT department_name,city
FROM departments AS d,locations AS l
WHERE d.location_id = l.location_id
AND city like '_o%';

# 6.查询每个城市的部门个数
SELECT COUNT(*) count, city
FROM departments AS d,locations AS l
WHERE d.location_id = l.location_id
GROUP BY city;

# 7.查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name,d.manager_id,MIN(salary)
from employees AS e, departments AS d
WHERE e.department_id = d.department_id
AND commission_pct IS NOT NULL
GROUP BY department_name,d.manager_id;
  
# [SQL-99]
SELECT department_name,d.manager_id,MIN(salary)
from employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
WHERE commission_pct IS NOT NULL
GROUP BY department_name,d.manager_id;

## 8.查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）

### a.查询每个部门的员工个数
SELECT count(*) AS 员工数,department_name
from employees AS e
INNER JOIN departments As d
ON e.department_id = d.department_id
GROUP BY department_name

###b.在a的基础上进行筛选, 员工个数 > 3 并按个数降序
SELECT count(*),department_name
from employees AS e
INNER JOIN departments As d
ON e.department_id = d.department_id
GROUP BY department_name
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;


# 三表查询

## 9.查询员工名、部门名和所在的-s开头的城市
SELECT last_name,department_name,city
from employees AS e, departments AS d,locations AS l
where e.employee_id = d.department_id
AND d.location_id = l.location_id
AND city like 's%'
ORDER BY department_name desc;

## [SQL-99]
SELECT last_name,department_name,city
from employees AS e
INNER JOIN departments AS d  ON e.employee_id = d.department_id
INNER JOIN locations AS l    ON d.location_id = l.location_id
where city like 's%'
ORDER BY department_name desc;




II. 非等值连接(where的条件不再是等于)

# 查询员工-工资的对应级别及-每个级别的个数>20(降序排序)
SELECT salary, grade_level, count(*)
from employees e, job_grades g
where e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY grade_level
HAVING count(*) > 20
ORDER BY grade_level desc;

# [SQL-99]
SELECT salary, grade_level, count(*)
from employees e
INNER JOIN job_grades g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY grade_level
HAVING count(*) > 20
ORDER BY grade_level desc;




III.自连接(一张表当做多张表使用)
# 查询员工名和他对应的上级的名称
SELECT e.last_name AS 员工名, m.last_name AS 领导名
FROM employees e, employees m
where e.manager_id = m.employee_id;

# [SQL-99]
SELECT e.last_name AS 员工名, m.last_name AS 领导名
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.employee_id;




#----------------------       二、【SQL99-外连接】          ------------------------#

【应用场景】: 用于查询一个表中有,另一个表没有的记录

【语法】:
            SELECT 查询列表
			FROM  表1  别名 [连接类型]
			join  表2  别名
			on  连接条件
			[where  筛选条件]
			[group by  分组 ]
			[having 筛选条件]
			[order by排序列表]
			
【分类】:
           - 内连接: inner
		   
		   - 外连接:
		            左外: left  [outer]
					右外: right [outer]
					全外: full  [outer]
					
           - 交叉连接: cross


【特点】:
           1. 外连接的查询结果为主表中的所有记录
		          --如果从表中有和它匹配的，则显示匹配的值
				  --如果从表中没有和它匹配的，则显示null
				  
				  [外连接查询结果 = 内连接结果 + 主表中有而从表没有的记录]
				  
		   2. 左外连接, left  join左边的是主表
		      右外连接，right join右边的是主表
			  
		   3. 左外和右外交换两个表的顺序, 可以实现同样的效果

---------------------------[左外连接 <-相互转化-> 右外连接]--------------------------


I-II. 左外连接 & 右外连接

# 1. 查询男女CP组合
use girls

[左外连接]写法:
select g.name, b.boyName
from beauty AS g
LEFT OUTER JOIN boys AS b 
ON g.boyfriend_id = b.id;

[右外连接]写法:(调换主表位置即可)
select g.name, b.boyName
from boys AS b  
RIGHT OUTER JOIN beauty AS g
ON g.boyfriend_id = b.id;



# 2.查询哪个部门没有员工
use myemployees;

[左外]
select department_name, e.employee_id
from departments AS d
left outer join employees AS e
ON e.employee_id = d.department_id
where e.employee_id is NULL;

[右外]
select department_name, e.employee_id
from employees AS e
RIGHT outer join departments AS d
ON e.employee_id = d.department_id
where e.employee_id is NULL;




III. 全外连接





#------------------------        三、【交叉连接】        ------------------------#

就是[SQL-92]语法的笛卡尔积


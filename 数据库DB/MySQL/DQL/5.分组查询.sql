分组查询条件删选
1. 分组前筛选(where);
2. 分组后对结果集再次筛选(having)


##-------------------------------- <分组查询> ----------------------------------##
 
 /** 查询整个公司下，不同部门的，平均工资 **/

【语法】:
           select 分组函数, 列(必须出现在GROUP BY后面)
		   FROM Table
		   [where 筛选条件]
		   GROUP BY 分组的列表
		   having(MIN,MAX,COUNT...)
		   [ORDER BY 子句]
		   
【注意】:   查询列表必须特殊，要求是分组函数(sum...count)和GROUP BY后的出现的字段

一、简单分组查询

### 1.查询每个工种的最高工资
SELECT MAX(salary),job_id
from employees
GROUP BY job_id;

### 2. 查询每个位置上的部门个数
SELECT COUNT(*),location_id
from departments
GROUP BY location_id;



二、复合分组查询

I.【分组前筛选】

# 1. 查询邮箱中包含a字符的，每个部门的平均工资
SELECT AVG(salary),department_id
from employees
where email like '%a%'
GROUP BY department_id;
 
# 2. 查询有奖金的每个领导手下员工的最高工资
SELECT MAX(salary),manager_id
from employees
where commission_pct IS NOT NULL
GROUP BY manager_id;


II.【分组后筛选<having>---在新生成的结果集上筛选】

## 案例1: 查询哪个部门的员工个数 > 2

# ①查询每个部门的员工个数
SELECT count(*),department_id
from employees
GROUP BY department_id; 

# ②根据①的结果集进行筛选，查询哪个部门的员工个数 > 2 
SELECT count(*),department_id
from employees
GROUP BY department_id
HAVING count(*) > 2;



##案例2: 查询每个工种有奖金的员工的最高工资 > 12000的工种编号和最高工资

# ①查询每工种有奖金的员工的最高工资
SELECT Max(salary),job_id
from employees 
WHERE commission_pct IS NOT NULL
GROUP BY job_id;

# ②根据①结果继续筛选，最高工资>12000
SELECT Max(salary),job_id
from employees 
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000;



## 案例3：查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资

# ①查询领导编号>102的每个领导手下的最低工资
SELECT MIN(salary), manager_id
FROM employees
where manager_id >= 102
GROUP BY manager_id;

# ②根据①结果继续筛选，最低工资>5000;以及其最低工资
SELECT MIN(salary), manager_id
FROM employees
where manager_id > 102
GROUP BY manager_id
HAVING MIN(salary) > 5000;




三、按多个字段分组 + 添加排序

【优先级】:   WHERE > GROUP BY > HAVING > ORDER BY > LIMIT

## 查询-每个部门-每个工种的员工的-平均工资>10000，并且按平均工资的高低显示
SELECT AVG(salary) AS avg,job_id,department_id
from employees
WHERE department_id
GROUP BY job_id,department_id
HAVING avg > 10000
ORDER BY AVG(salary) DESC;
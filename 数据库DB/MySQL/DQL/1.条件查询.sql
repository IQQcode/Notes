条件查询

select * from employees;

## CONCAT合并列名---------------
select CONCAT(first_name,last_name) as 姓名 from employees; 

## IFNULL判断为空---------------
# 查询奖金是否为空，为空加为0
select IFNULL(commission_pct,0) as 奖金, commission_pct from employees;


##--------------------------------条件查询 where----------------------------------## 


## 一、条件表达式查询--------------

#查询工资大于12000的员工
select *  from employees where salary > 12000;

#查询部门编号不等于90号的员工名和部门编号
select last_name,department_id from employees where department_id <> 90;


## 二、逻辑表达式筛选---------------

#查询工资在10000到20000之间的员工名、工资以及奖金
SELECT
    employee_id,
    salary,
    salary * commission_pct 
FROM
    employees 
WHERE
    salary >= 10000 and salary <= 20000;

#查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT
    *
FROM
    employees 
WHERE
    not(department_id >= 90 and department_id <= 110) or salary >= 15000;
    
## 三、模糊查询--------------

### 1.like==============

#查询员工名中包含字符a的员工信息
select last_name from employees where last_name like '%a%';

#查询员工名中第三个字符为n，第五个字符为l的员工名和工资
SELECT
    last_name,
    salary 
FROM
    employees 
WHERE
    last_name LIKE '__n_l%'

#查询员工名中第二个字符为的员工名
SELECT
    last_name 
FROM
    employees 
WHERE
    last_name LIKE '_$_%' ESCAPE '$';
    
select last_name from employees where last_name like '_\_%';

### 2. between-and===========

#查询员工编号在100到120之间的员工信息
select * from employees where employee_id BETWEEN 100 AND 120;

### 3.in=====================

#查询员工的工种编号是工IT_ROG、AD_VP、 AD_PRES中的一个员工名和工种编号
SELECT
    last_name,
    job_id 
FROM
    employees 
WHERE
    job_id IN ( 'IT_PROT', 'AD_VP', 'AD_PRES' );
    
#憨憨写法   
SELECT last_name,job_id FROM employees WHERE job_id = 'IT_PROT' or job_id ='AD_VP'or job_id = 'AD_PRES';

### 4.IS NOT NULL================

#查询没有奖金的员工名
SELECT
    last_name,
    commission_pct
FROM
    employees 
WHERE
    commission_pct IS NULL;
    
### 4.安全等于<=>   ================

#查询没有奖金的员工名
SELECT last_name,commission_pct FROM employees WHERE commission_pct <=> NULL;

#查询工资为12000的员工信息
SELECT * FROM employees WHERE salary <=> 12000;




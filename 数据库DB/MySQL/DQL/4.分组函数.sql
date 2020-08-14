分组函数

##-------------------------------分组函数,忽略NULL值-----------------------------##

#与分组函数使用的必须是[group by]后的字段#

# 综合使用
select SUM(salary) from employees;
select AVG(salary) from employees;
select MIN(salary) from employees;
select MAX(salary) from employees;
select COUNT(salary) from employees;

select SUM(salary) 和, AVG(salary) 平均, MIN(salary) 最大,MAX(salary) 最小,COUNT(salary) 总计 from employees;



# 和distinct搭配去重
## 去重求和
select sum(DISTINCT salary),sum(salary) from employees;
## 去重计数
select Count(DISTINCT salary),Count(salary) from employees;




# COUNT函数
## 加一列常量值，统计共有多少行
select COUNT(*) from employees;
select COUNT(1) from employees;

/*【效率】
 *   MYISAM存储引擎下，COUNT(*)的效率高
 *   INNODB存储引擎下，COUNT(*)COUNT(1)的效率差不多，比COUNT(字段)要高
 *	    - 字段要判断是否为空
 */
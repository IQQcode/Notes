*********************************       select       ************************************

--in关键字；查询和10号部门的工作相同的雇员的名字，岗位，工资，部门号，但是不包含10自己的
 select job from emp where deptno =10;
 
 select ename,sal,job,deptno
 from emp
 where job in( select job from emp where deptno =10) and deptno<>10;
 
 
 
--all关键字: 显示工资比部门30的所有员工的工资高的员工的姓名、工资和部门号

select ename,sal,deptno
from emp
where sal > (select max(sal) from emp where deptno = 30);

    --查询结果多行用all
select ename,sal,deptno
from emp
where sal > all(select sal from emp where deptno = 30);  --大于最高工资就是大于所有的工资



--any关键字；显示工资比部门30的任意员工的工资高的员工的姓名、工资和部门号

select ename,sal depeno
from emp 
where sal > any(select sal from emp where deptno = 30);


--查询和SMITH的部门和岗位完全相同的所有雇员，不含SMITH本人

select ename
from emp
where job = (select job from emp where ename='SMITH')
and  deptno = (select job from emp where ename='SMITH')
and ename<> 'SMITH';

select ename 
from EMP 
where (deptno, job)=(select deptno, job from EMP where ename='SMITH') 
and ename <> 'SMITH';


--查找每个部门工资最高的人的姓名、工资、部门、最高工资

select deptno dt,max(sal) ms from emp group by depeno;  --查找每个部门工资最高的人

select emp.ename, emp.sal, emp.deptno, max(sal) ms
from EMP,(select max(sal) ms, deptno from emp group by deptno) tmp
where EMP.deptno = tmp.deptno and EMP.sal = tmp.ms;


--显示每个部门的信息（部门名，编号，地址）和人员数量

select count(*) total,deptno from emp group by depeno; --每个部门的人员数量

select dept.dname,dept.deptno,dept.loc,tmp.total
from dept,(select count(*) total,deptno from emp group by deptno) tmp
where dept.deptno = tmp.deptno;

            --**笛卡尔积写
select dept.dname,dept.deptno,dept.loc,count(*)
from dept,emp
where dept.deptno = emp.deptno
group by dept.dname,dept.deptno,dept.loc;  --group by 的语法规则，select中出现的字段名必须都在			


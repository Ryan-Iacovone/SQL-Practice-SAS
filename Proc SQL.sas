%let root =/home/u49757561/my_shared_file_links/data;
libname orion "&root/Orion";
title "Orion Sales Data"; 

proc sql outobs = 20;
select employee_id, last_name, first_name, job_title, 
		hire_date format MMDDYY10., salary format dollar8.
	.1*salary as Bonus
	from Orion.sales;
quit;

proc sql;
select distinct job_titles
	from Orion.sales;
quit;

proc sql outobs = 20;
select mployee_id, last_name, first_name, job_title, 
	hire_date format=MMDDYY10., 
	salary=format dollar8., 'base salary'
	.1*salary as Bonus format=dollar8. 'End of Year Bonus',
	salary + calculated bonus as compensation 'total Compensastion'
	from Orion.sales;
quit;

***********************************************************;
*  Activity 7.03                                          *;
*    1) Define aliases for STORM_SUMMARY and              *;
*       STORM_BASINCODES in the FROM clause.              *;
*    2) Use one table alias to qualify Basin in the       *;
*       SELECT clause.                                    *;
*    3) Complete the ON expression to match rows when     *;
*       Basin is equal in the two tables. Use the table   *;
*       aliases to qualify Basin in the expression. Run   *;
*       the step.                                         *;
***********************************************************;
*  Syntax                                                 *;
*     FROM table1 AS alias1 INNER JOIN table2 AS alias2   *;
*     ON alias1.column = alias2.column                    *;
***********************************************************;

proc sql;
select Season, Name, s.Basin, BasinName, MaxWindMPH 
    from pg1.storm_summary as s 
    	inner join pg1.storm_basincodes as b
		on upcase(s.basin) = b.basin  
    order by Season desc, Name;
quit;

proc sql outobs=20;
select order_id, customer_id, employee_id
	from orion.orders;
select employee_id, name, job_title
	from orion.employees,
	left join orion.employees E on O.employee_id;
	order by employee_id;
run;

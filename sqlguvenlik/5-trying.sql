use AdventureWorks;
select * from HumanResources.Employee -- bu çalışacak
select * from Sales.SalesOrderHeader -- bu çalışmayacak
update HumanResources.Department Set Name = 'Test' where DepartmentID = 1; -- bu da çalışmayacak

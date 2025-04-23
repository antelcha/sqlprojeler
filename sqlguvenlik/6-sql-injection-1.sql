USE AdventureWorks;
GO

IF OBJECT_ID('dbo.usp_GetEmployeeByJobTitle_Vulnerable', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetEmployeeByJobTitle_Vulnerable;
GO

CREATE PROCEDURE dbo.usp_GetEmployeeByJobTitle_Vulnerable
    @JobTitle NVARCHAR(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = N'SELECT BusinessEntityID, NationalIDNumber, LoginID, JobTitle
                 FROM HumanResources.Employee
                 WHERE JobTitle LIKE ''%' + @JobTitle + '%''';
    PRINT N'Çalıştırılacak Güvensiz Sorgu: ' + @SQL;
    EXEC sp_executesql @SQL;
END
GO

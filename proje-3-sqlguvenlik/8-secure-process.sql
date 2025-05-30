
USE AdventureWorks;
GO

IF OBJECT_ID('dbo.usp_GetEmployeeByJobTitle_Secure', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetEmployeeByJobTitle_Secure;
GO

CREATE PROCEDURE dbo.usp_GetEmployeeByJobTitle_Secure
    @JobTitle NVARCHAR(50)
AS
BEGIN
    SELECT BusinessEntityID, NationalIDNumber, LoginID, JobTitle
    FROM HumanResources.Employee
    WHERE JobTitle LIKE '%' + @JobTitle + '%';
END
GO



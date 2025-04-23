EXEC dbo.usp_GetEmployeeByJobTitle_Vulnerable @JobTitle = N'Manager'; -- normal kullanım
EXEC dbo.usp_GetEmployeeByJobTitle_Vulnerable @JobTitle = N'Manager'' or 1 = 1--'; -- sızma kullanımı
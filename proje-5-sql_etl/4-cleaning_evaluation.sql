-- Temizlik işleminin değerlendirilmesi

SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ListPrice < 0 THEN 1 ELSE 0 END) AS BozukFiyatSayisi,
    SUM(CASE WHEN SellStartDate < '2000-01-01' THEN 1 ELSE 0 END) AS GecersizTarihSayisi
FROM Production.Product_Staging; 

SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ListPrice < 0 THEN 1 ELSE 0 END) AS BozukFiyatSayisi,
    SUM(CASE WHEN SellStartDate < '2000-01-01' THEN 1 ELSE 0 END) AS GecersizTarihSayisi
FROM Production.Product_Cleaned; 
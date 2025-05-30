-- Verilerin temizlenmesi (Bozuk verilerin dışlanması)

SELECT *
INTO Production.Product_Cleaned
FROM Production.Product_Staging
WHERE ListPrice >= 0
  AND SellStartDate >= '2000-01-01'; 
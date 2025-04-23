-- Veri bozulması (Simülasyon amaçlı)

-- Fiyat alanı negatif değerlere çekildi
UPDATE Production.Product_Staging
SET ListPrice = -99.99
WHERE ProductID % 10 = 0;

-- Satış başlangıç tarihi anlamını yitirecek şekilde geriye alındı
UPDATE Production.Product_Staging
SET SellStartDate = '1900-01-01'
WHERE ProductID % 4 = 0; 
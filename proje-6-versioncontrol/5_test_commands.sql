USE VersionControlDB;
GO

-- 1. Versiyon geçmişini kontrol et
EXEC sp_GetVersionHistory;

-- 2. Şema değişikliklerini kontrol et
SELECT TOP 10 * 
FROM SchemaChanges 
ORDER BY ChangeDate DESC;

-- 3. Test verisi ekle
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber)
VALUES 
    ('Ahmet', 'Yılmaz', 'ahmet@email.com', '5551234567'),
    ('Ayşe', 'Demir', 'ayse@email.com', '5557654321');

-- 4. Test siparişleri ekle
INSERT INTO Orders (CustomerID, TotalAmount)
VALUES 
    (1, 150.50),
    (1, 75.25),
    (2, 225.00);

-- 5. Test sorguları
-- 5.1. Müşteri ve sipariş bilgilerini birleştirerek göster
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    c.PhoneNumber,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.PhoneNumber;

-- 5.2. Son 5 siparişi göster
SELECT TOP 5
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC;

-- 6. Geri alma testi (DİKKAT: Bu komutu sadece test ortamında çalıştırın!)
-- EXEC sp_RollbackDatabase '1.0.0';

-- 7. Hata durumu testi
BEGIN TRY
    -- Kasıtlı hata oluştur (duplicate primary key)
    INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
    VALUES (1, 'Test', 'User', 'test@email.com');
END TRY
BEGIN CATCH
    PRINT 'Beklenen hata oluştu: ' + ERROR_MESSAGE();
END CATCH;

-- 8. Versiyon kontrolü
DECLARE @CurrentVersion VARCHAR(20);
SELECT TOP 1 @CurrentVersion = VersionNumber
FROM DatabaseVersion
ORDER BY VersionID DESC;

IF @CurrentVersion = '2.0.0'
    PRINT 'Versiyon yükseltme başarılı: ' + @CurrentVersion;
ELSE
    PRINT 'Versiyon yükseltme başarısız. Mevcut versiyon: ' + @CurrentVersion; 
USE AdventureWorks;
GO

-- 1. AĞIR SORGU BULMA
-- Önce yavaş çalışan bir sorgu oluşturalım/bulalım

-- Execution plan'ı aktif et
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- YAVAŞ SORGU ÖRNEĞİ
-- Bu sorgu müşteri siparişlerini ve ürün detaylarını getiriyor
PRINT '========== OPTİMİZASYON ÖNCESİ ==========';
GO

SELECT 
    c.CustomerID,
    c.PersonID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    soh.SalesOrderID,
    soh.OrderDate,
    sod.ProductID,
    pr.Name AS ProductName,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal
FROM Sales.Customer c
    INNER JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    INNER JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE 
    soh.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
    AND pr.Name LIKE '%Bike%'
ORDER BY soh.OrderDate DESC;
GO

-- 2. PERFORMANS ANALİZİ
-- Execution plan'a bak ve hangi tablolarda scan yapıldığını kontrol et

-- Missing index önerilerini kontrol et
SELECT 
    OBJECT_NAME(mid.object_id) AS TableName,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,
    migs.avg_user_impact
FROM sys.dm_db_missing_index_details mid
JOIN sys.dm_db_missing_index_groups mig ON mid.index_handle = mig.index_handle
JOIN sys.dm_db_missing_index_group_stats migs ON mig.index_group_handle = migs.group_handle
WHERE mid.database_id = DB_ID()
ORDER BY migs.avg_user_impact DESC;
GO

-- 3. İNDEX OLUŞTURMA
PRINT '========== İNDEXLER OLUŞTURULUYOR ==========';
GO

-- OrderDate için index
CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_OrderDate
ON Sales.SalesOrderHeader (OrderDate)
INCLUDE (CustomerID, SalesOrderID);
GO

-- Product Name için index
CREATE NONCLUSTERED INDEX IX_Product_Name
ON Production.Product (Name)
INCLUDE (ProductID);
GO

-- SalesOrderDetail için covering index
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_SalesOrderID_ProductID
ON Sales.SalesOrderDetail (SalesOrderID, ProductID)
INCLUDE (OrderQty, UnitPrice, LineTotal);
GO

-- 4. OPTİMİZASYON SONRASI TEST
PRINT '========== OPTİMİZASYON SONRASI ==========';
GO

-- Aynı sorguyu tekrar çalıştır
SELECT 
    c.CustomerID,
    c.PersonID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    soh.SalesOrderID,
    soh.OrderDate,
    sod.ProductID,
    pr.Name AS ProductName,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal
FROM Sales.Customer c
    INNER JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    INNER JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE 
    soh.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
    AND pr.Name LIKE '%Bike%'
ORDER BY soh.OrderDate DESC;
GO

-- 5. KARŞILAŞTIRMA
PRINT '========== PERFORMANS KARŞILAŞTIRMASI ==========';
GO

-- İstatistikleri kapat
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- Oluşturulan indexleri göster
SELECT 
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.type_desc AS IndexType
FROM sys.indexes i
WHERE i.name IN (
    'IX_SalesOrderHeader_OrderDate',
    'IX_Product_Name',
    'IX_SalesOrderDetail_SalesOrderID_ProductID'
);
GO

-- TEMİZLİK (İsteğe bağlı - indexleri silmek için)
/*
DROP INDEX IX_SalesOrderHeader_OrderDate ON Sales.SalesOrderHeader;
DROP INDEX IX_Product_Name ON Production.Product;
DROP INDEX IX_SalesOrderDetail_SalesOrderID_ProductID ON Sales.SalesOrderDetail;
*/ 
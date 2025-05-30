USE VersionControlDB;
GO

-- Versiyon 2.0.0'a yükseltme örneği
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Yeni sürüm için değişiklikleri uygula
    -- 1. Customers tablosuna yeni kolonlar ekle
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Customers') AND name = 'PhoneNumber')
    BEGIN
        ALTER TABLE Customers
        ADD PhoneNumber NVARCHAR(20);
    END

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Customers') AND name = 'CreatedDate')
    BEGIN
        ALTER TABLE Customers
        ADD CreatedDate DATETIME DEFAULT GETDATE();
    END
    
    -- 2. Orders tablosunu oluştur (eğer yoksa)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
    BEGIN
        CREATE TABLE Orders (
            OrderID INT PRIMARY KEY IDENTITY(1,1),
            CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
            OrderDate DATETIME DEFAULT GETDATE(),
            TotalAmount DECIMAL(18,2)
        );
    END
    
    -- Versiyon bilgisini güncelle
    EXEC sp_UpgradeDatabase '2.0.0', 'Added phone number to Customers and created Orders table';
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    -- Hata bilgisini kaydet
    INSERT INTO DatabaseVersion (VersionNumber, Description, Status)
    VALUES ('2.0.0', 'Upgrade failed: ' + ERROR_MESSAGE(), 'Failed');
    
    RAISERROR (N'Versiyon yukseltme islemi basarisiz oldu.', 16, 1);
END CATCH; 
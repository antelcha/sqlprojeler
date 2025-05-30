USE TestDB;
GO

-- Customers tablosu kontrolü ve oluşturma
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
BEGIN
    CREATE TABLE Customers (
        CustomerID INT PRIMARY KEY IDENTITY(1,1),
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        Email NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE()
    );
    PRINT 'Customers tablosu oluşturuldu.';
END
ELSE
BEGIN
    PRINT 'Customers tablosu zaten mevcut.';
END
GO

-- BackupHistory tablosu kontrolü ve oluşturma
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BackupHistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE BackupHistory (
        BackupID INT PRIMARY KEY IDENTITY(1,1),
        DatabaseName NVARCHAR(100),
        BackupType NVARCHAR(50),
        BackupStartTime DATETIME,
        BackupEndTime DATETIME,
        BackupStatus NVARCHAR(50),
        BackupSizeKB BIGINT,
        BackupLocation NVARCHAR(500)
    );
    PRINT 'BackupHistory tablosu oluşturuldu.';
END
ELSE
BEGIN
    PRINT 'BackupHistory tablosu zaten mevcut.';
END
GO

-- Örnek veri ekleme
IF NOT EXISTS (SELECT TOP 1 * FROM Customers)
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email)
    VALUES 
        ('John', 'Doe', 'john@example.com'),
        ('Jane', 'Smith', 'jane@example.com'),
        ('Mike', 'Johnson', 'mike@example.com');
    PRINT 'Örnek müşteri verileri eklendi.';
END
ELSE
BEGIN
    PRINT 'Customers tablosunda zaten veri mevcut.';
END
GO 
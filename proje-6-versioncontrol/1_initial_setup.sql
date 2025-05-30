-- Veritabanı oluşturma
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'VersionControlDB')
BEGIN
    CREATE DATABASE VersionControlDB;
END
GO

USE VersionControlDB;
GO

-- Versiyon kontrol tablosu
BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DatabaseVersion')
    BEGIN
        CREATE TABLE DatabaseVersion (
            VersionID INT PRIMARY KEY IDENTITY(1,1),
            VersionNumber VARCHAR(20) NOT NULL,
            AppliedDate DATETIME DEFAULT GETDATE(),
            Description NVARCHAR(500),
            Status VARCHAR(50)
        );

        -- İlk versiyon kaydı
        INSERT INTO DatabaseVersion (VersionNumber, Description, Status)
        VALUES ('1.0.0', 'Initial database version', 'Completed');
    END

    -- Örnek tablo oluşturma
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
    BEGIN
        CREATE TABLE Customers (
            CustomerID INT PRIMARY KEY IDENTITY(1,1),
            FirstName NVARCHAR(50),
            LastName NVARCHAR(50),
            Email NVARCHAR(100)
        );
    END
COMMIT TRANSACTION; 
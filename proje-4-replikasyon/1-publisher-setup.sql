-- 1. PUBLISHER SETUP (sql_server_1'de çalıştırılacak)
USE master;
GO

-- Mevcut distributor yapılandırmasını temizle
EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1;
GO

-- Replikasyon dağıtıcısını yapılandır
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

-- Distribution database'ini oluştur
USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'distribution')
BEGIN
    -- Local distributor olarak ayarla
    EXEC sp_adddistributor 
        @distributor = @@SERVERNAME,
        @password = 'Distr!bution2024';

    -- Distribution database'ini oluştur
    EXEC sp_adddistributiondb 
        @database = 'distribution';
END
GO

-- Test veritabanını oluştur
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'TestDB')
    DROP DATABASE TestDB;
GO
CREATE DATABASE TestDB;
GO

-- Veritabanını replikasyon için hazırla
USE TestDB;
GO
EXEC sp_replicationdboption 
    @dbname = 'TestDB',
    @optname = 'publish',
    @value = 'true';
GO

-- Test tablosunu oluştur
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- Yayıncı sunucuyu yapılandır
USE [TestDB]
GO
EXEC sp_addpublication 
    @publication = 'CustomerPublication',
    @description = 'Publication for Customers table',
    @sync_method = 'concurrent',
    @retention = 0,
    @allow_push = 'true',
    @allow_pull = 'true',
    @allow_anonymous = 'true',
    @enabled_for_internet = 'false',
    @snapshot_in_defaultfolder = 'true';
GO

-- Yayın için makale ekle
USE [TestDB]
GO
EXEC sp_addarticle 
    @publication = 'CustomerPublication',
    @article = 'Customers',
    @source_owner = 'dbo',
    @source_object = 'Customers',
    @type = 'logbased',
    @description = 'Customer table article',
    @creation_script = NULL,
    @pre_creation_cmd = 'drop',
    @schema_option = 0x000000000803509D,
    @identityrangemanagementoption = 'manual',
    @destination_table = 'Customers',
    @destination_owner = 'dbo';
GO

-- Snapshot Agent'ı başlat
EXEC sp_startpublication_snapshot @publication = 'CustomerPublication';
GO 
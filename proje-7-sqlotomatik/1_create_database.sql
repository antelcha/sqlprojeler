-- Veritabanı kontrolü ve oluşturma
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TestDB')
BEGIN
    CREATE DATABASE TestDB;
    PRINT 'TestDB veritabanı oluşturuldu.';
END
ELSE
BEGIN
    PRINT 'TestDB veritabanı zaten mevcut.';
END
GO 
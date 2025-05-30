-- 3. TEST REPLICATION

-- Publisher'da çalıştırılacak (sql_server_1):
USE TestDB;
GO

-- Test verisi ekle
INSERT INTO Customers (CustomerName) 
VALUES 
    ('Test Customer 1'),
    ('Test Customer 2'),
    ('Test Customer 3');
GO

-- Eklenen verileri kontrol et
SELECT * FROM Customers;
GO

-- Subscriber'da çalıştırılacak (sql_server_2):
USE TestDB;
GO

-- Replike olan verileri kontrol et
SELECT * FROM Customers;
GO

-- Not: Veriler subscriber'a replike olduysa, 
-- publisher'da eklenen verilerin aynısını subscriber'da görmelisiniz. 
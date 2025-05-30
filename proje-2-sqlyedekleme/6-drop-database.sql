-- Önce aktif bağlantıları kapatmak gerekebilir
ALTER DATABASE AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- Sonra veritabanını silebiliriz
DROP DATABASE AdventureWorks; 
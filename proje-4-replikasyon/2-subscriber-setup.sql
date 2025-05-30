-- 2. SUBSCRIBER SETUP (sql_server_2'de çalıştırılacak)
USE master;
GO

-- Eğer varsa subscriber database'i sil
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'TestDB')
    DROP DATABASE TestDB;
GO

-- Subscriber database'i oluştur
CREATE DATABASE TestDB;
GO

-- Subscription oluştur
USE TestDB;
GO

-- Push subscription oluştur
EXEC sp_addsubscription 
    @publication = 'CustomerPublication',
    @subscriber = 'sql_server_2',
    @destination_db = 'TestDB',
    @subscription_type = 'Push',
    @sync_type = 'automatic',
    @article = 'all',
    @update_mode = 'read only';
GO

-- Push subscription agent'ı oluştur
EXEC sp_addpushsubscription_agent 
    @publication = 'CustomerPublication',
    @subscriber = 'sql_server_2',
    @subscriber_db = 'TestDB',
    @subscriber_security_mode = 0,
    @subscriber_login = 'sa',
    @subscriber_password = 'yourStrong(!)Password';
GO 
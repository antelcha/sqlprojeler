USE TestDB;
GO

-- Manuel yedek alma testi
PRINT 'Manuel yedekleme testi başlatılıyor...';
EXEC sp_CreateBackup 
    @DatabaseName = 'TestDB',
    @BackupPath = '/var/opt/mssql/backup/';
GO

-- Yeni test verisi ekleme
PRINT 'Test verileri ekleniyor...';
INSERT INTO Customers (FirstName, LastName, Email)
VALUES 
    ('Sarah', 'Wilson', 'sarah@example.com'),
    ('Robert', 'Brown', 'robert@example.com');
GO

-- Job durumunu kontrol et
USE msdb;
GO

PRINT 'Job durumu kontrol ediliyor...';
SELECT 
    j.name AS 'Job Name',
    CASE j.enabled 
        WHEN 1 THEN 'Enabled'
        ELSE 'Disabled'
    END AS 'Job Status',
    CASE 
        WHEN jh.run_date IS NOT NULL AND jh.run_time IS NOT NULL
        THEN CONVERT(DATETIME, 
            CAST(jh.run_date AS CHAR(8)) + ' ' + 
            STUFF(STUFF(RIGHT('000000' + CAST(jh.run_time AS VARCHAR(6)), 6), 5, 0, ':'), 3, 0, ':'))
    END AS 'Last Run Time',
    CASE jh.run_status
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Succeeded'
        WHEN 2 THEN 'Retry'
        WHEN 3 THEN 'Canceled'
        WHEN 4 THEN 'In Progress'
    END AS 'Last Run Status'
FROM 
    msdb.dbo.sysjobs j
    LEFT JOIN (
        SELECT 
            job_id,
            run_date,
            run_time,
            run_status
        FROM msdb.dbo.sysjobhistory
        WHERE step_id = 0
    ) jh ON j.job_id = jh.job_id
WHERE 
    j.name = 'Daily_Database_Backup';
GO

-- Yedekleme geçmişini kontrol et
USE TestDB;
GO

PRINT 'Yedekleme geçmişi kontrol ediliyor...';
SELECT 
    DatabaseName,
    BackupType,
    FORMAT(BackupStartTime, 'yyyy-MM-dd HH:mm:ss') as StartTime,
    FORMAT(BackupEndTime, 'yyyy-MM-dd HH:mm:ss') as EndTime,
    DurationMinutes,
    BackupStatus,
    CAST(BackupSizeMB AS DECIMAL(10,2)) as BackupSizeMB,
    BackupLocation
FROM vw_BackupReport
ORDER BY BackupStartTime DESC;
GO

-- Job'ı manuel olarak çalıştır
USE msdb;
GO

PRINT 'Job manuel olarak çalıştırılıyor...';
EXEC msdb.dbo.sp_start_job N'Daily_Database_Backup';
GO

-- 10 saniye bekle
WAITFOR DELAY '00:00:10';
GO

-- Son durumu tekrar kontrol et
PRINT 'Son durum kontrol ediliyor...';
USE TestDB;
GO

SELECT TOP 5 * FROM vw_BackupReport
ORDER BY BackupStartTime DESC;
GO 
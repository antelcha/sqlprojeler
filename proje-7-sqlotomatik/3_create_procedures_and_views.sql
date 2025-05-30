USE TestDB;
GO

-- Yedekleme prosedürü kontrolü ve oluşturma
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CreateBackup]') AND type in (N'P'))
BEGIN
    DROP PROCEDURE [dbo].[sp_CreateBackup];
    PRINT 'Eski sp_CreateBackup prosedürü silindi.';
END
GO

CREATE PROCEDURE sp_CreateBackup
    @DatabaseName NVARCHAR(100),
    @BackupPath NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BackupFileName NVARCHAR(1000)
    DECLARE @StartTime DATETIME
    DECLARE @SQL NVARCHAR(MAX)

    SET @StartTime = GETDATE()
    SET @BackupFileName = @BackupPath + @DatabaseName + '_' + 
        REPLACE(CONVERT(VARCHAR, @StartTime, 112) + REPLACE(CONVERT(VARCHAR, @StartTime, 108), ':', ''), ' ', '_') + '.bak'

    BEGIN TRY
        -- Yedekleme başlangıç kaydı
        INSERT INTO BackupHistory (DatabaseName, BackupType, BackupStartTime, BackupStatus)
        VALUES (@DatabaseName, 'FULL', @StartTime, 'IN_PROGRESS')

        -- Yedekleme komutunu oluştur
        SET @SQL = 'BACKUP DATABASE ' + @DatabaseName + 
                   ' TO DISK = ''' + @BackupFileName + ''''

        -- Yedekleme işlemini gerçekleştir
        EXEC (@SQL)

        -- Yedekleme kaydını güncelle
        UPDATE BackupHistory
        SET BackupEndTime = GETDATE(),
            BackupStatus = 'COMPLETED',
            BackupLocation = @BackupFileName,
            BackupSizeKB = (SELECT size * 8 FROM sys.master_files WHERE database_id = DB_ID(@DatabaseName) AND type_desc = 'ROWS')
        WHERE DatabaseName = @DatabaseName
        AND BackupStartTime = @StartTime

        PRINT 'Yedekleme işlemi başarıyla tamamlandı.';
    END TRY
    BEGIN CATCH
        -- Hata durumunda kaydı güncelle
        UPDATE BackupHistory
        SET BackupEndTime = GETDATE(),
            BackupStatus = 'FAILED'
        WHERE DatabaseName = @DatabaseName
        AND BackupStartTime = @StartTime

        PRINT 'Hata: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO
PRINT 'sp_CreateBackup prosedürü oluşturuldu.';

-- Yedekleme rapor view kontrolü ve oluşturma
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_BackupReport]'))
BEGIN
    DROP VIEW [dbo].[vw_BackupReport];
    PRINT 'Eski vw_BackupReport view silindi.';
END
GO

CREATE VIEW vw_BackupReport
AS
SELECT 
    DatabaseName,
    BackupType,
    BackupStartTime,
    BackupEndTime,
    DATEDIFF(MINUTE, BackupStartTime, BackupEndTime) as DurationMinutes,
    BackupStatus,
    BackupSizeKB / 1024.0 as BackupSizeMB,
    BackupLocation
FROM BackupHistory;
GO
PRINT 'vw_BackupReport view oluşturuldu.'; 
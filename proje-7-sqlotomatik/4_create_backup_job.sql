USE msdb;
GO

-- Job kontrolü ve silme
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Daily_Database_Backup')
BEGIN
    EXEC dbo.sp_delete_job @job_name = N'Daily_Database_Backup';
    PRINT 'Eski Daily_Database_Backup job silindi.';
END
GO

-- Schedule kontrolü ve silme
IF EXISTS (SELECT schedule_id FROM msdb.dbo.sysschedules WHERE name = N'DailyBackupSchedule')
BEGIN
    EXEC dbo.sp_delete_schedule @schedule_name = N'DailyBackupSchedule';
    PRINT 'Eski DailyBackupSchedule schedule silindi.';
END
GO

BEGIN TRY
    -- Job oluştur
    EXEC dbo.sp_add_job
        @job_name = N'Daily_Database_Backup',
        @description = N'Her gün otomatik yedek alma işlemi',
        @enabled = 1;

    -- Job'a adım ekle
    EXEC sp_add_jobstep
        @job_name = N'Daily_Database_Backup',
        @step_name = N'Perform Backup',
        @subsystem = N'TSQL',
        @command = N'EXEC TestDB.dbo.sp_CreateBackup 
                        @DatabaseName = ''TestDB'',
                        @BackupPath = ''/var/opt/mssql/backup/''';

    -- Günlük çalışma planı oluştur
    EXEC dbo.sp_add_schedule
        @schedule_name = N'DailyBackupSchedule',
        @freq_type = 4,  -- Günlük
        @freq_interval = 1,  -- Her gün
        @active_start_time = 000000;  -- Gece yarısı (00:00)

    -- Schedule'ı job'a bağla
    EXEC sp_attach_schedule
        @job_name = N'Daily_Database_Backup',
        @schedule_name = N'DailyBackupSchedule';

    -- Job'ı aktif et
    EXEC dbo.sp_add_jobserver
        @job_name = N'Daily_Database_Backup';

    PRINT 'Daily_Database_Backup job başarıyla oluşturuldu.';
END TRY
BEGIN CATCH
    PRINT 'Hata: ' + ERROR_MESSAGE();
    THROW;
END CATCH
GO 
SELECT 
    database_name,
    backup_start_date,
    backup_finish_date,
    CASE 
        WHEN type = 'D' THEN 'FULL'
        WHEN type = 'I' THEN 'DIFFERENTIAL'
        WHEN type = 'L' THEN 'LOG'
    END AS backup_type,
    physical_device_name
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE database_name = 'AdventureWorks'
ORDER BY backup_finish_date DESC; 
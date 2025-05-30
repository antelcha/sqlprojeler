RESTORE DATABASE AdventureWorks
FROM DISK = '/var/opt/mssql/backup/AdventureWorks_Diff.bak'
WITH NORECOVERY; 
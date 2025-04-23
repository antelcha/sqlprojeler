RESTORE DATABASE AdventureWorks
FROM DISK = '/var/opt/mssql/backup/AdventureWorks_Full.bak'
WITH REPLACE, NORECOVERY; 
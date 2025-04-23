BACKUP DATABASE AdventureWorks
TO DISK = '/var/opt/mssql/backup/AdventureWorks_Diff.bak'
WITH DIFFERENTIAL, INIT; 
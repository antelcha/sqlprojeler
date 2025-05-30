USE VersionControlDB;
GO

-- Veritabanı versiyonunu yükseltme prosedürü
IF NOT EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpgradeDatabase')
BEGIN
    EXEC('CREATE PROCEDURE sp_UpgradeDatabase
        @TargetVersion VARCHAR(20),
        @Description NVARCHAR(500)
    AS
    BEGIN
        SET NOCOUNT ON;
        
        BEGIN TRY
            BEGIN TRANSACTION;
            
            -- Mevcut versiyonu kontrol et
            DECLARE @CurrentVersion VARCHAR(20);
            SELECT TOP 1 @CurrentVersion = VersionNumber
            FROM DatabaseVersion
            ORDER BY VersionID DESC;
            
            IF @CurrentVersion >= @TargetVersion
            BEGIN
                RAISERROR (N''Hedef versiyon mevcut versiyondan kucuk veya esit olamaz.'', 16, 1);
                RETURN;
            END
            
            -- Yeni versiyon kaydı ekle
            INSERT INTO DatabaseVersion (VersionNumber, Description, Status)
            VALUES (@TargetVersion, @Description, ''In Progress'');
            
            -- Burada yükseltme işlemleri gerçekleştirilir
            -- (Örnek: ALTER TABLE, CREATE TABLE vb.)
            
            -- Versiyon durumunu güncelle
            UPDATE DatabaseVersion
            SET Status = ''Completed''
            WHERE VersionNumber = @TargetVersion;
            
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                
            -- Hata durumunu kaydet
            UPDATE DatabaseVersion
            SET Status = ''Failed - '' + ERROR_MESSAGE()
            WHERE VersionNumber = @TargetVersion;
            
            RAISERROR (N''Versiyon yukseltme islemi basarisiz oldu.'', 16, 1);
        END CATCH
    END')
END
GO

-- Veritabanı geri alma prosedürü
IF NOT EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RollbackDatabase')
BEGIN
    EXEC('CREATE PROCEDURE sp_RollbackDatabase
        @TargetVersion VARCHAR(20)
    AS
    BEGIN
        SET NOCOUNT ON;
        
        BEGIN TRY
            BEGIN TRANSACTION;
            
            -- Mevcut versiyonu kontrol et
            DECLARE @CurrentVersion VARCHAR(20);
            SELECT TOP 1 @CurrentVersion = VersionNumber
            FROM DatabaseVersion
            ORDER BY VersionID DESC;
            
            IF @CurrentVersion <= @TargetVersion
            BEGIN
                RAISERROR (N''Geri alma versiyonu mevcut versiyondan buyuk veya esit olamaz.'', 16, 1);
                RETURN;
            END
            
            -- Geri alma işlemi kaydı
            INSERT INTO DatabaseVersion (VersionNumber, Description, Status)
            VALUES (@TargetVersion, ''Rollback from '' + @CurrentVersion, ''In Progress'');
            
            -- Burada geri alma işlemleri gerçekleştirilir
            -- (Örnek: DROP TABLE, ALTER TABLE vb.)
            
            -- Versiyon durumunu güncelle
            UPDATE DatabaseVersion
            SET Status = ''Completed''
            WHERE VersionNumber = @TargetVersion;
            
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                
            -- Hata durumunu kaydet
            UPDATE DatabaseVersion
            SET Status = ''Rollback Failed: '' + ERROR_MESSAGE()
            WHERE VersionNumber = @TargetVersion;
            
            RAISERROR (N''Geri alma islemi basarisiz oldu.'', 16, 1);
        END CATCH
    END')
END
GO

-- Versiyon geçmişini görüntüleme prosedürü
IF NOT EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetVersionHistory')
BEGIN
    EXEC('CREATE PROCEDURE sp_GetVersionHistory
    AS
    BEGIN
        SELECT 
            VersionNumber,
            AppliedDate,
            Description,
            Status
        FROM DatabaseVersion
        ORDER BY VersionID DESC;
    END')
END
GO 
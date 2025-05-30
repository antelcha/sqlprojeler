USE VersionControlDB;
GO

-- Şema değişikliklerini izlemek için tablo oluşturma
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SchemaChanges')
BEGIN
    CREATE TABLE SchemaChanges (
        ChangeID INT PRIMARY KEY IDENTITY(1,1),
        EventType NVARCHAR(100),
        ObjectName NVARCHAR(256),
        ObjectType NVARCHAR(100),
        SQLCommand NVARCHAR(MAX),
        LoginName NVARCHAR(256),
        ChangeDate DATETIME DEFAULT GETDATE()
    );
END
GO

-- DDL Trigger oluşturma
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_TrackSchemaChanges')
BEGIN
    EXEC('CREATE TRIGGER TR_TrackSchemaChanges
    ON DATABASE
    FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
        CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
        CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION,
        CREATE_VIEW, ALTER_VIEW, DROP_VIEW
    AS
    BEGIN
        SET NOCOUNT ON;
        
        DECLARE @EventData XML = EVENTDATA();
        
        INSERT INTO SchemaChanges (
            EventType,
            ObjectName,
            ObjectType,
            SQLCommand,
            LoginName
        )
        VALUES (
            @EventData.value(''(/EVENT_INSTANCE/EventType)[1]'', ''NVARCHAR(100)''),
            @EventData.value(''(/EVENT_INSTANCE/ObjectName)[1]'', ''NVARCHAR(256)''),
            @EventData.value(''(/EVENT_INSTANCE/ObjectType)[1]'', ''NVARCHAR(100)''),
            @EventData.value(''(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]'', ''NVARCHAR(MAX)''),
            @EventData.value(''(/EVENT_INSTANCE/LoginName)[1]'', ''NVARCHAR(256)'')
        );
    END;')
END
GO 
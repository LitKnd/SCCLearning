CREATE TABLE [Warehouse].[Colors_Archive]
(
[ColorID] [int] NOT NULL,
[ColorName] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_Colors_Archive] ON [Warehouse].[Colors_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Warehouse].[Colors]
(
[ColorID] [int] NOT NULL CONSTRAINT [DF_Warehouse_Colors_ColorID] DEFAULT (NEXT VALUE FOR [Sequences].[ColorID]),
[ColorName] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Warehouse_Colors] PRIMARY KEY CLUSTERED  ([ColorID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Warehouse].[Colors_Archive])
)
GO
ALTER TABLE [Warehouse].[Colors] ADD CONSTRAINT [UQ_Warehouse_Colors_ColorName] UNIQUE NONCLUSTERED  ([ColorName]) ON [USERDATA]
GO
ALTER TABLE [Warehouse].[Colors] ADD CONSTRAINT [FK_Warehouse_Colors_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Stock items can (optionally) have colors', 'SCHEMA', N'Warehouse', 'TABLE', N'Colors', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a color within the database', 'SCHEMA', N'Warehouse', 'TABLE', N'Colors', 'COLUMN', N'ColorID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of a color that can be used to describe stock items', 'SCHEMA', N'Warehouse', 'TABLE', N'Colors', 'COLUMN', N'ColorName'
GO

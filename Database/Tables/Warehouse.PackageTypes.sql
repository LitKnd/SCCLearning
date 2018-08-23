CREATE TABLE [Warehouse].[PackageTypes_Archive]
(
[PackageTypeID] [int] NOT NULL,
[PackageTypeName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_PackageTypes_Archive] ON [Warehouse].[PackageTypes_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Warehouse].[PackageTypes]
(
[PackageTypeID] [int] NOT NULL CONSTRAINT [DF_Warehouse_PackageTypes_PackageTypeID] DEFAULT (NEXT VALUE FOR [Sequences].[PackageTypeID]),
[PackageTypeName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Warehouse_PackageTypes] PRIMARY KEY CLUSTERED  ([PackageTypeID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Warehouse].[PackageTypes_Archive])
)
GO
ALTER TABLE [Warehouse].[PackageTypes] ADD CONSTRAINT [UQ_Warehouse_PackageTypes_PackageTypeName] UNIQUE NONCLUSTERED  ([PackageTypeName]) ON [USERDATA]
GO
ALTER TABLE [Warehouse].[PackageTypes] ADD CONSTRAINT [FK_Warehouse_PackageTypes_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Ways that stock items can be packaged (ie: each, box, carton, pallet, kg, etc.', 'SCHEMA', N'Warehouse', 'TABLE', N'PackageTypes', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a package type within the database', 'SCHEMA', N'Warehouse', 'TABLE', N'PackageTypes', 'COLUMN', N'PackageTypeID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of package types that stock items can be purchased in or sold in', 'SCHEMA', N'Warehouse', 'TABLE', N'PackageTypes', 'COLUMN', N'PackageTypeName'
GO

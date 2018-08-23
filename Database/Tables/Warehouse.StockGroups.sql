CREATE TABLE [Warehouse].[StockGroups_Archive]
(
[StockGroupID] [int] NOT NULL,
[StockGroupName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_StockGroups_Archive] ON [Warehouse].[StockGroups_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Warehouse].[StockGroups]
(
[StockGroupID] [int] NOT NULL CONSTRAINT [DF_Warehouse_StockGroups_StockGroupID] DEFAULT (NEXT VALUE FOR [Sequences].[StockGroupID]),
[StockGroupName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Warehouse_StockGroups] PRIMARY KEY CLUSTERED  ([StockGroupID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Warehouse].[StockGroups_Archive])
)
GO
ALTER TABLE [Warehouse].[StockGroups] ADD CONSTRAINT [UQ_Warehouse_StockGroups_StockGroupName] UNIQUE NONCLUSTERED  ([StockGroupName]) ON [USERDATA]
GO
ALTER TABLE [Warehouse].[StockGroups] ADD CONSTRAINT [FK_Warehouse_StockGroups_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Groups for categorizing stock items (ie: novelties, toys, edible novelties, etc.)', 'SCHEMA', N'Warehouse', 'TABLE', N'StockGroups', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a stock group within the database', 'SCHEMA', N'Warehouse', 'TABLE', N'StockGroups', 'COLUMN', N'StockGroupID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of groups used to categorize stock items', 'SCHEMA', N'Warehouse', 'TABLE', N'StockGroups', 'COLUMN', N'StockGroupName'
GO

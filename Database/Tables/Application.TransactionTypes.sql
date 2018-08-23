CREATE TABLE [Application].[TransactionTypes_Archive]
(
[TransactionTypeID] [int] NOT NULL,
[TransactionTypeName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_TransactionTypes_Archive] ON [Application].[TransactionTypes_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Application].[TransactionTypes]
(
[TransactionTypeID] [int] NOT NULL CONSTRAINT [DF_Application_TransactionTypes_TransactionTypeID] DEFAULT (NEXT VALUE FOR [Sequences].[TransactionTypeID]),
[TransactionTypeName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Application_TransactionTypes] PRIMARY KEY CLUSTERED  ([TransactionTypeID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Application].[TransactionTypes_Archive])
)
GO
ALTER TABLE [Application].[TransactionTypes] ADD CONSTRAINT [UQ_Application_TransactionTypes_TransactionTypeName] UNIQUE NONCLUSTERED  ([TransactionTypeName]) ON [USERDATA]
GO
ALTER TABLE [Application].[TransactionTypes] ADD CONSTRAINT [FK_Application_TransactionTypes_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Types of customer, supplier, or stock transactions (ie: invoice, credit note, etc.)', 'SCHEMA', N'Application', 'TABLE', N'TransactionTypes', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a transaction type within the database', 'SCHEMA', N'Application', 'TABLE', N'TransactionTypes', 'COLUMN', N'TransactionTypeID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of the transaction type', 'SCHEMA', N'Application', 'TABLE', N'TransactionTypes', 'COLUMN', N'TransactionTypeName'
GO

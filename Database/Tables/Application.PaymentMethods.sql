CREATE TABLE [Application].[PaymentMethods_Archive]
(
[PaymentMethodID] [int] NOT NULL,
[PaymentMethodName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_PaymentMethods_Archive] ON [Application].[PaymentMethods_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Application].[PaymentMethods]
(
[PaymentMethodID] [int] NOT NULL CONSTRAINT [DF_Application_PaymentMethods_PaymentMethodID] DEFAULT (NEXT VALUE FOR [Sequences].[PaymentMethodID]),
[PaymentMethodName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Application_PaymentMethods] PRIMARY KEY CLUSTERED  ([PaymentMethodID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Application].[PaymentMethods_Archive])
)
GO
ALTER TABLE [Application].[PaymentMethods] ADD CONSTRAINT [UQ_Application_PaymentMethods_PaymentMethodName] UNIQUE NONCLUSTERED  ([PaymentMethodName]) ON [USERDATA]
GO
ALTER TABLE [Application].[PaymentMethods] ADD CONSTRAINT [FK_Application_PaymentMethods_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Ways that payments can be made (ie: cash, check, EFT, etc.', 'SCHEMA', N'Application', 'TABLE', N'PaymentMethods', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a payment type within the database', 'SCHEMA', N'Application', 'TABLE', N'PaymentMethods', 'COLUMN', N'PaymentMethodID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of ways that customers can make payments or that suppliers can be paid', 'SCHEMA', N'Application', 'TABLE', N'PaymentMethods', 'COLUMN', N'PaymentMethodName'
GO

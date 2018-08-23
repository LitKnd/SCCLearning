CREATE TABLE [Application].[DeliveryMethods_Archive]
(
[DeliveryMethodID] [int] NOT NULL,
[DeliveryMethodName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_DeliveryMethods_Archive] ON [Application].[DeliveryMethods_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Application].[DeliveryMethods]
(
[DeliveryMethodID] [int] NOT NULL CONSTRAINT [DF_Application_DeliveryMethods_DeliveryMethodID] DEFAULT (NEXT VALUE FOR [Sequences].[DeliveryMethodID]),
[DeliveryMethodName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Application_DeliveryMethods] PRIMARY KEY CLUSTERED  ([DeliveryMethodID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Application].[DeliveryMethods_Archive])
)
GO
ALTER TABLE [Application].[DeliveryMethods] ADD CONSTRAINT [UQ_Application_DeliveryMethods_DeliveryMethodName] UNIQUE NONCLUSTERED  ([DeliveryMethodName]) ON [USERDATA]
GO
ALTER TABLE [Application].[DeliveryMethods] ADD CONSTRAINT [FK_Application_DeliveryMethods_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Ways that stock items can be delivered (ie: truck/van, post, pickup, courier, etc.', 'SCHEMA', N'Application', 'TABLE', N'DeliveryMethods', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a delivery method within the database', 'SCHEMA', N'Application', 'TABLE', N'DeliveryMethods', 'COLUMN', N'DeliveryMethodID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of methods that can be used for delivery of customer orders', 'SCHEMA', N'Application', 'TABLE', N'DeliveryMethods', 'COLUMN', N'DeliveryMethodName'
GO

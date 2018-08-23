CREATE TABLE [Sales].[CustomerCategories_Archive]
(
[CustomerCategoryID] [int] NOT NULL,
[CustomerCategoryName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_CustomerCategories_Archive] ON [Sales].[CustomerCategories_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Sales].[CustomerCategories]
(
[CustomerCategoryID] [int] NOT NULL CONSTRAINT [DF_Sales_CustomerCategories_CustomerCategoryID] DEFAULT (NEXT VALUE FOR [Sequences].[CustomerCategoryID]),
[CustomerCategoryName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Sales_CustomerCategories] PRIMARY KEY CLUSTERED  ([CustomerCategoryID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Sales].[CustomerCategories_Archive])
)
GO
ALTER TABLE [Sales].[CustomerCategories] ADD CONSTRAINT [UQ_Sales_CustomerCategories_CustomerCategoryName] UNIQUE NONCLUSTERED  ([CustomerCategoryName]) ON [USERDATA]
GO
ALTER TABLE [Sales].[CustomerCategories] ADD CONSTRAINT [FK_Sales_CustomerCategories_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Categories for customers (ie restaurants, cafes, supermarkets, etc.)', 'SCHEMA', N'Sales', 'TABLE', N'CustomerCategories', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a customer category within the database', 'SCHEMA', N'Sales', 'TABLE', N'CustomerCategories', 'COLUMN', N'CustomerCategoryID'
GO
EXEC sp_addextendedproperty N'Description', 'Full name of the category that customers can be assigned to', 'SCHEMA', N'Sales', 'TABLE', N'CustomerCategories', 'COLUMN', N'CustomerCategoryName'
GO

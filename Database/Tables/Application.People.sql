CREATE TABLE [Application].[People_Archive]
(
[PersonID] [int] NOT NULL,
[FullName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[PreferredName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[SearchName] [nvarchar] (101) COLLATE Latin1_General_100_CI_AS NOT NULL,
[IsPermittedToLogon] [bit] NOT NULL,
[LogonName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NULL,
[IsExternalLogonProvider] [bit] NOT NULL,
[HashedPassword] [varbinary] (max) NULL,
[IsSystemUser] [bit] NOT NULL,
[IsEmployee] [bit] NOT NULL,
[IsSalesperson] [bit] NOT NULL,
[UserPreferences] [nvarchar] (max) COLLATE Latin1_General_100_CI_AS NULL,
[PhoneNumber] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[FaxNumber] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[EmailAddress] [nvarchar] (256) COLLATE Latin1_General_100_CI_AS NULL,
[Photo] [varbinary] (max) NULL,
[CustomFields] [nvarchar] (max) COLLATE Latin1_General_100_CI_AS NULL,
[OtherLanguages] [nvarchar] (max) COLLATE Latin1_General_100_CI_AS NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_People_Archive] ON [Application].[People_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Application].[People]
(
[PersonID] [int] NOT NULL CONSTRAINT [DF_Application_People_PersonID] DEFAULT (NEXT VALUE FOR [Sequences].[PersonID]),
[FullName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[PreferredName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NOT NULL,
[SearchName] AS (concat([PreferredName],N' ',[FullName])) PERSISTED NOT NULL,
[IsPermittedToLogon] [bit] NOT NULL,
[LogonName] [nvarchar] (50) COLLATE Latin1_General_100_CI_AS NULL,
[IsExternalLogonProvider] [bit] NOT NULL,
[HashedPassword] [varbinary] (max) NULL,
[IsSystemUser] [bit] NOT NULL,
[IsEmployee] [bit] NOT NULL,
[IsSalesperson] [bit] NOT NULL,
[UserPreferences] [nvarchar] (max) COLLATE Latin1_General_100_CI_AS NULL,
[PhoneNumber] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[FaxNumber] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[EmailAddress] [nvarchar] (256) COLLATE Latin1_General_100_CI_AS NULL,
[Photo] [varbinary] (max) NULL,
[CustomFields] [nvarchar] (max) COLLATE Latin1_General_100_CI_AS NULL,
[OtherLanguages] AS (json_query([CustomFields],N'$.OtherLanguages')),
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Application_People] PRIMARY KEY CLUSTERED  ([PersonID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Application].[People_Archive])
)
GO
CREATE NONCLUSTERED INDEX [IX_Application_People_FullName] ON [Application].[People] ([FullName]) ON [USERDATA]
GO
CREATE NONCLUSTERED INDEX [IX_Application_People_IsEmployee] ON [Application].[People] ([IsEmployee]) ON [USERDATA]
GO
CREATE NONCLUSTERED INDEX [IX_Application_People_Perf_20160301_05] ON [Application].[People] ([IsPermittedToLogon], [PersonID]) INCLUDE ([EmailAddress], [FullName]) ON [USERDATA]
GO
CREATE NONCLUSTERED INDEX [IX_Application_People_IsSalesperson] ON [Application].[People] ([IsSalesperson]) ON [USERDATA]
GO
ALTER TABLE [Application].[People] ADD CONSTRAINT [FK_Application_People_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'People known to the application (staff, customer contacts, supplier contacts)', 'SCHEMA', N'Application', 'TABLE', N'People', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Custom fields for employees and salespeople', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'CustomFields'
GO
EXEC sp_addextendedproperty N'Description', 'Email address for this person', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'Description', 'Fax number  ', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'FaxNumber'
GO
EXEC sp_addextendedproperty N'Description', 'Full name for this person', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'FullName'
GO
EXEC sp_addextendedproperty N'Description', 'Hash of password for users without external logon tokens', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'HashedPassword'
GO
EXEC sp_addextendedproperty N'Description', 'Is this person an employee?', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'IsEmployee'
GO
EXEC sp_addextendedproperty N'Description', 'Is logon token provided by an external system?', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'IsExternalLogonProvider'
GO
EXEC sp_addextendedproperty N'Description', 'Is this person permitted to log on?', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'IsPermittedToLogon'
GO
EXEC sp_addextendedproperty N'Description', 'Is this person a staff salesperson?', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'IsSalesperson'
GO
EXEC sp_addextendedproperty N'Description', 'Is the currently permitted to make online access?', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'IsSystemUser'
GO
EXEC sp_addextendedproperty N'Description', 'Person''s system logon name', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'LogonName'
GO
EXEC sp_addextendedproperty N'Description', 'Other languages spoken (computed column from custom fields)', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'OtherLanguages'
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a person within the database', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'PersonID'
GO
EXEC sp_addextendedproperty N'Description', 'Phone number', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'PhoneNumber'
GO
EXEC sp_addextendedproperty N'Description', 'Photo of this person', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'Photo'
GO
EXEC sp_addextendedproperty N'Description', 'Name that this person prefers to be called', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'PreferredName'
GO
EXEC sp_addextendedproperty N'Description', 'Name to build full text search on (computed column)', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'SearchName'
GO
EXEC sp_addextendedproperty N'Description', 'User preferences related to the website (holds JSON data)', 'SCHEMA', N'Application', 'TABLE', N'People', 'COLUMN', N'UserPreferences'
GO
EXEC sp_addextendedproperty N'Description', 'Improves performance of name-related queries', 'SCHEMA', N'Application', 'TABLE', N'People', 'INDEX', N'IX_Application_People_FullName'
GO
EXEC sp_addextendedproperty N'Description', 'Allows quickly locating employees', 'SCHEMA', N'Application', 'TABLE', N'People', 'INDEX', N'IX_Application_People_IsEmployee'
GO
EXEC sp_addextendedproperty N'Description', 'Allows quickly locating salespeople', 'SCHEMA', N'Application', 'TABLE', N'People', 'INDEX', N'IX_Application_People_IsSalesperson'
GO
EXEC sp_addextendedproperty N'Description', 'Improves performance of order picking and invoicing', 'SCHEMA', N'Application', 'TABLE', N'People', 'INDEX', N'IX_Application_People_Perf_20160301_05'
GO

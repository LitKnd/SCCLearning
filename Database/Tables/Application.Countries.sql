CREATE TABLE [Application].[Countries_Archive]
(
[CountryID] [int] NOT NULL,
[CountryName] [nvarchar] (60) COLLATE Latin1_General_100_CI_AS NOT NULL,
[FormalName] [nvarchar] (60) COLLATE Latin1_General_100_CI_AS NOT NULL,
[IsoAlpha3Code] [nvarchar] (3) COLLATE Latin1_General_100_CI_AS NULL,
[IsoNumericCode] [int] NULL,
[CountryType] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[LatestRecordedPopulation] [bigint] NULL,
[Continent] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Region] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Subregion] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Border] [sys].[geography] NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_Countries_Archive] ON [Application].[Countries_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Application].[Countries]
(
[CountryID] [int] NOT NULL CONSTRAINT [DF_Application_Countries_CountryID] DEFAULT (NEXT VALUE FOR [Sequences].[CountryID]),
[CountryName] [nvarchar] (60) COLLATE Latin1_General_100_CI_AS NOT NULL,
[FormalName] [nvarchar] (60) COLLATE Latin1_General_100_CI_AS NOT NULL,
[IsoAlpha3Code] [nvarchar] (3) COLLATE Latin1_General_100_CI_AS NULL,
[IsoNumericCode] [int] NULL,
[CountryType] [nvarchar] (20) COLLATE Latin1_General_100_CI_AS NULL,
[LatestRecordedPopulation] [bigint] NULL,
[Continent] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Region] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Subregion] [nvarchar] (30) COLLATE Latin1_General_100_CI_AS NOT NULL,
[Border] [sys].[geography] NULL,
[LastEditedBy] [int] NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Application_Countries] PRIMARY KEY CLUSTERED  ([CountryID]) ON [USERDATA]
) ON [USERDATA]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Application].[Countries_Archive])
)
GO
ALTER TABLE [Application].[Countries] ADD CONSTRAINT [UQ_Application_Countries_CountryName] UNIQUE NONCLUSTERED  ([CountryName]) ON [USERDATA]
GO
ALTER TABLE [Application].[Countries] ADD CONSTRAINT [UQ_Application_Countries_FormalName] UNIQUE NONCLUSTERED  ([FormalName]) ON [USERDATA]
GO
ALTER TABLE [Application].[Countries] ADD CONSTRAINT [FK_Application_Countries_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
GO
EXEC sp_addextendedproperty N'Description', N'Countries that contain the states or provinces (including geographic boundaries)', 'SCHEMA', N'Application', 'TABLE', N'Countries', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', 'Geographic border of the country as described by the United Nations', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'Border'
GO
EXEC sp_addextendedproperty N'Description', 'Name of the continent', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'Continent'
GO
EXEC sp_addextendedproperty N'Description', 'Numeric ID used for reference to a country within the database', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'CountryID'
GO
EXEC sp_addextendedproperty N'Description', 'Name of the country', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'CountryName'
GO
EXEC sp_addextendedproperty N'Description', 'Type of country or administrative region', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'CountryType'
GO
EXEC sp_addextendedproperty N'Description', 'Full formal name of the country as agreed by United Nations', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'FormalName'
GO
EXEC sp_addextendedproperty N'Description', '3 letter alphabetic code assigned to the country by ISO', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'IsoAlpha3Code'
GO
EXEC sp_addextendedproperty N'Description', 'Numeric code assigned to the country by ISO', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'IsoNumericCode'
GO
EXEC sp_addextendedproperty N'Description', 'Latest available population for the country', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'LatestRecordedPopulation'
GO
EXEC sp_addextendedproperty N'Description', 'Name of the region', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'Region'
GO
EXEC sp_addextendedproperty N'Description', 'Name of the subregion', 'SCHEMA', N'Application', 'TABLE', N'Countries', 'COLUMN', N'Subregion'
GO

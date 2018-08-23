CREATE TABLE [Warehouse].[ColdRoomTemperatures_Archive]
(
[ColdRoomTemperatureID] [bigint] NOT NULL,
[ColdRoomSensorNumber] [int] NOT NULL,
[RecordedWhen] [datetime2] NOT NULL,
[Temperature] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
) ON [USERDATA]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_ColdRoomTemperatures_Archive] ON [Warehouse].[ColdRoomTemperatures_Archive] ([ValidTo], [ValidFrom]) WITH (DATA_COMPRESSION = PAGE) ON [USERDATA]
GO
CREATE TABLE [Warehouse].[ColdRoomTemperatures]
(
[ColdRoomTemperatureID] [bigint] NOT NULL IDENTITY(1, 1),
[ColdRoomSensorNumber] [int] NOT NULL,
[RecordedWhen] [datetime2] NOT NULL,
[Temperature] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_Warehouse_ColdRoomTemperatures] PRIMARY KEY NONCLUSTERED  ([ColdRoomTemperatureID]),
INDEX [IX_Warehouse_ColdRoomTemperatures_ColdRoomSensorNumber] NONCLUSTERED ([ColdRoomSensorNumber])
)
WITH
(
MEMORY_OPTIMIZED = ON,
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [Warehouse].[ColdRoomTemperatures_Archive])
)
GO

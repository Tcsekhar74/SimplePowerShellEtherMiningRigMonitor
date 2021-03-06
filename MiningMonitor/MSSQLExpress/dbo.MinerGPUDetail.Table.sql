USE [Mining]
GO
/****** Object:  Table [dbo].[MinerGPUDetail]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MinerGPUDetail](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RunID] [int] NULL,
	[MinerSummaryID] [bigint] NOT NULL,
	[GPUIDX] [smallint] NULL,
	[Name] [varchar](50) NULL,
	[Performance] [decimal](10, 4) NULL,
	[Consumption] [decimal](10, 4) NULL,
	[FanSpeed] [int] NULL,
	[Temp] [int] NULL,
	[MemTemp] [int] NULL,
	[Accepted] [int] NULL,
	[Submitted] [int] NULL,
	[Errors] [int] NULL,
	[BestShare] [bigint] NULL,
	[PCIE_Addr] [varchar](20) NULL,
 CONSTRAINT [PK_MinerGPUDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MinerGPUDetail]    Script Date: 12/10/2020 9:09:31 PM ******/
CREATE NONCLUSTERED INDEX [IX_MinerGPUDetail] ON [dbo].[MinerGPUDetail]
(
	[RunID] ASC,
	[MinerSummaryID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MinerGPUDetail]  WITH CHECK ADD  CONSTRAINT [FK_MinerGPUDetail_MinerSummary] FOREIGN KEY([MinerSummaryID])
REFERENCES [dbo].[MinerSummary] ([ID])
GO
ALTER TABLE [dbo].[MinerGPUDetail] CHECK CONSTRAINT [FK_MinerGPUDetail_MinerSummary]
GO

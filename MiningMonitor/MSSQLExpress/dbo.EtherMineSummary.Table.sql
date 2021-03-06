USE [Mining]
GO
/****** Object:  Table [dbo].[EtherMineSummary]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EtherMineSummary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RunID] [int] NOT NULL,
	[DateTime] [datetime] NULL,
	[LastSeen] [datetime] NULL,
	[ReportedHashrate] [int] NULL,
	[CurrentHashrate] [int] NULL,
	[ActualHashrate] [int] NULL,
	[ValidShares] [int] NULL,
	[InvalidShares] [int] NULL,
	[StaleShares] [int] NULL,
	[AverageHashrate] [int] NULL,
	[ActiveWorkers] [int] NULL,
	[Unpaid] [bigint] NULL,
	[CoinsPerMin] [decimal](28, 18) NULL,
	[USDPerMin] [decimal](28, 18) NULL,
	[BTCPerMin] [decimal](28, 18) NULL,
	[time]  AS (dateadd(hour,(6),[DateTime])),
 CONSTRAINT [PK_EtherMineSummary] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [IX_EtherMineSummary]    Script Date: 12/10/2020 9:09:31 PM ******/
CREATE NONCLUSTERED INDEX [IX_EtherMineSummary] ON [dbo].[EtherMineSummary]
(
	[RunID] ASC,
	[time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

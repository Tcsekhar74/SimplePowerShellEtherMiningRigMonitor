USE [Mining]
GO
/****** Object:  Table [dbo].[EtherBalance]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EtherBalance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RunID] [int] NULL,
	[EtherBalance] [decimal](10, 2) NULL,
	[USDBalance] [decimal](10, 2) NULL,
	[DateTime] [datetime] NULL,
	[time]  AS (dateadd(hour,(6),[DateTime])),
 CONSTRAINT [PK_EtherBalance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

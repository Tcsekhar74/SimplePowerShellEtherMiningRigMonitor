USE [Mining]
GO
/****** Object:  View [dbo].[vwMiningSummary]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwMiningSummary] as
select [time], ReportedHashRate/1000000 Reported, CurrentHashRate/1000000 [Current], ActualHashRate [Actual]
from EtherMineSummary 
GO

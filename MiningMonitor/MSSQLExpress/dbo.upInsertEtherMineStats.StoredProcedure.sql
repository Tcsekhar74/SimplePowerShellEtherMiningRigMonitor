USE [Mining]
GO
/****** Object:  StoredProcedure [dbo].[upInsertEtherMineStats]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[upInsertEtherMineStats] @JSON varchar(max), @RunID int as
begin

	insert into EtherMineStats (RunID, Miner, DateTime, LastSeen, ReportedHashRate, CurrentHashRate, ValidShares, InvalidShares, StaleShares, AverageHashRate)
	select 
		 @RunID
		,json_value(value, '$."worker"') Miner
		,dateadd(hour, -6, DATEADD(SS, CONVERT(BIGINT, cast(json_value(value, '$."time"') as int)), '19700101')) DateTime
		,dateadd(hour, -6, DATEADD(SS, CONVERT(BIGINT, cast(json_value(value, '$."lastSeen"') as int)), '19700101')) lastSeen
		,cast(json_value(value, '$."reportedHashrate"') as numeric)/1000000 reportedHashrate
		,cast(json_value(value, '$."currentHashrate"') as numeric)/1000000 currentHashrate
		,cast(json_value(value, '$."validShares"') as numeric) validShares
		,cast(json_value(value, '$."invalidShares"') as numeric) invalidShares
		,cast(json_value(value, '$."staleShares"') as numeric) staleShares
		,cast(json_value(value, '$."averageHashrate"') as numeric)/1000000 averageHashrate
	 from openjson(@JSON, '$.data')
end
GO

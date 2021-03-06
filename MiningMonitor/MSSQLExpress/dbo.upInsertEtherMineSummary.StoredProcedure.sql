USE [Mining]
GO
/****** Object:  StoredProcedure [dbo].[upInsertEtherMineSummary]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[upInsertEtherMineSummary] @JSON varchar(max), @RunID int as
begin

	declare @ActualHashRate int 
	set @ActualHashRate = (select sum(HashRate) from MinerSummary where RunID = @RunID)

	insert into EtherMineSummary (
            [RunID]
           ,[DateTime]
           ,[LastSeen]
           ,[ReportedHashrate]
           ,[CurrentHashrate]
		   ,[ActualHashrate]
           ,[ValidShares]
           ,[InvalidShares]
           ,[StaleShares]
           ,[AverageHashrate]
           ,[ActiveWorkers]
           ,[Unpaid]
           ,[CoinsPerMin]
           ,[USDPerMin]
           ,[BTCPerMin])
	select  @RunID
			,dateadd(hour, -6, DATEADD(SS, CONVERT(BIGINT, cast(json_value(@JSON, '$.data."time"') as int)), '19700101')) DateTime
			,dateadd(hour, -6, DATEADD(SS, CONVERT(BIGINT, cast(json_value(@JSON, '$.data."lastSeen"') as int)), '19700101')) LastSeen
			,cast(json_value(@JSON, '$.data."reportedHashrate"') as numeric) ReportedHashrate
			,cast(json_value(@JSON, '$.data."currentHashrate"') as numeric) CurrentHashrate
			,@ActualHashRate
			,cast(json_value(@JSON, '$.data."validShares"') as numeric) ValidShares
			,cast(json_value(@JSON, '$.data."invalidShares"') as numeric) InvalidShares
			,cast(json_value(@JSON, '$.data."staleShares"') as numeric) StaleShares
			,cast(json_value(@JSON, '$.data."averageHashrate"') as numeric) AverageHashrate
			,cast(json_value(@JSON, '$.data."activeWorkers"') as numeric) ActiveWorkers
			,cast(json_value(@JSON, '$.data."unpaid"') as numeric) Unpaid
			,cast(json_value(@JSON, '$.data."coinsPerMin"') as decimal(28,18)) CoinsPerMin
			,cast(json_value(@JSON, '$.data."usdPerMin"') as decimal(28,18)) USDPerMin
			,cast(json_value(@JSON, '$.data."btcPerMin"') as decimal(28,18)) BTCPerMin

end
GO

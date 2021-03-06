USE [Mining]
GO
/****** Object:  StoredProcedure [dbo].[upInsertMinerRestart]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[upInsertMinerRestart] @JSON varchar(max), @RunID int as
begin
	declare @Miner varchar(20)
	set @Miner = json_value(@JSON, '$.Miner')
	insert into MinerRestarts (DateTime, RunID, Miner, RestartType, SuccessFlag) values (getdate(), @RunID, @Miner, json_value(@JSON, '$.Type'), cast(json_value(@JSON, '$.Success') as bit))
	
end
GO

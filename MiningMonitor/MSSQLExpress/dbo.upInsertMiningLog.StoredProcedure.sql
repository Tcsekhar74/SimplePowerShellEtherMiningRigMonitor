USE [Mining]
GO
/****** Object:  StoredProcedure [dbo].[upInsertMiningLog]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[upInsertMiningLog] @JSON varchar(max), @RunID bigint as
begin
	insert into MinerSummary 
		(RunID, Miner, Latency, Startup, UpTime, LastUpdate, GPUs, HashRate, Unit, Accepted, Submitted, TotalPower, SwitchPower) 
	select 
		 @RunID
		,replace(JSon_Value(@Json, '$.Stratum."Current_User"'), '0x5c1e17fEC88D3fFC40935b7bAeB0D8f0469B5038.','') Miner
		,JSon_Value(@Json, '$.Stratum."Average_Latency"') Latency
		, DATEADD(second,(cast(JSon_Value(@Json, '$.Session."Startup"') as int) - DATEDIFF(second,GETDATE(),GETUTCDATE())), CAST('1970-01-01 00:00:00' AS datetime)) StartUp
		,JSon_Value(@Json, '$.Session."Uptime"') UpTime
		,DATEADD(second,(cast(JSon_Value(@Json, '$.Session."Last_Update"') as int) - DATEDIFF(second,GETDATE(),GETUTCDATE())), CAST('1970-01-01 00:00:00' AS datetime)) LastUpdate
		,JSon_Value(@Json, '$.Session."Active_GPUs"') GPUs
		,JSon_Value(@Json, '$.Session."Performance_Summary"') HashRate
		,JSon_Value(@Json, '$.Session."Performance_Unit"') Unit
		,JSon_Value(@Json, '$.Session."Accepted"') Accepted
		,JSon_Value(@Json, '$.Session."Submitted"') Submitted
		,JSon_Value(@Json, '$.Session."TotalPower"') TotalPower
		,case when isnumeric(JSon_Value(@Json, '$.Software'))= 1 then JSon_Value(@Json, '$.Software') end SwitchPower

		
	declare @MID bigint = @@IDENTITY
	insert into MinerGPUDetail (RunID, MinerSummaryID, GPUIDX, Name, Performance, Consumption, FanSpeed, Temp, MemTemp, Accepted, Submitted, Errors, BestShare, PCIE_Addr)
	select 
		@RunID,
		@MID MinerSummaryID,
		json_value(value, '$."Index"') GPUIDX, 
		json_value(value, '$."Name"') Name, 
		json_value(value, '$."Performance"') Performance, 
		json_value(value, '$."Consumption (W)"') Consumption,
		json_value(value, '$."Fan Speed (%)"') FanSpeed, 
		json_value(value, '$."Temp (deg C)"') Temp, 
		json_value(value, '$."Mem Temp (deg C)"') MemTemp, 
		json_value(value, '$."Session_Accepted"') Accepted, 
		json_value(value, '$."Session_Submitted"') Submitted, 
		json_value(value, '$."Session_HWErr"') Errors, 
		json_value(value, '$."Session_BestShare"') BestShare, 
		json_value(value, '$."PCIE_Address"') PCIE_Addr
	from openjson(@Json, '$.GPUs') 

	declare @Miner varchar(20)
	declare @LastUpdate datetime
	select @Miner = Miner, @LastUpdate = LastUpdate from MinerSummary where ID = @MID
	if isnull(@Miner,'') <> ''
		update Miners set LastFound = @LastUpdate, LastRunID = @RunID where Miner = @Miner
end
GO

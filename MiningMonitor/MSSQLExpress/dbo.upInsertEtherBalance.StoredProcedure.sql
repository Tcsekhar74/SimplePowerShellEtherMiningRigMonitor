USE [Mining]
GO
/****** Object:  StoredProcedure [dbo].[upInsertEtherBalance]    Script Date: 12/10/2020 9:09:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[upInsertEtherBalance] @JSON varchar(max), @RunID int as
begin
	declare @USDBal int
	declare @ETHBal decimal(10,2) 
	set @ETHBal = cast(left(json_value(@JSON, '$.result'), 5) as decimal(10,2))/100.00
	set @USDBal = (select top 1  @ETHBal * USDPerMin / CoinsPerMin from EtherMineSummary order by id desc)

	insert into EtherBalance (RunID, EtherBalance, USDBalance, DateTime)
	values (@RunID, @ETHBal, @USDBal, getdate())
end
GO

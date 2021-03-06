USE [Mining]
GO
/****** Object:  User [mining]    Script Date: 12/10/2020 9:09:31 PM ******/
CREATE USER [mining] FOR LOGIN [mining] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [mining]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [mining]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [mining]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [mining]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [mining]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mining]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [mining]
GO

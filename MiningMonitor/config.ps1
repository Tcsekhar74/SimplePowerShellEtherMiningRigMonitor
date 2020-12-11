#Linux MINING NODE IP ADDRESS, NAME and TPLink Switch details
$objMiners= '[{"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner1", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner2", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner3", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner4", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner5", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner6", DeviceID:"YOUR TP LINK PLUG DEVICE ID"},
              {"IPAddr":"xxx.xxx.xxx.xxx","Name":"Miner7",DeviceID:"YOUR TP LINK PLUG DEVICE ID"}]' | ConvertFrom-Json

#SQL Server Details - SQL SERVER INSTANCE AND DBNAME
$DBServer = "." 
$DBName = "Mining"

#Linux Server login details
$ethosuid = "linuxuserid"
$ethospwd = "linuxpwd"

#Linux Server Star Miner Script with location
$Command = "sh /opt/miners/lolminer/1.16a/start.sh"

#Wallet details
$etherAddr = "0xYOURETHERWALLETADDRESS"

#TPLink KASA Login details and a random UUID for KASA WebAPI to identify your APP
$tplinkusr = "TPLINKUSERID"
$tplinkpwd = "TPLINKPASSWORD"
$tplinkClientID = "4ac5d73e-214b-4371-9fdc-626abea7be1f"
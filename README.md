# SimplePowerShellEtherMiningRigMonitor
Simple PowerShell Ether Mining Rig Monitor - uses PowerShell, SQL Express and Grafana

Here is a very simple Ether Mining Rig Monitoring and Reporting application. Wrote everything in less than a day and does everything I needed for my rig. I thought this might help someone looking for a very simple application to automatically restart "stuck mining nodes" and report on 

Energy usage
Active Mining Rigs
Active GPUs
Individual and aggregated Hash rate (Actual vs Pool)
Rig power consumption (per miner)
Coins/USD per day
Valid vs Invalid Shares
faulty GPUs
GPU Performance (by individual GPU)
GPU Heat (by individual GPU)
Time series - progressive hashrate per rig
ETH Current rate and trend
ETH Balance and trend
Overall Power consumption
Restart summary (recent restarts - success vs failed)

You will need to install these components:

1. SQL Server (a Free SQL Server Express would do as well)
   https://www.microsoft.com/en-us/sql-server/sql-server-downloads
   
2. Grafana (any version)
   https://grafana.com/grafana/download?platform=windows
   
3. PowerShell
   https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1
   
4. LOLMiner (To be installed on the Linux server that you are using to mine Ethereum)
   https://github.com/Lolliedieb/lolMiner-releases/releases 

TP-Link HS110 is what I use and they are phenominal. I can see the power usage and as well control them through my script easily. Tweak the code as needed to fit your needs. 

I didn't try this on any linux instance but it should work just fine on a linux or a docker as well. There are linux flavors for all the above 3.

You will need to install LOLMINER - the most reliable mining software out there (but has less things you can control - to me it was better than the Claymore Dual miner I was using).

You will also need to configure the start.sh and also add a reboot script inside the Linux server.  

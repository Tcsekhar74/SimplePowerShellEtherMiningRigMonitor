clear
echo ' '
echo ' '
echo '##################### STARTING PROCESS #####################'
echo ' '

$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ("$ScriptDirectory\config.ps1")

$Runid =  [int][double]::Parse((Get-Date -UFormat %s))

$secpasswd = ConvertTo-SecureString $ethospwd -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($ethosuid, $secpasswd)

$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=True;"
$sqlConnection.Open()

$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
$sqlCommand.Connection = $sqlConnection
$sqlCommand.CommandType = 'StoredProcedure'
$sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@JSON",[Data.SQLDBType]::VarChar, 36000))) | Out-Null
$sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@RunID",[Data.SQLDBType]::Int))) | Out-Null
$sqlCommand.Parameters[1].Value = $Runid

echo 'Get the latest Ether Balance from EtherScan and store in DB'
$sqlCommand.CommandText = "dbo.upInsertEtherBalance" 
$json = Invoke-RestMethod ('https://api.etherscan.io/api?module=account&action=balance&address=' + $etherAddr + '&tag=latest&apikey=QQZVS7QJ58FKZSGHB29NC5HM5UGRIER6WP') -TimeoutSec 3 | ConvertTo-Json
$sqlCommand.Parameters[0].Value = $json
$sqlCommand.ExecuteScalar()


echo 'Get the Mining Stats from Ethermine and store in DB'
$sqlCommand.CommandText = "dbo.upInsertEtherMineStats" 
$json = Invoke-RestMethod ('https://api.ethermine.org/miner/' + $etherAddr + '/workers') -TimeoutSec 1 | ConvertTo-Json

$sqlCommand.Parameters[0].Value = $json
$sqlCommand.ExecuteScalar()

$TPLinkToken = (Invoke-RestMethod -Uri https://use1-wap.tplinkcloud.com -Body ('{"method":"login","url":"https://wap.tplinkcloud.com","params":{"appType":"Kasa_Android","cloudUserName":"' + $tplinkusr + '","cloudPassword":"' + $tplinkpwd + '","terminalUUID":"' + $tplinkClientID + '"}}') -ContentType application/json -Method POST -UserAgent "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)" | ConvertTo-Json | ConvertFrom-Json).result.token

for ($i = 0; $i -lt $objMiners.Length ; $i++)
{   $miner = $objMiners[$i].IPAddr
    $minerName = $objMiners[$i].Name
    try {   $MinerPwr = -1
            echo ('Get the Power Switch Stats for ' + $minerName)
            try
            {   $body = '{"method":"passthrough","params":{"deviceId":"' + $objMiners[$i].DeviceID + '","requestData":"{\"emeter\":{\"get_realtime\":{}}}"}}'
                $MinerPwr = ((Invoke-RestMethod -Uri https://use1-wap.tplinkcloud.com?token=$TPLinkToken -Body $body -ContentType application/json -Method POST -UserAgent "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)" | ConvertTo-Json | ConvertFrom-Json).result.responseData | ConvertFrom-Json).emeter.get_realtime.power   }
            catch
            {   echo ('issue getting power details from switch ' + $minerName)   }
            $wurl = 'http://' + $miner + ':3333/summary'
            echo ('Get the Mining Stats and store in DB for ' + $minerName)
            $tmpjson = (Invoke-RestMethod $wurl -TimeoutSec 1 | ConvertTo-Json | ConvertFrom-Json)
            $tmpjson.Software = $MinerPwr
            $json = $tmpjson | ConvertTo-Json

            $sqlCommand.CommandText = "dbo.upInsertMiningLog" 
            #echo $json
            $sqlCommand.Parameters[0].Value = $json
            $sqlCommand.ExecuteScalar()        }
    catch 
    {   $sqlCommand.CommandText = "dbo.upGetMinerRestarts" 
        $sqlCommand.Parameters[0].Value = $minerName
        $RecentRestartCount = $sqlCommand.ExecuteScalar()
        $restartstats = '{"Miner":"' + $minerName + '", "Success":"False", "Type":"NotStarted" }'

        echo ('$miner is not running. Trying to start it again. Restart Count: ' + $RecentRestartCount)  
        $sqlCommand.CommandText = "dbo.upInsertMinerRestart" 
        try {   try {   $restartstats = '{"Miner":"' + $minerName + '", "Success":"True", "Type":"Start" }'
                        $SessionID = New-SSHSession -ComputerName $miner -Credential $Credentials 
                        Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command 
                        echo 'Miner successfuly requested to start mining.'  }
                catch 
                    {   echo 'Error occured ssh into server' }
                finally
                    {   echo 'Out of Start Mining command section'  }

                if ($RecentRestartCount -in (3,6) )
                { try      { $restartstats = '{"Miner":"' + $minerName + '", "Success":"True", "Type":"Software Reboot" }'
                             $SessionID = New-SSHSession -ComputerName $miner -Credential $Credentials 
                             Invoke-SSHCommand -Index $sessionid.sessionid -Command 'r'
                             echo 'Miner successfuly requested to start mining.'                        
                             echo $restartstats  }
                   catch   { echo 'Error occured ssh into server' }
                   finally { echo 'Out of Software Reboot section' }  }

                if ( ( $objMiners[$i].DeviceID -ne "" ) -and ( $RecentRestartCount -in (9,13,17,21,25,35,60,90,120,180,250,300,350,400,450,500) ) )
                { try        { $restartstats = '{"Miner":"' + $minerName + '", "Success":"True", "Type":"Power Switch Reset" }'
                               $body = '{"method":"passthrough","params":{"deviceId":"' + $objMiners[$i].DeviceID + '","requestData":"{\"system\":{\"set_relay_state\":{\"state\":0}}}"}}'
                               Invoke-RestMethod -Uri https://use1-wap.tplinkcloud.com?token=$TPLinkToken -Body $body -ContentType application/json -Method POST -UserAgent "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)" 
                               Start-Sleep -Seconds 1
                               $body = '{"method":"passthrough","params":{"deviceId":"' + $objMiners[$i].DeviceID + '","requestData":"{\"system\":{\"set_relay_state\":{\"state\":1}}}"}}'
                               Invoke-RestMethod -Uri https://use1-wap.tplinkcloud.com?token=$TPLinkToken -Body $body -ContentType application/json -Method POST -UserAgent "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)" 
                               echo 'Miner successfuly requested to start mining.'
                               echo $restartstats }
                    catch    { echo 'Error resetting plug' }
                    finally  { echo 'Out of Plug reset section' }  }

                if ($RecentRestartCount -gt 25)
                {   $restartstats = '{"Miner":"' + $minerName + '", "Success":"False", "Type":"Too many Resets. Stopping any action!" }'
                    echo $restartstats  }

                echo ('Miner requested to start. Result: ' + $restartstats)
                $sqlCommand.Parameters[0].Value = $restartstats  }
        catch   { echo ('Miner not responding. Please try manually resetting -' + $minerName)
                  $restartstats = $restartstats -replace 'True', 'False'
                  $sqlCommand.Parameters[0].Value = $restartstats  }
        finally { echo 'Out of Exception' }

        echo ('Sending data to SQL Server' + $restartstats)
        
        $sqlCommand.ExecuteScalar()   }
}

echo 'Get EtherMineSummary from EtherMine and store in DB'
$sqlCommand.CommandText = "dbo.upInsertEtherMineSummary" 
$json = Invoke-RestMethod ('https://api.ethermine.org/miner/' + $etherAddr + '/currentStats') -TimeoutSec 3 | ConvertTo-Json
$sqlCommand.Parameters[0].Value = $json
$sqlCommand.ExecuteScalar()


if ($sqlConnection.State -eq [Data.ConnectionState]::Open) {
    $sqlConnection.Close()
}

echo 'Process Complete!'
echo ' '
echo '##################### PROCESS ENDED #####################'
echo ' '
echo ' '
echo ' '
exit
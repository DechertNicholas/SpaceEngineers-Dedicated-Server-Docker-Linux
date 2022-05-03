# Copied from my Windows version:
# https://github.com/DechertNicholas/SpaceEngineers-Dedicated-Server-Docker-Windows/blob/main/Start.ps1
# Quit on any errors
$ErrorActionPreference = "Stop"

Write-Output "`n\\\\\ Starting Container //////`n"

Write-Output "- Running in $(Get-Location)"

Write-Output "`n\\\\\\\ Updating Server ///////`n"

/usr/games/steamcmd +login anonymous +@sSteamCmdForcePlatformType windows +app_update 298740 +quit

Write-Output "`n\\\\\\\ Setting Configs ///////`n"

$configFile = "/root/Instances/$env:INSTANCENAME/SpaceEngineers-Dedicated.cfg"
if (Resolve-Path $configFile) {Write-Output "Found config file at $configFile"} else {throw "Unable to find config file at $configFile"}

$config = [Xml] (Get-Content $configFile)
Write-Output "--- LoadWorld ->"
Write-Output "        Current Value: $($config.MyConfigDedicated.LoadWorld)"
# The "LoadWorld" XML item will be set to the wrong place most likely, so fix it
$config.MyConfigDedicated.LoadWorld = $config.MyConfigDedicated.LoadWorld -replace ".*\\(Saves\\.*\\Sandbox.sbc)","Z:\root\Instances\$env:INSTANCENAME\`$1"
Write-Output "        New Value:     $($config.MyConfigDedicated.LoadWorld)"

# Seems specific to Linux, the binding IP MUST be set otherwise the server will be unable to bind
# Even then, it still sometimes happens and the container must keep restarting until successful
# Write-Output "--- IP ->"
# Write-Output "        Current Value: $($config.MyConfigDedicated.IP)"
# $config.MyConfigDedicated.IP = [System.Net.Dns]::GetHostAddresses($(hostname)).IPAddressToString
# Write-Output "        New Value:     $($config.MyConfigDedicated.IP)"

$config.Save("$configFile")

Write-Output "`n\\\\\\\ Starting Server ///////`n"

# The server needs to be called from the .exe location, otherwise the relative paths the server calls for will
# not exist, and the server will fail to start
Set-Location "/root/Steam/steamapps/common/SpaceEngineersDedicatedServer/DedicatedServer64"
Start-Process wine -ArgumentList "SpaceEngineersDedicated.exe","-noconsole","-ignorelastsession","-path","`"Z:\root\Instances\$env:INSTANCENAME`"" -Wait

Write-Output "`n\\\\\\\ Stopping Server ///////`n"
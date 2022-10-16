# powershell -NoProfile -ExecutionPolicy Bypass -Command "& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/vaal1988/powershell/master/installSaltMinion.ps1'))) 192.168.56.17 windows_desktops"

param (
   [string]$SALT_MASTER_SERVER = "192.168.56.15",
   [string]$SALT_AGENT_ENVIRONMENT = "windows_desktops"
)

if (!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
}

$saltminion_id = 'Salt Minion'
$saltminion_version = '3005.1-1'
$saltminion_download_path = "https://repo.saltproject.io/windows/Salt-Minion-3005.1-1-Py3-AMD64-Setup.exe"
$saltminion_x86_download_path = "https://repo.saltproject.io/windows/Salt-Minion-3005.1-1-Py3-x86-Setup.exe"


if ($env:PROCESSOR_ARCHITECTURE -eq "amd64") {

    write-host "system is 64 bit"
    # checking if installed
    $regkeypath= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$saltminion_id" 
    $keyvalue = (Get-ItemProperty $regkeypath -ErrorAction SilentlyContinue).DisplayVersion

    If ($keyvalue -eq $saltminion_version) { 
    Write-Host "saltminion is already installed" 
    
    } Else { 
    Write-Host "not installed" 

    Write-Host "downloading"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("$saltminion_download_path","C:\install\Salt-Minion-3005.1-1-Py3-AMD64-Setup.exe")

    Write-Host "trying to install"
    Start-Process "C:\install\Salt-Minion-3005.1-1-Py3-AMD64-Setup.exe" -Wait -ArgumentList "/S /master=$SALT_MASTER_SERVER /start-minion=0"
    }
} 

Else {

    write-host "system is not 64"

}

Set-Content -Path "C:\ProgramData\Salt Project\Salt\conf\minion" -Value "
master: $SALT_MASTER_SERVER
environment: $SALT_AGENT_ENVIRONMENT
"

Restart-Service -Name 'salt-minion'

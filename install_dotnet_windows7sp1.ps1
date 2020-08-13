# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/install_dotnet_windows7sp1.ps1'))"


$osVersion = (Get-WmiObject Win32_OperatingSystem).version

$osversionLookup = @{
"5.1.2600" = "XP";
"5.1.3790" = "2003";
"6.0.6001" = "Vista/2008";
"6.1.7600" = "Win7/2008R2";
"6.1.7601" = "Win7 SP1/2008R2 SP1";
"6.2.9200" = "Win8/2012";
"6.3.9600" = "Win8.1/2012R2";
"10.0.*"   = "Windows 10/Server 2016"
}


if($osVersion -eq '6.1.7600') {
   Throw "SP1 must be installed"
}

if($osVersion -eq '6.1.7601') {
   Write-Output "Windows version - Win7 SP1/2008R2 SP1"
}else {
   Throw "Script only for  Win7 SP1/2008R2 SP1"
}


If ((get-service wuauserv).starttype -ieq 'Disabled')
{
  Throw "Windows Update Service is disabled - PowerShell updates are distributed as windows updates and so require the service."
}


## updating dotNet

$MinimumNet4Version = 378389
$Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue)

if ($Net4Version -ge $MinimumNet4Version) {
  Write-Output "dotNET Framework 4.5.2 or later"
}

else {
  Write-Output ".NET Framework 4.5.2 or later required"
  Write-Output "Installing"

if (!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
}

# download
$download_url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
$download_path = "C:\install\NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
(New-Object Net.WebClient).DownloadFile($download_url, $download_path) 

# install
Start-Process "$download_path" -Wait -ArgumentList "/Quiet /NoRestart"

}


If ($PSVersionTable.PSVersion.Major -eq 2) {
  Write-Output "PSVersion is 2"
  
# https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip
# https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip

}



switch ($osversionLookup[$osVersion]) {
"Vista/2008" {
    Write-Output "PowerShell 3 is the highest supported"
}
"Win7/2008R2" {
    Write-Output "PowerShell 3 is the highest supported"
}
"Win7 SP1/2008R2 SP1" {
    Write-Output "TEST"
}

"Win8/2012" {
  if($os.ProductType -gt 1) {
# 8.1
  }
  else {
# 8
  }
}

"Win8.1/2012R2" {

}

"Windows 10/Server 2016" {

}

default {
# Windows XP, Windows 2003, Windows Vista, or unknown
}

}



















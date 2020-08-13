# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/install_dotnet_windows7sp1.ps1'))"



$osVersion = (Get-WmiObject Win32_OperatingSystem).version

if($osVersion -eq '6.1.7600') {
   Throw "SP1 must be installed"
}

if($osVersion -eq '6.1.7601') {
   Write-Output "Windows version - Win7 SP1/2008R2 SP1"
}else {
   Throw "Script only for  Win7 SP1/2008R2 SP1"
}

## updating dotNet

$MinimumNet4Version = 378389
$Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue)

if ($Net4Version -ge $MinimumNet4Version) {
  Write-Output "dotNET Framework 4.5.2 or later"
}

else {

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
  Write-Output "PSVersion is $PSVersionTable.PSVersion.Major"
}

If ($PSVersionTable.PSVersion.Major -eq 3) {
  Write-Output "PSVersion is $PSVersionTable.PSVersion.Major"
}

If ($PSVersionTable.PSVersion.Major -eq 4) {
  Write-Output "PSVersion is $PSVersionTable.PSVersion.Major"
}

If ($PSVersionTable.PSVersion.Major -eq 5) {
  Write-Output "PSVersion is $PSVersionTable.PSVersion.Major"
}





















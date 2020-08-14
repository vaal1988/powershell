# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/update_powershell.ps1'))"

$osVersion = (Get-WmiObject Win32_OperatingSystem).version

if($osVersion -eq '6.1.7601') {
  Write-Output "Windows version - Win7 SP1/2008R2 SP1"

} else {
  Throw "Script only for  Win7 SP1/2008R2 SP1"
}

# If ((get-service wuauserv).starttype -ieq 'Disabled')
# {
#   Throw "Windows Update Service is disabled - PowerShell updates are distributed as windows updates and so require the service."
# }



if (!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
}

## updating dotNet

$MinimumNet4Version = 378389
$Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue)

if ($Net4Version -ge $MinimumNet4Version) {
  Write-Output "dotNET Framework already 4.5.2 or later"
}

else {
  Write-Output ".NET Framework 4.5.2 or later required"
  Write-Output "Installing"

# download
$download_url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
$download_path = "C:\install\NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
(New-Object Net.WebClient).DownloadFile($download_url, $download_path) 

# install
Start-Process "$download_path" -Wait -ArgumentList "/Quiet /NoRestart"

}

## updating PS

If ($PSVersionTable.PSVersion.Major -eq 2) {
  Write-Output "PSVersion is 2"

  if ( (Get-WMIObject Win32_OperatingSystem).OSArchitecture -eq "64-bit") {

    Write-Output "Downloading"
    $ps_download_url = "https://raw.githubusercontent.com/vaal1988/powershell/master/windows7/Win7AndW2K8R2-KB3191566-x64.msu" 
    $ps_download_path = "C:\install\Win7AndW2K8R2-KB3191566-x64.msu" 
    (New-Object Net.WebClient).DownloadFile($ps_download_url, $ps_download_path)

    Write-Output "Installing"    
    Start-Process "C:\install\Win7AndW2K8R2-KB3191566-x64.msu" -Wait -ArgumentList "/quiet /norestart"

  } 

  if ( (Get-WMIObject Win32_OperatingSystem).OSArchitecture -eq "32-bit") {

    Write-Output "Downloading"
    $ps_download_url = "https://raw.githubusercontent.com/vaal1988/powershell/master/windows7/Win7-KB3191566-x86.msu" 
    $ps_download_path = "C:\install\Win7-KB3191566-x86.msu" 
    (New-Object Net.WebClient).DownloadFile($ps_download_url, $ps_download_path)

    Write-Output "Installing"
    Start-Process "C:\install\Win7-KB3191566-x86.msu" -Wait -ArgumentList "/quiet /norestart"

  } 

  # Else {

  #   Write-Output "Downloading"
  #   $ps_download_url = "https://raw.githubusercontent.com/vaal1988/powershell/master/windows7/Win7-KB3191566-x86.msu" 
  #   $ps_download_path = "C:\install\Win7-KB3191566-x86.msu" 
  #   (New-Object Net.WebClient).DownloadFile($ps_download_url, $ps_download_path)

  #   Write-Output "Installing"
  #   Start-Process "C:\install\Win7-KB3191566-x86.msu" -Wait -ArgumentList "/quiet /norestart"

  # }

}

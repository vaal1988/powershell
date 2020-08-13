# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/update_powershell.ps1'))"



$osVersion = (Get-WmiObject Win32_OperatingSystem).version

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








if (!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
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

# download
$download_url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
$download_path = "C:\install\NDP452-KB2901907-x86-x64-AllOS-ENU.exe" 
(New-Object Net.WebClient).DownloadFile($download_url, $download_path) 

# install
Start-Process "$download_path" -Wait -ArgumentList "/Quiet /NoRestart"

}


function UnZip-File($Source, $Destination)
{
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
$Overwrite = $true


if ((Test-Path $Destination) -eq $false) 

{
 $null = mkdir $Destination 
}

$Content = [IO.Compression.ZipFile]::OpenRead($Source).Entries
$Content | 
 ForEach-Object -Process {
    $FilePath = Join-Path -Path $Destination -ChildPath $_
                [IO.Compression.ZipFileExtensions]::ExtractToFile($_,$FilePath,$Overwrite)
            }
}


If ($PSVersionTable.PSVersion.Major -eq 2) {
  Write-Output "PSVersion is 2"

  if ($env:PROCESSOR_ARCHITECTURE -eq "amd64") {

    $ps_download_url = "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip" 
    $ps_download_path = "C:\install\Win7AndW2K8R2-KB3191566-x64.zip" 
    (New-Object Net.WebClient).DownloadFile($download_url, $download_path) 



  } 

  Else {

    $ps_download_url = "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip" 
    $ps_download_path = "C:\install\Win7-KB3191566-x86.zip" 
    (New-Object Net.WebClient).DownloadFile($ps_download_url, $ps_download_path)

    UnZip-File $ps_download_path -destination c:\install\KB3191566
    
    Start-Process "C:\install\Win7-KB3191566-x86.msu" -Wait -ArgumentList "/quiet /norestart"

  }


}























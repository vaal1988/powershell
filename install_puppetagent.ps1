# powershel -NoProfile -ExecutionPolicy Bypass -Command '& ([scriptblock]::Create((irm https://raw.githubusercontent.com/vaal1988/powershell/master/install_puppetagent.ps1))) puppet environment'

param (
   [string]$PUPPET_MASTER_SERVER = "puppet",
   [string]$PUPPET_AGENT_ENVIRONMENT = "environment"
)

if (!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
}

$WORKSTATION_FQDN = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
$PUPPET_AGENT_CERTNAME = $WORKSTATION_FQDN.ToLower()

$puppetagentx64_download_path = "https://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.9.0-x64.msi"
$puppetagentx64_id = '{CB4C373E-4050-4D9C-AEF4-1CB31DCF31EA}'
$puppetagentx64_version = '101253120'

$puppetagentx86_download_path = "https://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.9.0-x86.msi"
$puppetagentx86_id = '{5A2953C8-3B15-4898-B09C-FA560F826D54}'
$puppetagentx86_version = '101253120'

if ($env:PROCESSOR_ARCHITECTURE -eq "amd64") {

    write-host "system is 64 bit"
    # checking if installed
    $regkeypath= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$puppetagentx64_id" 
    $keyvalue = (Get-ItemProperty $regkeypath -ErrorAction SilentlyContinue).Version
  
    If ($keyvalue -eq $puppetagentx64_version) { 
    Write-Host "puppetagent is already installed" 
    
    } Else { 
    Write-Host "not installed" 

    Write-Host "downloading"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("$puppetagentx64_download_path","C:\install\puppetagent-x64.msi")

    Write-Host "trying to install"
    Start-Process msiexec.exe -Wait -ArgumentList "/qn /norestart /i C:\install\puppetagent-x64.msi PUPPET_MASTER_SERVER=$PUPPET_MASTER_SERVER PUPPET_AGENT_CERTNAME=$PUPPET_AGENT_CERTNAME PUPPET_AGENT_ENVIRONMENT=$PUPPET_AGENT_ENVIRONMENT"
    }
} 

Else {

    write-host "system is not 64"
    # checking if installed
    $regkeypath= "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$puppetagentx86_id" 
    $keyvalue = (Get-ItemProperty $regkeypath -ErrorAction SilentlyContinue).Version

    If ($keyvalue -eq $puppetagentx86_version) { 
    Write-Host "puppetagent is already installed" 
        
    } Else { 
    Write-Host "not installed" 

    Write-Host "downloading"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("$puppetagentx86_download_path","C:\install\puppetagent-x86.msi")

    Write-Host "trying to install"
    Start-Process msiexec.exe -Wait -ArgumentList "/qn /norestart /i C:\install\puppetagent-x86.msi PUPPET_MASTER_SERVER=$PUPPET_MASTER_SERVER PUPPET_AGENT_CERTNAME=$PUPPET_AGENT_CERTNAME PUPPET_AGENT_ENVIRONMENT=$PUPPET_AGENT_ENVIRONMENT"
    }
}

$puppet_conf_file = 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf'

if ( Select-String -Path $puppet_conf_file -Pattern "certname=$PUPPET_AGENT_CERTNAME" -SimpleMatch -Quiet ) {
  echo "certname OK"
} else {
  echo "puppet ssl clean"
  puppet ssl clean
}

# config
puppet config set server puppet.intergal-bud.com.ua --section main
puppet config set certname $PUPPET_AGENT_CERTNAME --section main
puppet config set environment $PUPPET_AGENT_ENVIRONMENT --section main

try     { puppet ssl submit_request }
catch   { Write-Host "could not submit certificate" }

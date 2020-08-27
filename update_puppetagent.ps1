param (
   [string]$PUPPET_MASTER_SERVER = "puppet",
   [string]$PUPPET_AGENT_ENVIRONMENT = "environment"
)

$WORKSTATION_FQDN = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
$PUPPET_AGENT_CERTNAME = $WORKSTATION_FQDN.ToLower()

$puppetagentx64_download_path = "https://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.9.0-x64.msi"
$puppetagentx64_id = '{CB4C373E-4050-4D9C-AEF4-1CB31DCF31EA}'
$puppetagentx64_version = '101253120'

$puppetagentx86_download_path = "https://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.9.0-x86.msi"
$puppetagentx86_id = '{5A2953C8-3B15-4898-B09C-FA560F826D54}'
$puppetagentx86_version = '101253120'


if(!(Test-Path C:\install)) { 
  New-Item -ItemType Directory -Force -Path C:\install 
} 

# config
if(Test-Path C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf) {

$puppet_conf=@"
[main]
server=$PUPPET_MASTER_SERVER
autoflush=true
manage_internal_file_permissions=false
environment=$PUPPET_AGENT_ENVIRONMENT
certname=$PUPPET_AGENT_CERTNAME
"@

Write-Host $puppet_conf

$puppet_conf_present = Get-Content C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf

If ($puppet_conf_present -contains $puppet_conf ) { Write-Host "It's contains!" } 
Else { Write-Host "Not contains!" }


Set-Content "C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf" -Value $puppet_conf

} 

try     { puppet ssl submit_request }
catch   { Write-Host "could not submit certificate" }

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
    msiexec /qn /norestart /i C:\install\puppetagent-x64.msi PUPPET_MASTER_SERVER=$PUPPET_MASTER_SERVER PUPPET_AGENT_CERTNAME=$PUPPET_AGENT_CERTNAME PUPPET_AGENT_ENVIRONMENT=$PUPPET_AGENT_ENVIRONMENT
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
    msiexec /qn /norestart /i C:\install\puppetagent-x86.msi PUPPET_MASTER_SERVER=$PUPPET_MASTER_SERVER PUPPET_AGENT_CERTNAME=$PUPPET_AGENT_CERTNAME PUPPET_AGENT_ENVIRONMENT=$PUPPET_AGENT_ENVIRONMENT
    }
}

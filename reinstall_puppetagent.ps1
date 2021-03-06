Stop-Service -Name 'puppet'

puppet ssl clean
Get-ChildItem -Path C:\ProgramData\PuppetLabs\facter\facts.d -Include * -File -Recurse | foreach { $_.Delete()}

$app = Get-WmiObject -Class Win32_Product | Where {$_.Name -like "*Puppet Agent*" }
$app.Uninstall()

$WebClient = New-Object System.Net.WebClient
$puppetagentx64_download_path = "https://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.9.0-x64.msi"
$WebClient.DownloadFile("$puppetagentx64_download_path","C:\puppet-agent_x64.msi")

Start-Process msiexec.exe -Wait -ArgumentList "/qn /norestart /i C:\puppet-agent_x64.msi"
Stop-Service -Name 'puppet'
Remove-Item -Path "C:\puppet-agent_x64.msi"

Set-Content -Path C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf -Value '
[main]
server=puppet
autoflush=true
manage_internal_file_permissions=false
environment=environment
'
Restart-Service -Name 'puppet'

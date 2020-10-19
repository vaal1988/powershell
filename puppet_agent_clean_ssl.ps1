# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/puppet_agent_clean_ssl.ps1'))"

Invoke-Command -ScriptBlock { puppet agent -t } | Tee-Object -Variable PuppetAgentOutput

if ( $PuppetAgentOutput -contains 'Applying configuration') { 

} else {
  puppet ssl clean
}

# powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vaal1988/powershell/master/puppet_agent_clean_ssl.ps1'))"

try { 
  puppet agent -t
} catch {
  echo "ssl clean"
  puppet ssl clean
  puppet agent -t
}

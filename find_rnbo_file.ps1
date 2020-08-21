$FindResult = Get-ChildItem -Path 'C:\' -Filter Оперативне` зведення* -Recurse -ErrorAction SilentlyContinue -Force
$WORKSTATION_FQDN = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain

if (!($FindResult -eq $null)) {
  $EmailFrom = "puppet@intergal.com.ua"
  $EmailTo = "v.gusachenko@intergal-bud.com.ua"
  $Subject = "$WORKSTATION_FQDN Оперативне зведення.docx"
  $Body = "$FindResult"
  $SMTPServer = "mail.intergal-bud.com.ua”
  $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
  $SMTPClient.EnableSsl = $true
  $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("puppet@intergal.com.ua", "iuph5Vau6oxohxus")
  $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

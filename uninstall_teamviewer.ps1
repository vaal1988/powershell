# uninstall MSI

    Get-Process -Name "teamviewer*" | Stop-Process -Force
    $app = Get-WmiObject -Class Win32_Product | Where {$_.Name -like "*TeamViewer*" }
    $app.Uninstall()


# uninstall over uninstall.exe /S

    if (Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node") {
    $programs = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction Stop
    }
    $programs += Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction Stop
    $programs += Get-ItemProperty -Path "Registry::\HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue

    $programs = $programs.Where({ $_.DisplayName -like "*TeamViewer*" })

    $output = $programs.ForEach({
        [PSCustomObject]@{
            Name = $_.DisplayName
            Version = $_.DisplayVersion
            Guid = $_.PSChildName
            UninstallString = $_.UninstallString
        }
    })

    if ($variablename) { Write-Host "variable is NOT null" }

    Write-Output -InputObject $output.UninstallString

    $UninstallString = $output.UninstallString
    powershell -command "& '$UninstallString' /S"

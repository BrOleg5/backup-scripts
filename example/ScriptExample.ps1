#requires -version 5.1

# All path is absolute

Import-Module -FullyQualifiedName "path\to\module\BackupModule.psm1"

$BackupDestination = "path\to\bakup"

$PCSources =    "path\to\folder1",
                "path\to\foler2",
                "path\to\folder\file",
                "path\to\file"

$PCDestination = "$BackupDestination\folder1",
                 "$BackupDestination\foler2",
                 "$BackupDestination\folder\file",
                 "$BackupDestination\file"
                
Backup-Process -Sources $PCSources -Destinations $PCDestination -PathToLogFile "$BackupDestination\.log\log.txt"

Write-Host "Backup is successful"

$message = "Press any key to exit."
# Check if running Powershell ISE
if ($psISE)
{
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("$message")
}
else
{
    Write-Host -NoNewLine $message
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}
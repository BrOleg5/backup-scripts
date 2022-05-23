# Android serial number
$SerialNumber = "<phone serial number>"
# Internal Andriod storage
$Phone = "sdcard"
# Android SD-card
$SDCard = "storage/<sdcard number>"

$AndroidSources =  "$Phone/folder1",
                   "$SDCard/folder2",
                   "$SDCard/folder3"
                    
$AndroidDestination = "$BackupDestination\Android"
$ADestinations = "$AndroidDestination\folder1",
                 "$AndroidDestination\foler2",
                 "$AndroidDestination\folder3"

# Wait connect device
Write-Host "Wait to connect smartphone (serial number: $SerialNumber) to computer ..."
adb -s $SerialNumber wait-for-device
Write-Host "Connection successful."

Backup-Android -SerialNumber $SerialNumber -Sources $AndroidSources -Destinations $ADestinations `
               -PathToLogFile "$BackupDestination\.log\log.txt"

Write-Host "Backup Android device is successful. Stop adb server."
adb kill-server

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
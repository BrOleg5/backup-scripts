#requires -version 5.1

$ModulePath = "E:\Projects\Scripts\AutoBackupScripts\modules"

Import-Module -FullyQualifiedName "$ModulePath\BackupModule.psm1"
Import-Module -FullyQualifiedName "$ModulePath\AndroidBackup.psm1"

$BackupDestination = "F:\Backup"

$PCSources = "E:\AutoHotKey Scripts",
             "E:\Books",
             "E:\Conferences",
             "E:\Documents",
             "E:\Events",
             "E:\Games",
             "E:\KeePass",
             "E:\Music",
             "E:\Photo and Video",
             "E:\Projects",
             "E:\Study",
             "E:\Templates and profiles",
             "E:\Wallpapers and avatars",
             "E:\Work",
             "E:\Other",
             "C:\Users\Oleg\.config\joplin-desktop",
             "C:\Users\Oleg\AppData\Roaming\Thunderbird\Profiles",
             "C:\Users\Oleg\Documents\KiCad",
             "C:\Users\Oleg\AppData\Roaming\Code\User\hsnips",
             "C:\Users\Oleg\AppData\Roaming\Code\User\keybindings.json",
             "C:\Users\Oleg\AppData\Roaming\Code\User\settings.json",
             "C:\Users\Oleg\texmf\tex\latex"

$PCDestination = "$BackupDestination\AutoHotKey Scripts",
                 "$BackupDestination\Books",
                 "$BackupDestination\Conferences",
                 "$BackupDestination\Documents",
                 "$BackupDestination\Events",
                 "$BackupDestination\Games",
                 "$BackupDestination\KeePass",
                 "$BackupDestination\Music",
                 "$BackupDestination\Photo and Video",
                 "$BackupDestination\Projects",
                 "$BackupDestination\Study",
                 "$BackupDestination\Templates and profiles",
                 "$BackupDestination\Wallpapers and avatars",
                 "$BackupDestination\Work",
                 "$BackupDestination\Other",
                 "$BackupDestination\Users\Oleg\.config\joplin-desktop",
                 "$BackupDestination\Users\Oleg\AppData\Roaming\Thunderbird\Profiles",
                 "$BackupDestination\Users\Oleg\Documents\KiCad",
                 "$BackupDestination\Users\Oleg\AppData\Roaming\Code\User\hsnips",
                 "$BackupDestination\Users\Oleg\AppData\Roaming\Code\User",
                 "$BackupDestination\Users\Oleg\AppData\Roaming\Code\User",
                 "$BackupDestination\Users\Oleg\texmf\tex\latex"
                
Backup-Process -Sources $PCSources -Destinations $PCDestination -PathToLogFile "$BackupDestination\.log\log pc.txt"

# Android serial number
$SerialNumber = "80fbca55"
# Internal Andriod storage
$Phone = "sdcard"
# Android SD-card
$SDCard = "storage/5C11-6780"

$AndroidSources =  "$Phone/DCIM",
                   "$SDCard/DCIM/Camera",
                   "$SDCard/Music"
                    
$AndroidDestination = "$BackupDestination\Android"
$ADestinations = "$AndroidDestination\Phone",
                 "$AndroidDestination\SD card",
                 "$AndroidDestination\SD card"

# Wait connect device
Write-Host "Wait to connect smartphone (serial number: $SerialNumber) to computer ..."
adb -s $SerialNumber wait-for-device
Write-Host "Connection successful."

Backup-Android -SerialNumber $SerialNumber -Sources $AndroidSources -Destinations $ADestinations `
               -PathToLogFile "$BackupDestination\.log\log android.txt"

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
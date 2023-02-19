#requires -version 5.1

$ModulePath = "E:\Projects\Scripts\AutoBackupScripts\modules"

Import-Module -FullyQualifiedName "$ModulePath\BackupModule.psm1"
Import-Module -FullyQualifiedName "$ModulePath\AndroidBackup.psm1"

class SourceDestination {
    [string[]] $Source
    [string[]] $Destination

    [void] AddItem([string] $src, [string] $dst) {
        $this.Source += $src
        $this.Destination += $dst
    }
}

$PCSourceDestination = [SourceDestination]::new()

$PCSourceDestination.AddItem("E:\AutoHotKey Scripts",                                       "AutoHotKey Scripts")
$PCSourceDestination.AddItem("E:\Books",                                                    "Books")
$PCSourceDestination.AddItem("E:\Documents",                                                "Documents")
$PCSourceDestination.AddItem("E:\Events",                                                   "Events")
$PCSourceDestination.AddItem("E:\Games",                                                    "Games")
$PCSourceDestination.AddItem("E:\KeePass",                                                  "KeePass")
$PCSourceDestination.AddItem("E:\Music",                                                    "Music")
$PCSourceDestination.AddItem("E:\Photo and Video",                                          "Photo and Video")
$PCSourceDestination.AddItem("E:\Projects",                                                 "Projects")
$PCSourceDestination.AddItem("E:\Study",                                                    "Study")
$PCSourceDestination.AddItem("E:\Templates and profiles",                                   "Templates and profiles")
$PCSourceDestination.AddItem("E:\Wallpapers and avatars",                                   "Wallpapers and avatars")
$PCSourceDestination.AddItem("E:\Work",                                                     "Work")
$PCSourceDestination.AddItem("E:\Other",                                                    "Other")
$PCSourceDestination.AddItem("C:\Users\Oleg\.config\joplin-desktop",                        "Users\Oleg\.config\joplin-desktop")
$PCSourceDestination.AddItem("C:\Users\Oleg\AppData\Roaming\Thunderbird\Profiles",          "Users\Oleg\AppData\Roaming\Thunderbird\Profiles")
$PCSourceDestination.AddItem("C:\Users\Oleg\Documents\KiCad",                               "Users\Oleg\Documents\KiCad")
$PCSourceDestination.AddItem("C:\Users\Oleg\AppData\Roaming\Code\User\hsnips",              "Users\Oleg\AppData\Roaming\Code\User\hsnips")
$PCSourceDestination.AddItem("C:\Users\Oleg\AppData\Roaming\Code\User\keybindings.json",    "Users\Oleg\AppData\Roaming\Code\User")
$PCSourceDestination.AddItem("C:\Users\Oleg\AppData\Roaming\Code\User\settings.json",       "Users\Oleg\AppData\Roaming\Code\User")
$PCSourceDestination.AddItem("C:\Users\Oleg\texmf\tex\latex",                               "Users\Oleg\texmf\tex\latex")
$PCSourceDestination.AddItem("C:\Users\Oleg\Zotero",                                        "Users\Oleg\Zotero")

$BackupDestinations = "F:\Backup", "H:\Backup"

foreach ($destination in $BackupDestinations) {
    $FullDestinations = $PCSourceDestination.Destination | ForEach-Object -Process {Join-Path -Path $destination -ChildPath $_}
    
    Backup-Process -Sources $PCSourceDestination.Source -Destinations $FullDestinations -PathToLogFile "$destination\.log\log pc.txt"
}

# Android serial number
# To find out serial numbe
#  1) connect your phone to computer by USB
#  2) turn on USB Debigging (in Developer options)
#  3) run command `adb devices` in shell
# You see serial number of your phone in command output
$SerialNumber = "80fbca55"
# Internal Andriod storage
$Phone = "sdcard"
# Android SD-card
$SDCard = "storage/5C11-6780"

$AndroidSourceDestination = [SourceDestination]::new()

$AndroidSourceDestination.AddItem("$Phone/DCIM", "Android\Phone")
$AndroidSourceDestination.AddItem("$SDCard/DCIM/Camera", "Android\SD card")
$AndroidSourceDestination.AddItem("$SDCard/Music", "Android\SD card")

# Wait connect device
Write-Host "Wait to connect smartphone (serial number: $SerialNumber) to computer ..."
adb -s $SerialNumber wait-for-device
Write-Host "Connection successful."

foreach ($destination in $BackupDestinations) {
    $FullDestinations = $AndroidSourceDestination.Destination | ForEach-Object -Process {Join-Path -Path $destination -ChildPath $_}
    
    Backup-Android -SerialNumber $SerialNumber -Sources $AndroidSourceDestination.Source -Destinations $FullDestinations `
               -PathToLogFile "$destination\.log\log android.txt"
}

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
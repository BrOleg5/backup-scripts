#requires -version 5.1

Import-Module -FullyQualifiedName "E:\Projects\Scripts\AutoBackupScripts\modules\BackupModule.psm1"
Import-Module -FullyQualifiedName "E:\Projects\Scripts\AutoBackupScripts\modules\AndroidBackup.psm1"

$BackupDestination = "F:\Backup"

$PCSources =    "E:\AutoHotKey Scripts", `
                "E:\Books", `
                "E:\Conferences", `
                "E:\Documents", `
                "E:\Events", `
                "E:\Games", `
                "E:\KeePass", `
                "E:\Music", `
                "E:\Papers", `
                "E:\Photo and Video", `
                "E:\Projects", `
                "E:\Study", `
                "E:\Templates and profiles", `
                "E:\Wallpapers and avatars", `
                "E:\Work",
                "E:\Other",
                "C:\Users\Oleg\.config\joplin-desktop"

Backup-Process -Sources $PCSources -Destination $BackupDestination

$AndroidSources =   "phone/DCIM",
                    "sdcard/DCIM/Camera",
                    "sdcard/Music"

# For run adb daemon in smartphone
Write-Host 'Connect you smartphone to computer. Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
adb devices

Start-Sleep -Seconds 10

Backup-Android -Sources $AndroidSources -Destination "$BackupDestination\Android"

Write-Host 'Press any key to exit.';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
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
                "E:\Work"

Backup-Process -Sources $PCSources -Destination $BackupDestination

$AndroidSources =  "phone/DCIM",
            "sdcard/DCIM/Camera",
            "sdcard/Music"

Backup-Android -Sources $AndroidSources -Destination "$BackupDestination\Android"

shutdown /s
#requires -version 5.1

Import-Module -FullyQualifiedName "E:\Projects\Scripts\AutoBackupScript\modules\BackupModule.psm1"

$Sources =  "E:\AutoHotKey Scripts", `
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

Backup-Process -Sources $Sources -Destination "H:\Backup"

shutdown /s
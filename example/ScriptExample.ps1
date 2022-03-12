#requires -version 5.1

Import-Module -FullyQualifiedName "C:\path\to\module\BackupModule.psm1"

$Sources =  "C:\Folder 1", `
            "C:\Folder 2", `
            "C:\Folder 3", `
            "C:\Folder 4", `
            "C:\Folder 5", `
            "C:\Folder 6", `
            "C:\Folder 7", `
            "C:\Folder 8", `
            "C:\Folder 9", `
            "C:\Folder 10", `
            "C:\Folder 11"

Backup-Process -Sources $Sources -Destination "D:\path\to\backup\destination"
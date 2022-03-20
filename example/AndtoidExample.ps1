#requires -version 5.1

Import-Module -FullyQualifiedName "E:\Projects\Scripts\AutoBackupScripts\modules\AndroidBackup.psm1"

$Sources =  "phone/DCIM",
            "sdcard/DCIM/Camera",
            "sdcard/Music"

Backup-Android -Sources $Sources -Destination "E:\Dump\AndroidBackup"
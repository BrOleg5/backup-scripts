#requires -version 5.1

# Stop scrip on any error
$ErrorActionPreference = "Stop"

function Backup-Android {
    <#
        .SYNOPSIS
        Backup android directories using Android Debug Bridge (adb).

        .DESCRIPTION
        Function copy directories from Android Sources to computer Destinations.
        Both internal and external Android storage can be backuped.

        .PARAMETER SerialNumber
        Serial number of Android device.

        .PARAMETER Sources
        Specify paths to directories in Android device that require to backup.

        .PARAMETER Destinations
        Specify destination backup paths.

        .PARAMETER PathToLogFile
        Specify path to backup log file

        .EXAMPLE
        $Phone = "sdcard"
        $SDCard = "storage/6H47-8632"
        $src = "$Phone/folder 1/subfolder 2", "$SDCard/Users/user/some folder"
        $dest = "E:/Backup/folder 1/subfolder 2", "E:/Backup/Users/user/some folder"
        Backup-Android -Sources $src -Destinations $dest -PathToLogFile "E:\Backup\.log\log.txt"
    #>

    Param(
        [Parameter(Mandatory)]
        [string]
        $SerialNumber,
        [Parameter(Mandatory)]
        [string[]]
        $Sources,
        [Parameter(Mandatory)]
        [string[]]
        $Destinations,
        [Parameter(Mandatory)]
        [string]
        $PathToLogFile
    )

    # Number of sourses and destinations must be equal
    if ($Sources.Count -ne $Destinations.Count) {
        Throw "Number of sourses and destinations must be equal! Sources number: $($Sources.Count); Destination number: $($Destinations.Count)"
    }

    # Remove existing log file
    if (Test-Path -Path $PathToLogFile) {
        # Remove log file
        try {           
            Remove-Item -Path $PathToLogFile
        }
        catch {
            Throw "Log file ""$PathToLogFile"" were not removed!"
        }
    }
    # Create new log file with unicode encoding
    Out-File -FilePath $PathToLogFile -Encoding utf8

    # Number of backup directories
    [int32] $NumDirs = $Sources.Count
    # Copy backup
    for ($i = 0; $i -lt $NumDirs; $i++) {
        Write-Progress -Activity "Backuping" -Status "Progress ..." -CurrentOperation "Copy from ""$($Sources[$i])"" to ""$($Destinations[$i])""" `
                       -PercentComplete ($i/$NumDirs*100)
          # Check existing of backup destination path
        if (-not (Test-Path -Path $Destinations[$i])) {
            # Create backup destination
            try {
                New-Item -Path $Destinations[$i] -ItemType Directory
            }
            catch {
                Throw "Backup destination ""$($Destinations[$i])"" were not created!"
            }
        }
        # Clear detination folder
        else {
            Remove-Item -Path $Destinations[$i] -Recurse
        }
        $log_message = adb -s $SerialNumber pull $Sources[$i] $Destinations[$i]
        $log_message | Out-File -FilePath $PathToLogFile -Encoding utf8 -Append
    }
    Write-Progress -Activity "Backuping" -Completed
}
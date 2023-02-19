#requires -version 5.1

# Stop scrip on any error
$ErrorActionPreference = "Stop"

function Backup-Process {
    <#
        .SYNOPSIS
        Automatic copy backup.

        .DESCRIPTION
        Function copy directories from Sources to Destinations.

        .PARAMETER Sources
        Specify paths to directories that require to backup.

        .PARAMETER Destinations
        Specify destination backup paths.

        .PARAMETER PathToLogFile
        Specify path to backup log file.

        .EXAMPLE
        $src = "D:/folder 1/subfolder 2", "C:/Users/user/some folder"
        $dest = "E:/Backup/folder 1/subfolder 2", "E:/Backup/Users/user/some folder"
        Backup-Process -SerialNumber "86fbca53" -Sources $src -Destinations $dest -PathToLogFile "E:\Backup\.log\log.txt"
    #>

    Param(
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_})]
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

    # Number of backup items (files, directories)
    [int32] $NumItem = $Sources.Count
    # Copy backup
    for ($i = 0; $i -lt $NumItem; $i++) {
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
        Write-Progress -Activity "Backuping" -Status "Progress ..." -CurrentOperation "Copy from ""$($Sources[$i])"" to ""$($Destinations[$i])""" `
                       -PercentComplete ($i/$NumItem*100)
        # Check that path refers to directory
        if ((Get-Item -Path $Sources[$i]).PSisContainer) {
            $tmp = robocopy $Sources[$i] $Destinations[$i] /mir /dcopy:DAT /MT:8 /eta /r:5 /w:5 `
                            /unilog+:$PathToLogFile   
        }
        # else path refers to file
        else {
            $FilePath = Split-Path -Path $Sources[$i] -Parent
            $FileName = Split-Path -Path $Sources[$i] -Leaf -Resolve
            $tmp = robocopy $FilePath $Destinations[$i] $FileName /mir /dcopy:DAT /MT:8 /eta /r:5 /w:5 `
                            /unilog+:$PathToLogFile
        }
    }
    Write-Progress -Activity "Backuping" -Completed
}
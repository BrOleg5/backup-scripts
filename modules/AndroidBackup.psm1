#requires -version 5.1

# Stop scrip on any error
$ErrorActionPreference = "Stop"

function Backup-Android {
    <#
        .SYNOPSIS

        Automatic copy backup.

        .DESCRIPTION

        Script archives required directories and saves directory hierarchy.
        Every archive is encrypted with generated password.
        All passwords are saved in text file (txt).
        Encrypted archives and text file copy to every backup destination.

        .PARAMETER InputPaths
        Specifies paths that requires to backup.

        .PARAMETER OutputPaths
        Specifies destinations backup paths.

        .PARAMETER WorkingDirectory
        Specifies working directory. It is temporary store of backup.

        .PARAMETER ImportPath
        Specifies path to PasswordGenerators module.

        .EXAMPLE
    #>

    Param(
        # Device serial number
        [Parameter(Mandatory)]
        [string]
        $SerialNumber,
        # Paths to backup directories
        [Parameter(Mandatory)]
        [string[]]
        $Sources,
        # Paths to backup destinations
        [Parameter(Mandatory)]
        [string[]]
        $Destinations,
        # Path to log file
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
#requires -version 5.1

# Stop scrip on any error
$ErrorActionPreference = "Stop"

function Backup-Process {
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
        # Paths to backup directories
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_})]
        [string[]]
        $Sources,
        # Paths to backup destination
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
                       -PercentComplete ($i/$NumDirs*100)
        $tmp = robocopy $Sources[$i] $Destinations[$i] /mir /dcopy:DAT /MT:8 /eta /r:5 /w:5 `
                        /unilog+:$PathToLogFile
    }
    Write-Progress -Activity "Backuping" -Completed
}
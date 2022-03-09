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
        # Path to backup destination
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_})]
        [string]
        $Destination
    )

    # Check existing of backup destination path
    Write-Progress -Activity "Backuping" -Status "Starting ..." -CurrentOperation "Check existing of backup destination path" `
                   -PercentComplete 0
    if (-not (Test-Path -Path $Destination)) {
        # Create backup destination
        Write-Progress -Activity "Backuping" -Status "Starting ..." `
                       -CurrentOperation "Create backup destination" `
                       -PercentComplete 0
        try {
            New-Item -Path $Destination -ItemType Directory
        }
        catch {
            Throw "Backup destination ""$Destination"" were not created!"
        }
    }

    # Create log directory in backup destination
    $PathToLogFile = Join-Path -Path $Destination -ChildPath ".log"
    # Check existing of log directory
    Write-Progress -Activity "Backuping" -Status "Starting ..." -CurrentOperation "Check existing of log directory" `
                   -PercentComplete 0
    if (-not (Test-Path -Path $PathToLogFile)) {
        # Create log directory
        Write-Progress -Activity "Backuping" -Status "Starting ..." -CurrentOperation "Create log directory" `
                   -PercentComplete 0
        try {
            New-Item -Path $PathToLogFile -ItemType Directory
        }
        catch {
            Throw "Log directory ""$PathToLogFile"" were not created!"
        }
    }
    # Remove existing log file
    $PathToLogFile = Join-Path -Path $PathToLogFile -ChildPath "log.txt"
    if (Test-Path -Path $PathToLogFile) {
        # Remove log file
        Write-Progress -Activity "Backuping" -Status "Starting ..." -CurrentOperation "Remove existing log file" `
                       -PercentComplete 0
        try {           
            Remove-Item -Path $PathToLogFile
        }
        catch {
            Throw "Log file ""$PathToLogFile"" were not removed!"
        }
    }
    # Create new log file with unicode encoding
    Write-Progress -Activity "Backuping" -Status "Starting ..." -CurrentOperation "Create new log file with unicode encoding" `
                   -PercentComplete 0
    Out-File -FilePath $PathToLogFile -Encoding utf8

    # Number of backup directories
    [int32] $NumDirs = $Sources.Length
    # Iterator for progress bar
    [int32] $i = 0
    # Copy backup
    foreach ($Item in $Sources) {
        $ItemName = Split-Path -Path $Item -Leaf
        $SubDestination = Join-Path -Path $Destination -ChildPath $ItemName
        Write-Progress -Activity "Backuping" -Status "Progress ..." -CurrentOperation "Copy ""$SubDestination""" `
                       -PercentComplete ($i/$NumDirs*100)
        $tmp = robocopy $Item $SubDestination /mir /dcopy:DAT /MT:8 /eta /r:5 /w:5 `
                        /unilog+:$PathToLogFile
        $i = $i + 1
    }
    Write-Progress -Activity "Backuping" -Completed
}
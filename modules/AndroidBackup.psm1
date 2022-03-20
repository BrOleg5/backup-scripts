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
        # Paths to backup directories
        [Parameter(Mandatory)]
        [string[]]
        $Sources,
        # Path to backup destination
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_})]
        [string]
        $Destination
    )

    Remove-Item -Path $Destination -Exclude ".log" -Recurse

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

    # Internal android path
    $InternalStorage = "sdcard"

    # Define external sd-card storage
    $StorageFolders = adb shell ls storage
    $SdCard = "storage", $StorageFolders[0] -join "/"

    # Number of backup directories
    [int32] $NumDirs = $Sources.Length
    # Iterator for progress bar
    [int32] $i = 0
    # Copy backup
    foreach ($Item in $Sources) {
        $SplitedPath = $Item -split "/"
        if ($SplitedPath[0] -eq "phone") {
            $SplitedPath[0] = $InternalStorage
        }
        elseif ($SplitedPath[0] -eq "sdcard") {
            $SplitedPath[0] = $SdCard
        }
        $PreprocessPath = $SplitedPath -join "/"
        Write-Progress -Activity "Backuping" -Status "Progress ..." -CurrentOperation "Copy ""$PreprocessPath""" `
                       -PercentComplete ($i/$NumDirs*100)
        $ItemName = Split-Path -Path $PreprocessPath -Parent
        $SubDestination = Join-Path -Path $Destination -ChildPath $ItemName
        if (-not (Test-Path -Path $SubDestination)) {
            try {           
                New-Item -Path $SubDestination -ItemType Directory
            }
            catch {
                Throw "Directory ""$SubDestination"" were not created!"
            }
        }
        $log_message = adb pull $PreprocessPath $SubDestination
        $log_message | Out-File -FilePath $PathToLogFile -Encoding utf8 -Append
        $i = $i + 1
    }
    Write-Progress -Activity "Backuping" -Completed
}